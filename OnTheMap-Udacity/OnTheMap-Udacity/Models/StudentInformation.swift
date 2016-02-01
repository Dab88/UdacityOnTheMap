//
//  StudentInformation.swift
//  OnTheMap-Udacity
//
//  Created by Daniela Velasquez on 1/28/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit

struct StudentInformation{
    
    var objectId: String?
    var uniqueKey: String?
    
    var firstName: String?
    var lastName: String?
    
    var mapString: String? // the location string used for geocoding the student location
    var mediaURL: String?  // the URL provided by the student
    
    var latitude: Double?  // the latitude of the student location (ranges from -90 to 90)
    var longitude: Double? // the longitude of the student location (ranges from -180 to 180)
    
    var createdAt: NSDate? // the date when the student location was created
    var updatedAt: NSDate? // the date when the student location was last updated
    
    
    init(data: NSDictionary){
    
        if let oId = data["objectId"] as? String{
            self.objectId = oId
        }
       
        if let uniqueKey = data["uniqueKey"] as? String{
            self.uniqueKey = uniqueKey
        }
      
        
        if let firstName = data["firstName"] as? String{
            self.firstName = firstName
        }
        
        if let lastName = data["lastName"] as? String{
            self.lastName = lastName
        }
        
        
        if let mapString = data["mapString"] as? String{
            self.mapString = mapString
        }
        
        if let mediaURL = data["mediaURL"] as? String{
            self.mediaURL = mediaURL
        }
       
        if let latitude = data["latitude"] as? Double{
            self.latitude = latitude
        }
        
        if let longitude = data["longitude"] as? Double{
            self.longitude = longitude
        }
        
        if let createdAt = data["createdAt"] as? NSDate{
            self.createdAt = createdAt
        }
        
        if let updatedAt = data["updatedAt"] as? NSDate{
            self.updatedAt = updatedAt
        }
        
     
    }
    
    
}
    