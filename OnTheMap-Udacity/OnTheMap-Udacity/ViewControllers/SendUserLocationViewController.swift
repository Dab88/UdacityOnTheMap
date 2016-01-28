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
    var updating:Bool?
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
        mediaUrl.text = Messages.mEnterLink
    }
    
    
    //MARK: IBAction Methods
    @IBAction func submitUserLocation(sender: AnyObject) {
       
        guard !mediaUrl.text.isEmpty && (mediaUrl.text != Messages.mEnterLink) else{
            showAlert(message: Messages.mMustEnterLink)
            return
        }
        
        userLocation?.mediaURL = mediaUrl.text
        
        if(self.available()){
            showRequestMode(show: true)
            
            if(updating == true){
                 connectionAPI.put(APISettings.PARSE_BASE_URL + APISettings.URI_UPDATELOC + "/" + UserSession.instance.currentObjectKey!, parametersArray: self.userLocation!.toJSON(), serverTag: APISettings.tagAddLoc, parseRequest: true)
            }
            else{
                connectionAPI.post(APISettings.PARSE_BASE_URL + APISettings.URI_UPDATELOC, parametersArray: self.userLocation!.toJSON(), serverTag: APISettings.tagAddLoc, parseRequest: true)
            }
        }
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        showRequestMode(show: false)
        self.presentingViewController!.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Other Methods
    
    func loadUserLocation(){
        
        //Show students in the map
        let annotation = StudentAnnotation(title: (userLocation?.firstName)!, url: "", coordinate:  CLLocationCoordinate2D(latitude:  userLocation!.latitude, longitude:  userLocation!.longitude))
        
        mapView.addAnnotation(annotation)
    }
    
    //MARK: APIConnectionProtocol Methods
    override func didReceiveAPIResultsSuccess(results results: AnyObject, path: String, serverTag: String){
        
        super.didReceiveAPIResultsSuccess(results: results, path: path, serverTag: serverTag)
        
        dispatch_async(dispatch_get_main_queue()) {
           self.cancelAction(self)
        }
    }
    
    override func didReceiveAPIResultsFailed(error error: NSError, errorObject: AnyObject, path: String, serverTag: String){
        dispatch_async(dispatch_get_main_queue()) {
            self.showAlert(message: Messages.mUpdateFail)
            self.showRequestMode(show: false)
        }
    }
    
}

extension SendUserLocationViewController: UITextViewDelegate{
    
    
    func textViewDidEndEditing(textView: UITextView) {
        mediaUrl.resignFirstResponder()
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        
        if(mediaUrl.text == ""){
            textView.text = Messages.mEnterLink
        }
        mediaUrl.resignFirstResponder()
        
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        if(mediaUrl.text == Messages.mEnterLink){
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