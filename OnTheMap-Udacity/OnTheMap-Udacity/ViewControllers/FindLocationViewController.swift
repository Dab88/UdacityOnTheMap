//
//  FindLocationViewController.swift
//  OnTheMap-Udacity
//
//  Created by Daniela Velasquez on 1/12/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit
import MapKit

class FindLocationViewController: ConnectionViewController {
    
    
    @IBOutlet weak var userAddress: UITextView!
    var userLocation:CLLocationCoordinate2D?
    
    //MARK: Life Cycle Methods
    
    override func viewWillAppear(animated: Bool) {
        userAddress.text = "Enter Your Location here"
    }
    
    
    //MARK: IBAction Methods
    @IBAction func adduserLocationsAction(sender: AnyObject) {
        
        guard !userAddress.text.isEmpty else{
            showAlert("", message: "Must Enter a Location")
            return
        }
        
        findLocation()
    }
    
    
    //MARK: Other Methods
    func findLocation(){
        let geocoder:CLGeocoder = CLGeocoder()
        geocoder.geocodeAddressString(userAddress.text, completionHandler:  { (placemarks, error) -> Void in
            if let firstPlacemark = placemarks?[0] {
                self.userLocation = (firstPlacemark as CLPlacemark).location?.coordinate
                self.performSegueWithIdentifier("goToSendLocation", sender: self)
            }
        })
    }
    
    //MARK: - NavigationBar Methods
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "goToSendLocation"){
             (segue.destinationViewController as! SendUserLocationViewController).userLocation = UserLocation(uniqueKey: UserSession.instance.info!.account!.key!,
                firstName: UserSession.instance.user!.firstName!,
                lastName: UserSession.instance.user!.lastName!,
                mapString: userAddress!.text,
                mediaURL: "",
                latitude: userLocation!.latitude,
                longitude: userLocation!.longitude)
        }
    }
}


extension FindLocationViewController: UITextViewDelegate{
    
    
    func textViewDidEndEditing(textView: UITextView) {
        userAddress.resignFirstResponder()
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        
        if(userAddress.text == ""){
            textView.text = "Enter Your Location here"
        }
        userAddress.resignFirstResponder()
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        if(userAddress.text == "Enter Your Location here"){
            textView.text = ""
        }
        
        textView.becomeFirstResponder()
    }

}