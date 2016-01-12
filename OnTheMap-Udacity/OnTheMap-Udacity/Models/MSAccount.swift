//
//  MSAccount.swift
//  OnTheMap-Udacity
//
//  Created by Daniela Velasquez on 1/8/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit

class MSAccount: Deserializable {
    
    var registered: Bool?
    var key: String?
    
    
    required init(data: [String: AnyObject]) {
        registered <-- data["registered"]
        key <-- data["key"]
    }
    
}
