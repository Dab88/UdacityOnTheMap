//
//  APIConnection.swift
//  OnTheMap-Udacity
//
//  Created by Daniela Velasquez on 12/15/15.
//  Copyright © 2015 Mahisoft. All rights reserved.
//

import UIKit

public enum Method: String {
    case GET = "GET"
    case POST = "POST"
    case DELETE = "DELETE"
    case PUT = "PUT"
}


/**
 * APIConnectionProtocol
 */
@objc protocol APIConnectionProtocol : NSObjectProtocol {
    /**
     * @author: Daniela Velasquez
     * Delegate Funtion - ConnectionAPIProtocol
     * Is called when the request success
     */
    func  didReceiveAPIResultsSuccess(results results: AnyObject, path: String, serverTag: String)
    
    /**
     * @author: Daniela Velasquez
     * Delegate Funtion - ConnectionAPIProtocol
     * Is called when the request failed
     */
    func didReceiveAPIResultsFailed(error error: NSError, errorObject: AnyObject, path: String, serverTag: String)
    
    /**
     * @author: Daniela Velasquez
     * Delegate Funtion - APIConnectionProtocol
     */
    optional func prepareRequest(parametersArray:[String:AnyObject]) -> AnyObject
}

class APIConnection: NSObject {
    
    var delegate: APIConnectionProtocol?
    var session = NSURLSession.sharedSession()
    
    
    class var instance: APIConnection {
        
        struct Static {
            static var instance: APIConnection?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = APIConnection()
        }
        return Static.instance!
    }
    
    
    override init() {
        self.delegate = nil
    }
    
    init(delegate: APIConnectionProtocol) {
        self.delegate = delegate
    }
    
    /**
     * @author: Daniela Velasquez
     * Request Adapter
     */
    func get(path: String, parametersArray: [String : AnyObject]?, serverTag: String, parseRequest:Bool = false) {
        
        self.request(.GET, path: path, parametersArray: parametersArray, serverTag: serverTag, parseRequest: parseRequest)
    }
    
    
    /**
     * @author: Daniela Velasquez
     * Request Adapter
     */
    func post(path: String, parametersArray: [String : AnyObject]? = nil, serverTag: String, parseRequest:Bool = false) {
        
        self.request(.POST, path: path, parametersArray: parametersArray, serverTag: serverTag, parseRequest: parseRequest)
        
    }
    
    /**
     * @author: Daniela Velasquez
     * Request Adapter
     */
    func put(path: String, parametersArray: [String : AnyObject]?, serverTag: String, parseRequest:Bool = false) {
        
        self.request(.PUT, path: path, parametersArray: parametersArray, serverTag: serverTag, parseRequest: parseRequest)
        
    }
    
    /**
     * @author: Daniela Velasquez
     * Request Adapter
     */
    func delete(path: String, parametersArray: [String : AnyObject]? = nil, serverTag: String, parseRequest:Bool = false) {
        self.request(.DELETE, path: path, parametersArray: parametersArray, serverTag: serverTag, parseRequest: parseRequest)
        
    }
    
    func request(method: Method, path: String, parametersArray: [String : AnyObject]?, serverTag: String, parseRequest:Bool = false) {
        
        print("\n\(serverTag) - \(method.rawValue)\nURL:  \(path)\n")
        if let param = parametersArray{
            print("PARAMETER REQUEST: \n \(param.description)\n")
        }
        
        var urlString = path
        let request = NSMutableURLRequest()
        
        if method != .GET {
            
            if let param = parametersArray{
                do {
                    request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(param, options: [])
                } catch _ as NSError {
                    request.HTTPBody = nil
                }
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
        }else {
            if let param = parametersArray{
                urlString += "?"
                for (key, value) in param {
                    let valueEncoded = value.description!.stringByAddingPercentEncodingWithAllowedCharacters(.URLQueryAllowedCharacterSet())
                    urlString += key + "=" + (valueEncoded!.stringByReplacingOccurrencesOfString("+", withString: "%2B")) + "&"
                }
            }
        }
        
        
        if (method == .DELETE){
            var xsrfCookie: NSHTTPCookie? = nil
            let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
        }
        
        
        if(parseRequest){
            request.addValue(APISettings.PARSE_ID, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(APISettings.REST_API_KEY, forHTTPHeaderField: "X-Parse-REST-API-Key")
        }
        
        request.HTTPMethod = method.rawValue
        request.URL = NSURL(string: urlString)
        
        let task = session.dataTaskWithRequest(request, completionHandler: { data, response, error -> Void in
            
            var errorObject:NSError?
            
            if(response != nil){
                print("Response code: \((response as! NSHTTPURLResponse).statusCode)")
                
                if(self.errorResponse((response as! NSHTTPURLResponse).statusCode)){
                    var errorMessage = "Request Error"
                    
                    if(data != nil){
                        var validData = data
                        
                        if(!parseRequest){
                            validData = validData!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
                        }
                        
                        let jsonResponse = self.getJSON(validData!, response: (response as! NSHTTPURLResponse))
                        
                        if let json = jsonResponse as? NSDictionary{
                            if(json["error"] != nil){
                                errorMessage = json["error"] as! String
                            }
                        }
                    }
                    
                    errorObject = NSError(domain: errorMessage, code: (response as! NSHTTPURLResponse).statusCode, userInfo: nil)
                    
                }else{
                    
                    if(data != nil){
                        var result: AnyObject?
                        
                        var validData = data
                        
                        if(!parseRequest){
                            validData = validData!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
                        }
                        
                        print("Body: \(NSString(data: validData!, encoding: NSUTF8StringEncoding))")
                        
                        do{
                            if let parseJSON = try NSJSONSerialization.JSONObjectWithData(validData!, options: .MutableLeaves) as? NSDictionary{
                                result = parseJSON
                            }
                        }catch{
                            errorObject = NSError(domain: "Malformed JSON", code: (response as! NSHTTPURLResponse).statusCode, userInfo: nil)
                        }
                        
                        if let result = result{
                            self.delegate?.didReceiveAPIResultsSuccess(results: result, path: path, serverTag: serverTag)
                            
                            return
                        }
                        
                    }else if (error != nil) {
                        errorObject = error
                    }
                }
            }
            
            if let errorObject = errorObject{
                self.delegate?.didReceiveAPIResultsFailed(error: errorObject, errorObject: errorObject, path: path, serverTag: serverTag)
            }
            
        })
        
        task.resume()
    }
    
    
    func getJSON(validData: NSData, response: NSHTTPURLResponse) -> AnyObject?{
        
        do{
            if let parseJSON = try NSJSONSerialization.JSONObjectWithData(validData, options: .MutableLeaves) as? NSDictionary{
                return parseJSON
            }
        }catch{
            return NSError(domain: "Malformed JSON", code: response.statusCode, userInfo: nil)
        }
        
        return  NSError(domain: "Malformed JSON", code: response.statusCode, userInfo: nil)
    }
    
    func errorResponse(statusCode: Int) -> Bool {
        if statusCode < 200 || statusCode >= 300 {
            return true
        }
        
        return false
    }
    
}
