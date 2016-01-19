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
    var locationManager:CLLocationManager!
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Init locationManager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        
        //Get public user data
        connectionAPI.get(APISettings.BASE_URL + APISettings.URI_USER + "\(UserSession.instance.info!.account!.key!)", parametersArray: nil, serverTag: "tagUserInfo")
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    func updateStudentLocation(){
        connectionAPI.put(APISettings.BASE_URL + APISettings.URI_STUDENTLOC + "objectID", parametersArray: setBodyParameters(), serverTag: "tagUpdateStudentLoc", parseRequest: true)
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
        
        MSOAuth2.instance.logout()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func refreshAction(sender: AnyObject) {
        showRequestMode(show: true)
        connectionAPI.get(APISettings.PARSE_BASE_URL + APISettings.URI_STUDENTLOC, parametersArray: nil, serverTag: "tagStudentsLoc", parseRequest: true)
    }
    

    
    override func  didReceiveAPIResultsSuccess(results results: AnyObject, path: String, serverTag: String){
        
        if(serverTag == "tagStudentsLoc"){
            
            dispatch_async(dispatch_get_main_queue()) {
                self.showRequestMode(show: false)
                //Parse response
                let response = StudentLocationResponse(data: results as! [String: AnyObject])
                //Refresh studentLocations
                UserSession.instance.studentLocations = response.results
                //Load students points
                self.loadLocations()
                //Refresh tableview
                self.mapView.reloadInputViews()
            }
          
        }else if(serverTag == "tagUserInfo"){
            let responseObject = UserResponse(data: results as! [String: AnyObject])
            
            UserSession.instance.user = responseObject.user
            
            refreshAction(self)
            
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

extension OnTheMapViewController: CLLocationManagerDelegate{

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] 
        centerMapOnLocation(userLocation)
    }

}
