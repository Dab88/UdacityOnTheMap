//
//  MSSession.swift
//  OnTheMap-Udacity
//
//  Created by Daniela Velasquez on 1/8/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//


import UIKit

class MSSession: Deserializable {
    
    var id: String?
    var expiration: NSDate?

    required init(data: [String: AnyObject]) {
        id <-- data["id"]
        expiration <-- data["expiration"]
    }
}

