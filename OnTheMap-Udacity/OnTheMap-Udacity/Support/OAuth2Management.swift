//
//  OAuth2Management.swift
//  OnTheMap-Udacity
//
//  Created by Daniela Velasquez on 1/8/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit
import FBSDKLoginKit

protocol OAuth2ManagementProtocol : class {
    func oauth2LoginSuccess(service: ServiceName)
    func oauth2LoginFail(error: NSError?, service: ServiceName)
}

protocol OAuth2ManagementLogoutProtocol : class {
    func oauth2LogoutSuccess()
    func oauth2LogoutFail(error: NSError?)
}

enum ServiceName: String {
    case Facebook = "facebook"
}

class MSOAuth2: NSObject {
    
    var consumerKey: String?
    var consumerSecret: String?
    var authorizeUrl: String?
    var accessTokenUrl: String?
    var responseType: String?
    var serviceName: ServiceName?
    var delegate: OAuth2ManagementProtocol?
    var delegateLogout: OAuth2ManagementProtocol?
    
    let deltha:CGFloat = 50.0
    
    class var instance: MSOAuth2 {
        
        struct Static {
            static var instance: MSOAuth2?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = MSOAuth2()
        }
        
        return Static.instance!
    }
    
    required override init(){
        
    }
    
    
    //MARK: Buttons management methods
    func addButton(serviceName: ServiceName, position: CGFloat) -> AnyObject?{
       
        switch(serviceName){
         case .Facebook:
           return facebookButton(position)
        }
    
    }
    
    
    func facebookButton(position: CGFloat = 0) -> FBSDKLoginButton{
        
        let facebookBtn = FBSDKLoginButton(frame: CGRectMake(0, 0, 200, 40))
        facebookBtn.delegate = self
        facebookBtn.center = CGPoint(x: ScreenSize.width/2, y: ScreenSize.height - deltha)
        
        return facebookBtn
    }
    
    
    //MARK: Logout methods
    func logout(){
            FBSDKLoginManager().logOut()
    }
    
}

extension MSOAuth2: FBSDKLoginButtonDelegate{
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if !result.isCancelled {
            self.consumerSecret = result.token.tokenString
            self.consumerKey    = result.token.tokenString
            
            NSNotificationCenter.defaultCenter().postNotificationName(
                "ToggleAuthUINotification",
                object: nil,
                userInfo: ["statusText": "Signed in user"])
            
            self.delegate!.oauth2LoginSuccess(.Facebook)
        }else{
            if let errorT = error{
                self.delegate!.oauth2LoginFail(errorT, service: .Facebook)
            }else{
                self.delegate!.oauth2LoginFail(nil, service: .Facebook)
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
    
}


