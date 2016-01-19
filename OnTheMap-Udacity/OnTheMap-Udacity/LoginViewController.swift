//
//  ViewController.swift
//  OnTheMap-Udacity
//
//  Created by Daniela Velasquez on 12/14/15.
//  Copyright © 2015 Mahisoft. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: ConnectionViewController {
    
    //TextFields
    @IBOutlet weak var usernameTxtField: MSTextField!
    @IBOutlet weak var passwordTxtField: MSTextField!
    
    var oauth2Control = MSOAuth2()
    var fbButton:UIButton?
    var studentLocations:[StudentLocationObject]?
    
    //MARK: Life Cycle Methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        oauth2Control = MSOAuth2.instance
        oauth2Control.delegate = self
        oauth2Control.logout()
        
        //Add gesture from hide keyboard when the user touch the screen
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hideKeyboard"))
        
        // usernameTxtField.text = "dvelasquez@mahisoft.com"
        //passwordTxtField.text = "Mahisoft1234"
        
        let attributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "Roboto", size: 14)!
        ]
        
        usernameTxtField.attributedPlaceholder = NSAttributedString(string: usernameTxtField.placeholder!, attributes:attributes)
        
        passwordTxtField.attributedPlaceholder = NSAttributedString(string: passwordTxtField.placeholder!, attributes:attributes)
        
        showRequestMode(show: false)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        fbButton?.removeFromSuperview()
        
        //Set oauth2 buttons
        setFacebookBtn(1)
        
        showRequestMode(show: false)
    }
    
    /**
     * Add Facebook login button in the specific position
     * @param: Button position
     */
    func setFacebookBtn(position: CGFloat = 1){
        fbButton = oauth2Control.addButton(.Facebook, position: position) as! FBSDKLoginButton
        self.view.addSubview(fbButton!)
        fbButton?.sendSubviewToBack(view)
        overlay.bringSubviewToFront(fbButton!)
        activityIndicator.bringSubviewToFront(overlay)
    }
    
    /**
     * @author: Daniela Velasquez
     * Make body request from request.
     * @return: { "udacity": {"username": "account@domain.com", "password": "********"}}
     */
    func setBodyParameters()-> [String : AnyObject]{
        
        let credentials:NSMutableDictionary = NSMutableDictionary()
        
        credentials["username"]  = usernameTxtField.text
        credentials["password"] = passwordTxtField.text
        
        let params:NSMutableDictionary = NSMutableDictionary()
        
        params["udacity"]  = credentials
        
        let parameters:NSDictionary = params
        
        return parameters as! [String : AnyObject]
        
    }
    
    /**
     * @author: Daniela Velasquez
     * Make body request from request.
     * @return: JSON with the next struct
     {
     "facebook_mobile": {
     "access_token": "CAAFMS4SN9e8BAJZAavcM8syA8iNkQVjpgf6CkU9pYNXZBG5UNRYkk1w5Lf5GoNvMG4UQ0nUadnEPcdhQxZCuwvWOPaYZAaFCoO8UZB0mnznVO37Tu8cUnQgQqi9OlqTzMwcQZBjHNnRIIpkgZCxGkdv9oBehOUrkOCuoX2zle2lV7vi0ippaJwxnr2Linan1UlBQRSAdgshwQkyLfN6ps6nyke79o5sSoZBnH9Vr7ZBXSegZDZD;"
     }
     }
     */
    func setFacebookBodyParameters()-> [String : AnyObject]{
        
        
        let credentials:NSMutableDictionary = NSMutableDictionary()
        
        credentials["access_token"] = MSOAuth2.instance.consumerKey! as String
        
        let params:NSMutableDictionary = NSMutableDictionary()
        
        params["facebook_mobile"]  = credentials
        
        let parameters:NSDictionary = params
        
        return parameters as! [String : AnyObject]
    }
    
    func emptyFields() -> Bool{
        return ((usernameTxtField.text?.isEmpty == true) || (passwordTxtField.text?.isEmpty == true))
    }
    
    
    
    //MARK: IBAction Methods
    @IBAction func loginRequestAction(sender: AnyObject) {
        
        guard !emptyFields() else{
            showAlert("Sorry!", message: "You need fill the password and email fields.")
            return
        }
        
        showRequestMode(show: true)
        connectionAPI.post(APISettings.BASE_URL + APISettings.URI_LOGIN, parametersArray: setBodyParameters(), serverTag: "tagLogin")
    }
    
    @IBAction func goToUdacitySignUp(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: APISettings.SIGN_UP_URL)!)
    }
    
    
    //MARK: Facebook
    func loginWithFacebook(){
        
        guard MSOAuth2.instance.consumerKey != nil else{
            showAlert("Sorry!", message: "Access Token is empty")
            return
        }
        
        showRequestMode(show: true)
        connectionAPI.post(APISettings.BASE_URL + APISettings.URI_LOGIN, parametersArray: setFacebookBodyParameters(), serverTag: "tagLoginFb")
    }
    
    
    
    //MARK: - NavigationBar Methods
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "goToMap"){
            //Send the studentLocations info to the next view
            UserSession.instance.studentLocations = studentLocations
        }
    }
    
    //MARK: APIConnectionProtocol Methods
    override func didReceiveAPIResultsSuccess(results results: AnyObject, path: String, serverTag: String) {
        
        showRequestMode(show: false)
        
        dispatch_async(dispatch_get_main_queue()) {
            UserSession.instance.info = LoginResponse(data: results as! [String: AnyObject])
            self.performSegueWithIdentifier("goToMap", sender: self)
        }
    }
}



//MARK: MSOAuth2Protocol
extension LoginViewController: OAuth2ManagementProtocol{
    
    func oauth2LoginSuccess(serviceName: ServiceName){
        
        MSOAuth2.instance.serviceName = serviceName
        
        //if(self.available()){
        
        loginWithFacebook()
        
        
        // }
    }
    
    func oauth2LoginFail(error: NSError?, service: ServiceName) {
        self.showAlert("Sorry!", message: "Login problems")
    }
    
}

extension LoginViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        guard textField != usernameTxtField else{
            passwordTxtField.becomeFirstResponder()
            return true
        }
        
        textField.resignFirstResponder()
        
        return true
    }
}


