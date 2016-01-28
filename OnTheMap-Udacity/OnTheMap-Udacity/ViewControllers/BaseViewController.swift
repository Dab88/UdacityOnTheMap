//
//  BaseViewController.swift
//  OnTheMap-Udacity
//
//  Created by Daniela Velasquez on 1/11/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    
     //MARK: Life Cycle Methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Add gesture from hide keyboard when the user touch the screen
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hideKeyboard"))
        
    }
    
    // MARK: - Keyboard management Methods
    func hideKeyboard(){
        view.endEditing(true)
    }
    
    // MARK: Other Methods
    /**
     * Show the message in like do AlertMessage
     */
    
    func showAlert(title:String = "", message:String = "", successBtnTitle: String = Messages.bDismiss, handlerSuccess: ((UIAlertAction) -> Void)? = nil, failBtnTitle: String = "", handlerFail: ((UIAlertAction) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title,
            message: message, preferredStyle: .Alert)
        
        let dismissAction = UIAlertAction(title: successBtnTitle, style: .Default, handler: handlerSuccess)
        
        alert.addAction(dismissAction)
        
        if(failBtnTitle != ""){
            let failAction = UIAlertAction(title: failBtnTitle, style: .Destructive, handler: handlerFail)
            
            alert.addAction(failAction)
        }
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    /*
    * Return true if the device have internet access
    */
    func available() -> Bool{
        
        if(ConnectionsValidator.isConnectedToNetwork()){
            return true
        }else{
            showAlert(Messages.titleNetworkProblems, message: Messages.mNoInternetConnection)
        }
        
        return false
    }
}
