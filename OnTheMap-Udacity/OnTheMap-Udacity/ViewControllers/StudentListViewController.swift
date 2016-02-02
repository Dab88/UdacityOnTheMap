//
//  StudentListViewController.swift
//  OnTheMap-Udacity
//
//  Created by Daniela Velasquez on 1/12/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit

class StudentListViewController: UITableViewController {
    
    
    //Loading UI
    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var connectionAPI:APIConnection = APIConnection()
    var updating:Bool?
    
    //MARK: Life Cycle Methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        connectionAPI = APIConnection(delegate: self)
        
        //Set statusBar style
        self.preferredStatusBarStyle()
    }
    
    
    //MARK: IBAction Methods
    @IBAction func verifyLocation(sender: AnyObject) {
        
        if(UserSession.instance.userWithLocation() == true){
            showAlert(message: Messages.mUserWithLocation, successBtnTitle: Messages.bOverwrite, handlerSuccess:{
                (action) in
                    self.updating = true
                    self.performSegueWithIdentifier("setLocation", sender: self)
                }, failBtnTitle: Messages.bCancel)
        }else{
            updating = false
            self.performSegueWithIdentifier("setLocation", sender: self)
        }
    }
    
    @IBAction func logoutRequestAction(sender: AnyObject) {
        connectionAPI.delete(APISettings.BASE_URL + APISettings.URI_LOGIN, serverTag: APISettings.tagLogout)
        
        MSOAuth2.instance.logout()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func refreshAction(sender: AnyObject) {
        
        if(self.available()){
            showRequestMode(show: true)
            connectionAPI.get(APISettings.PARSE_BASE_URL + APISettings.URI_STUDENTLOC, parametersArray: nil, serverTag: APISettings.tagGetLoc, parseRequest: true)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "setLocation"){
            (segue.destinationViewController as! FindLocationViewController).updating = self.updating
        }
    }
    
    //MARK: TableViewDataSource Methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (UserSession.instance.studentLocations?.count)!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(StudentCell.identifier, forIndexPath: indexPath) as! StudentCell
        
        let student = UserSession.instance.studentLocations![indexPath.row]
        
        cell.setup(student)
        
        return cell
    }
    
     //MARK: TableViewDelegate Methods
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let student = UserSession.instance.studentLocations![indexPath.row]
        
        guard UIApplication.sharedApplication().canOpenURL(NSURL(string: student.mediaURL!)!) else{
            showAlert(Messages.mInvalidLink)
            return
        }
        
        UIApplication.sharedApplication().openURL(NSURL(string: student.mediaURL!)!)
    }
    
    
    //MARK: Others methods
    /**
     * Show the message in like do AlertMessage
     */
    func showAlert(title:String = "", message:String = "", successBtnTitle: String = Messages.bOk, handlerSuccess: ((UIAlertAction) -> Void)? = nil, failBtnTitle: String = "", handlerFail: ((UIAlertAction) -> Void)? = nil) {
        
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
    
    
    /**
     * @author: Daniela Velasquez
     * Show/Hide request mode in viewController
     */
    func showRequestMode(show show: Bool){
        
        dispatch_async(dispatch_get_main_queue()) {
            if (self.activityIndicator != nil){
                if(show){
                    self.activityIndicator.startAnimating()
                }else{
                    self.activityIndicator.stopAnimating()
                }
            }
            
            if((self.overlay) != nil){
                self.overlay.hidden = !show
            }
        }
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


// MARK: - ConnectionAPIProtocol Methods
extension StudentListViewController : APIConnectionProtocol{
    
    func  didReceiveAPIResultsSuccess(results results: AnyObject, path: String, serverTag: String){
        
        showRequestMode(show: false)
        
        if(serverTag == APISettings.tagGetLoc){
           
            UserSession.instance.fullStudentLocations(results)
            
            //Refresh tableview
            tableView.reloadData()
        }
    }
    
    func didReceiveAPIResultsFailed(error error: NSError, errorObject: AnyObject, path: String, serverTag: String){
        
        showRequestMode(show: false)
        
         if(error.code == 401){
            showAlert(Messages.titleAlert, message: Messages.mUnauthorizedUser,handlerSuccess:{
                (action) in
                    self.logoutRequestAction(self)
                }
            )
            
         }else if let message =  errorObject as? String {
            showAlert(Messages.titleAlert, message: message)
         }
        
    }
}
