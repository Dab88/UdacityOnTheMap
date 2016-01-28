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
}
    