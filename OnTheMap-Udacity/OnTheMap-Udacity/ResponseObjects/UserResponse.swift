//
//  UserResponse.swift
//  OnTheMap-Udacity
//
//  Created by Daniela Velasquez on 1/12/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//


import UIKit

class UserResponse: NSObject, Deserializable {
    
    var user: UserBasicInfo?
    
    required override init(){
        
    }
    
    required init(data: [String: AnyObject]) {
        user <-- data["user"]
    }
    
}


