//
//  StudentAnnotation.swift
//  OnTheMap-Udacity
//
//  Created by Daniela Velasquez on 1/11/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import MapKit

class StudentAnnotation:  NSObject, MKAnnotation {
   
    let title: String?
    let url: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, url: String, coordinate: CLLocationCoordinate2D) {
        
        self.title = title
        self.url = url
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String?{
        return url
    }
    

}