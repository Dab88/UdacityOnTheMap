//
//  UserBasicInfo.swift
//  OnTheMap-Udacity
//
//  Created by Daniela Velasquez on 1/12/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit

class UserBasicInfo: NSObject, Deserializable {
    
    var firstName: String?
    var lastName: String?
    
    
    required override init(){
        
    }
    
    required init(data: [String: AnyObject]) {
        firstName <-- data["last_name"]
        lastName <-- data["first_name"]
    }
    
}
