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
    
    
    //MARK: Life Cycle Methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        oauth2Control = MSOAuth2.instance
        oauth2Control.delegate = self
        oauth2Control.logout()
        
        //Add gesture from hide keyboard when the user touch the screen
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hideKeyboard"))
        
        setInterfaceDetails()
        
        showRequestMode(show: false)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //Set oauth2 buttons
        setFacebookBtn(1)
        
        showRequestMode(show: false)
    }
    
    //MARK: IBAction Methods
    @IBAction func loginRequestAction(sender: AnyObject) {
        
        guard !emptyFields() else{
            showAlert(Messages.titleAlert, message: Messages.mFieldsEmpty)
            return
        }
        if(self.available()){
            showRequestMode(show: true)
            connectionAPI.post(APISettings.BASE_URL + APISettings.URI_LOGIN, parametersArray: setBodyParameters(), serverTag: APISettings.tagAuth)
        }
       
    }
    
    @IBAction func goToUdacitySignUp(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: APISettings.SIGN_UP_URL)!)
    }
    
    
    //MARK: Facebook
    func loginWithFacebook(){
        
        guard MSOAuth2.instance.consumerKey != nil else{
            showAlert(Messages.titleAlert, message: Messages.mAccessTokenEmpty)
            return
        }
        
        showRequestMode(show: true)
        connectionAPI.post(APISettings.BASE_URL + APISettings.URI_LOGIN, parametersArray: setFacebookBodyParameters(), serverTag: APISettings.tagFB)
    }
    
    
    
    //MARK: - NavigationBar Methods
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    //MARK: APIConnectionProtocol Methods
    override func didReceiveAPIResultsSuccess(results results: AnyObject, path: String, serverTag: String) {
        
        dispatch_async(dispatch_get_main_queue()) {
            self.showRequestMode(show: false)
            UserSession.instance.info = LoginResponse(data: results as! [String: AnyObject])
            self.performSegueWithIdentifier("goToMap", sender: self)
        }
    }
    
    override func didReceiveAPIResultsFailed(error error: NSError, errorObject: AnyObject, path: String, serverTag: String) {
        
        super.didReceiveAPIResultsFailed(error: error, errorObject: errorObject, path: path, serverTag: serverTag)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.showRequestMode(show: false)
            self.showAlert(errorObject.domain)
            
        }
    }
    
    //MARK: Other Methods
    
    /**
    * Add Facebook login button in the specific position
    * @param: Button position
    */
    func setFacebookBtn(position: CGFloat = 1){
        fbButton?.removeFromSuperview()
        
        fbButton = oauth2Control.addButton(.Facebook, position: position) as! FBSDKLoginButton
        self.view.addSubview(fbButton!)
        fbButton?.sendSubviewToBack(view)
        overlay.bringSubviewToFront(fbButton!)
        activityIndicator.bringSubviewToFront(overlay)
    }
    
    
    func setInterfaceDetails(){
        let attributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: Interface.fontFamily, size: 14)!
        ]
        
        usernameTxtField.attributedPlaceholder = NSAttributedString(string: usernameTxtField.placeholder!, attributes:attributes)
        
        passwordTxtField.attributedPlaceholder = NSAttributedString(string: passwordTxtField.placeholder!, attributes:attributes)
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
}



//MARK: MSOAuth2Protocol
extension LoginViewController: OAuth2ManagementProtocol{
    
    func oauth2LoginSuccess(serviceName: ServiceName){
        
        MSOAuth2.instance.serviceName = serviceName
        
        if(self.available()){
            loginWithFacebook()
        }
    }
    
    func oauth2LoginFail(error: NSError?, service: ServiceName) {
        self.showAlert(Messages.bDismiss, message: Messages.mLoginFail)
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


