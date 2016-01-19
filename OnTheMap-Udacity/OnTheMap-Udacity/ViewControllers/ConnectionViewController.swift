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
    
    //Loading UI
    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: Life Cycle Methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        connectionAPI = APIConnection(delegate: self)
        
        //Set statusBar style
        self.preferredStatusBarStyle()
    }
    
    /**
     * @author: Daniela Velasquez
     * Show/Hide request mode in viewController
     */
    func showRequestMode(show show: Bool){
        
        
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


// MARK: - ConnectionAPIProtocol Methods
extension ConnectionViewController : APIConnectionProtocol{
    
    func  didReceiveAPIResultsSuccess(results results: AnyObject, path: String, serverTag: String){
        print(results)
    }
    
    func didReceiveAPIResultsFailed(error error: NSError, errorObject: AnyObject, path: String, serverTag: String){
        print(errorObject)
        showRequestMode(show: false)
    }
}