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
        
        loadUserLocation()
        
        showRequestMode(show: false)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        mediaUrl.text = "Enter a Link to Share Here"
    }
    
    
    func loadUserLocation(){
        
        //show students on map
        
        let annotation = StudentAnnotation(title: (userLocation?.firstName)!, url: "", coordinate:  CLLocationCoordinate2D(latitude:  userLocation!.latitude, longitude:  userLocation!.longitude))
        
        mapView.addAnnotation(annotation)
        
    }
    
    @IBAction func submitUserLocation(sender: AnyObject) {
        guard !mediaUrl.text.isEmpty else{
            showAlert("", message: "Must Enter a Link")
            return
        }
        
        
        userLocation?.mediaURL = mediaUrl.text
        
        showRequestMode(show: true)
        connectionAPI.post(APISettings.PARSE_BASE_URL + APISettings.URI_STUDENTLOC, parametersArray: self.userLocation!.toJSON(), serverTag: "tagAddStudentLoc", parseRequest: true)
        
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        showRequestMode(show: false)
        self.presentingViewController!.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Other Methods
    
    override func didReceiveAPIResultsSuccess(results results: AnyObject, path: String, serverTag: String){
        super.didReceiveAPIResultsSuccess(results: results, path: path, serverTag: serverTag)
        dispatch_async(dispatch_get_main_queue()) {
           self.cancelAction(self)
        }
    }
    
    override func didReceiveAPIResultsFailed(error error: NSError, errorObject: AnyObject, path: String, serverTag: String){
        showAlert("", message: "Update Fail")
        showRequestMode(show: false)
    }
    
}

extension SendUserLocationViewController: UITextViewDelegate{
    
    
    func textViewDidEndEditing(textView: UITextView) {
        mediaUrl.resignFirstResponder()
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        
        if(mediaUrl.text == ""){
            textView.text = "Enter a Link to Share Here"
        }
        mediaUrl.resignFirstResponder()
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        if(mediaUrl.text == "Enter a Link to Share Here"){
            textView.text = ""
        }
        
        textView.becomeFirstResponder()
    }
    
}

extension SendUserLocationViewController: MKMapViewDelegate {
    
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
                view.canShowCallout = false
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = nil
            }
            return view
        }
        return nil
    }
}