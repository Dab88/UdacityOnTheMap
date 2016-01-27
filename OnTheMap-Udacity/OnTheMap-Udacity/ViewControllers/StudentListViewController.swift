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
                    self.performSegueWithIdentifier("setLocation", sender: self)
                }, failBtnTitle: Messages.bCancel)
        }else{
            self.performSegueWithIdentifier("setLocation", sender: self)
        }
        
    }
    
    @IBAction func logoutRequestAction(sender: AnyObject) {
        connectionAPI.delete(APISettings.BASE_URL + APISettings.URI_LOGIN, serverTag: APISettings.tagLogout)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func refreshAction(sender: AnyObject) {
        showRequestMode(show: true)
        connectionAPI.get(APISettings.PARSE_BASE_URL + APISettings.URI_STUDENTLOC, parametersArray: nil, serverTag: APISettings.tagGetLoc, parseRequest: true)
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
}


// MARK: - ConnectionAPIProtocol Methods
extension StudentListViewController : APIConnectionProtocol{
    
    func  didReceiveAPIResultsSuccess(results results: AnyObject, path: String, serverTag: String){
        
        showRequestMode(show: false)
        
        if(serverTag == APISettings.tagGetLoc){
            //Parse response
            let response = StudentLocationResponse(data: results as! [String: AnyObject])
            //Refresh studentLocations
            UserSession.instance.studentLocations = response.results
            //Refresh tableview
            tableView.reloadData()
        }
    }
    
    func didReceiveAPIResultsFailed(error error: NSError, errorObject: AnyObject, path: String, serverTag: String){
        
        showRequestMode(show: false)
        
        if let message =  errorObject as? String {
            showAlert(Messages.titleAlert, message: message)
        }
        
    }
}
