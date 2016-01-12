//
//  StudentLocationObject.swift
//  OnTheMap-Udacity
//
//  Created by Daniela Velasquez on 1/11/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit

class StudentLocationObject: Deserializable {

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
    
    
    required init(data: [String: AnyObject]) {
        
        objectId <-- data["objectId"]
        uniqueKey <-- data["uniqueKey"]
        firstName <-- data["firstName"]
        lastName <-- data["lastName"]
        
        mapString <-- data["mapString"]
        mediaURL <-- data["mediaURL"]
        
        latitude <-- data["latitude"]
        longitude <-- data["longitude"]
        createdAt <-- data["createdAt"]
        updatedAt <-- data["updatedAt"]
    }


    func fullname()-> String{
        
        var fullname:String = self.firstName != nil ? self.firstName! + " " : ""
        fullname = self.lastName != nil ? fullname + self.lastName! : ""
        
        return fullname
    }
    
}
