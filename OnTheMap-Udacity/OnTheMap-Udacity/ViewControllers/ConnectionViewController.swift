//
//  ConnectionViewController.swift
//  OnTheMap-Udacity
//
//  Created by Daniela Velasquez on 1/8/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit


class ConnectionViewController: BaseViewController {

    var connectionAPI:APIConnection = APIConnection()
    
    //MARK: Life Cycle Methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        connectionAPI = APIConnection(delegate: self)
        
        //Set statusBar style
        self.preferredStatusBarStyle()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


// MARK: - ConnectionAPIProtocol Methods
extension ConnectionViewController : APIConnectionProtocol{
    
    func  didReceiveAPIResultsSuccess(results results: AnyObject, path: String, serverTag: String){
        print(results)
    }
    
    func didReceiveAPIResultsFailed(error error: NSError, errorObject: AnyObject, path: String, serverTag: String){
        print(errorObject)
    }
}