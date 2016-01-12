//
//  SendUserLocationViewController.swift
//  OnTheMap-Udacity
//
//  Created by Daniela Velasquez on 1/12/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit
import MapKit

class SendUserLocationViewController: ConnectionViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mediaUrl: UITextView!
    
    var userLocation:UserLocation?
    let regionRadius: CLLocationDistance = 300
    
    
    //MARK: Life Cycle Methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //Set initial location
        let initialLocation = CLLocation(latitude: (userLocation?.latitude)!, longitude: (userLocation?.longitude)!)
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func submitUserLocation(sender: AnyObject) {
        guard !mediaUrl.text.isEmpty else{
            showAlert("", message: "Must Enter a Link")
            return
        }
        
        connectionAPI.post(APISettings.BASE_URL + APISettings.URI_STUDENTLOC, parametersArray: self.userLocation!.toJSON(), serverTag: "tagAddStudentLoc", parseRequest: true)
        
    }
    //MARK: Other Methods
    /**
     * @author: Daniela Velasquez
     * Make body request from request.
     * @return:
     {
     "uniqueKey": "1234",
     "firstName": "John",
     "lastName": "Doe",
     "mapString": "Mountain View, CA",
     "mediaURL": "https://udacity.com",
     "latitude": 37.386052,
     "longitude": -122.083851
     }
     */
    func setBodyParameters()-> [String : AnyObject]{
        
        let params:NSMutableDictionary = NSMutableDictionary()
        
        params["uniqueKey"] = userLocation!.uniqueKey
        params["firstName"] = userLocation!.firstName
        params["lastName"]  = userLocation!.lastName
        params["mapString"] = userLocation!.mapString
        params["mediaURL"]  = userLocation!.mediaURL
        params["latitude"]  = userLocation!.latitude
        params["longitude"] = userLocation!.longitude
        
        let parameters:NSDictionary = params
        
        return parameters as! [String : AnyObject]
    }
    
    
    
    override func didReceiveAPIResultsSuccess(results results: AnyObject, path: String, serverTag: String){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveAPIResultsFailed(error error: NSError, errorObject: AnyObject, path: String, serverTag: String){
        showAlert("", message: "Update Fail")
    }
    
}