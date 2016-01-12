//
//  StudentLocationResponse.swift
//  OnTheMap-Udacity
//
//  Created by Daniela Velasquez on 1/11/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit

class StudentLocationResponse: Deserializable {

     var results:[StudentLocationObject]?
    
    required init(data: [String: AnyObject]) {
        results <-- data["results"]
    }
}
