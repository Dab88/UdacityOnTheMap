//
//  OnTheMapViewController.swift
//  OnTheMap-Udacity
//
//  Created by Daniela Velasquez on 1/11/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit
import MapKit


class OnTheMapViewController: ConnectionViewController {

    
    @IBOutlet weak var mapView: MKMapView!
    
    var studentLocations:[StudentLocationObject]?
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // set initial location - TODO
        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)

        centerMapOnLocation(initialLocation)
        
        loadLocations()
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    
    
    
    func updateStudentLocation(){
        connectionAPI.put(APISettings.BASE_URL + APISettings.URI_STUDENTLOC + "objectID", parametersArray: setBodyParameters(), serverTag: "tagUpdateStudentLoc", parseRequest: true)
    }
    
    func addStudentLocation(){
        connectionAPI.post(APISettings.BASE_URL + APISettings.URI_STUDENTLOC, parametersArray: setBodyParameters(), serverTag: "tagAddStudentLoc", parseRequest: true)
    }
    
    
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
        
        params["uniqueKey"]  = ""
        params["firstName"] = ""
        params["lastName"]  = ""
        params["mapString"] = ""
        params["mediaURL"]  = ""
        params["latitude"] = ""
        params["longitude"] = ""
        
        let parameters:NSDictionary = params
        
        return parameters as! [String : AnyObject]
        
    }
   
    
    func loadLocations(){
    
    
        for sLocation in UserSession.instance.studentLocations!{
        
            //show students on map
            
            let annotation = StudentAnnotation(title: sLocation.fullname(), url: sLocation.mediaURL!, coordinate:  CLLocationCoordinate2D(latitude: sLocation.latitude!, longitude: sLocation.longitude!))
            
            mapView.addAnnotation(annotation)
        }
        
    }
    
    
    //MARK: IBAction Methods
    @IBAction func logoutRequestAction(sender: AnyObject) {
        connectionAPI.delete(APISettings.BASE_URL + APISettings.URI_LOGIN, serverTag: "tagLogout")
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func refreshAction(sender: AnyObject) {
        connectionAPI.get(APISettings.PARSE_BASE_URL + APISettings.URI_STUDENTLOC, parametersArray: nil, serverTag: "tagStudentsLoc", parseRequest: true)
    }
    
    @IBAction func adduserLocationsAction(sender: AnyObject) {
       addStudentLocation()
    }
    
    
    override func  didReceiveAPIResultsSuccess(results results: AnyObject, path: String, serverTag: String){
        
        if(serverTag == "tagStudentsLoc"){
            //Parse response
            let response = StudentLocationResponse(data: results as! [String: AnyObject])
            //Refresh studentLocations
            UserSession.instance.studentLocations = response.results
            //Refresh tableview
            mapView.reloadInputViews()
        }
    }
    
    override func didReceiveAPIResultsFailed(error error: NSError, errorObject: AnyObject, path: String, serverTag: String){
        print(errorObject)
    }
}



extension OnTheMapViewController: MKMapViewDelegate {
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? StudentAnnotation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView {
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl){
    
    
        let student = view.annotation as! StudentAnnotation
        
        guard UIApplication.sharedApplication().canOpenURL(NSURL(string: student.url!)!) else{
            showAlert("Invalid link", message: "", successBtnTitle: "Dismiss")
            return
        }
        
        
        UIApplication.sharedApplication().openURL(NSURL(string: student.url!)!)
        
        
    }
}


