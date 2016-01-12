//
//  LoginResponse.swift
//  OnTheMap-Udacity
//
//  Created by Daniela Velasquez on 1/8/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit

/*{
"account": {
"registered": true,
"key": "5209239887"
},
"session": {
"id": "1483819705S8d64370c600a42bfc60fc8e905cbb5ad",
"expiration": "2016-03-08T20:08:25.932640Z"
}
}*/
class LoginResponse: NSObject, Deserializable {

    var account: MSAccount?
    var session: MSSession?
  
    
    required override init(){
    
    }
    
    required init(data: [String: AnyObject]) {
        account <-- data["account"]
        session <-- data["session"]
    }
    
}
