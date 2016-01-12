//
//  StudentListViewController.swift
//  OnTheMap-Udacity
//
//  Created by Daniela Velasquez on 1/12/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit

class StudentListViewController: UITableViewController {
    
    var connectionAPI:APIConnection = APIConnection()
    
    //MARK: Life Cycle Methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        connectionAPI = APIConnection(delegate: self)
        
        //Set statusBar style
        self.preferredStatusBarStyle()
    }
    
    
    //MARK: IBAction Methods
    @IBAction func logoutRequestAction(sender: AnyObject) {
        connectionAPI.delete(APISettings.BASE_URL + APISettings.URI_LOGIN, serverTag: "tagLogout")
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func refreshAction(sender: AnyObject) {
        connectionAPI.get(APISettings.PARSE_BASE_URL + APISettings.URI_STUDENTLOC, parametersArray: nil, serverTag: "tagStudentsLoc", parseRequest: true)
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
            showAlert("Invalid link", message: "", successBtnTitle: "Dismiss")
            return
        }
        
        UIApplication.sharedApplication().openURL(NSURL(string: student.mediaURL!)!)
    }
    
    
    //MARK: Others methods
    
    /**
     * Show the message in like do AlertMessage
     */
    func showAlert(title:String, message:String, successBtnTitle: String = "OK", handlerSuccess: ((UIAlertAction) -> Void)? = nil, failBtnTitle: String = "", handlerFail: ((UIAlertAction) -> Void)? = nil) {
        
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
}


// MARK: - ConnectionAPIProtocol Methods
extension StudentListViewController : APIConnectionProtocol{
    
    func  didReceiveAPIResultsSuccess(results results: AnyObject, path: String, serverTag: String){
        
        if(serverTag == "tagStudentsLoc"){
            //Parse response
            let response = StudentLocationResponse(data: results as! [String: AnyObject])
            //Refresh studentLocations
            UserSession.instance.studentLocations = response.results
            //Refresh tableview
            tableView.reloadData()
        }
    }
    
    func didReceiveAPIResultsFailed(error error: NSError, errorObject: AnyObject, path: String, serverTag: String){
        print(errorObject)
    }
}
