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
    var updating:Bool?
    
    //MARK: Life Cycle Methods
    
    override func viewWillAppear(animated: Bool) {
        userAddress.text = Messages.mEnterLocation
        showRequestMode(show: false)
    }
    
    
    //MARK: IBAction Methods
    @IBAction func adduserLocationsAction(sender: AnyObject) {
        
        guard ((!userAddress.text.isEmpty) && (userAddress.text != Messages.mEnterLocation)) else{
            showAlert(message: Messages.mMustEnterLocation)
            return
        }
        
        findLocation()
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //MARK: Other Methods
    func findLocation(){
        
        if(self.available()){
            showRequestMode(show: true)
           
            let geocoder:CLGeocoder = CLGeocoder()
            geocoder.geocodeAddressString(userAddress.text, completionHandler:  { (placemarks, error) -> Void in
                
                self.showRequestMode(show: false)
                
                guard error == nil else{
                    self.showAlert(Messages.titleAlert, message: Messages.mGeocodeFail)
                    return
                }
                
                if let firstPlacemark = placemarks?[0] {
                    self.userLocation = (firstPlacemark as CLPlacemark).location?.coordinate
                    self.performSegueWithIdentifier("goToSendLocation", sender: self)
                }
                
            })
        }
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
            
            
            (segue.destinationViewController as! SendUserLocationViewController).updating = updating
        }
    }
}


extension FindLocationViewController: UITextViewDelegate{
    
    
    func textViewDidEndEditing(textView: UITextView) {
        userAddress.resignFirstResponder()
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        
        if(userAddress.text == ""){
            textView.text = Messages.mEnterLocation
        }
        userAddress.resignFirstResponder()
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        
        if(userAddress.text == Messages.mEnterLocation){
            textView.text = ""
        }
        
        textView.becomeFirstResponder()
    }

}