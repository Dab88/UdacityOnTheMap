//
//  UserSession.swift
//  OnTheMap-Udacity
//
//  Created by Daniela Velasquez on 1/11/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit


class UserSession: NSObject {
    
    var info:LoginResponse?
    var user:UserBasicInfo?
    
    var studentLocations:[StudentInformation]?

    
    class var instance: UserSession {
        
        struct Static {
            static var instance: UserSession?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = UserSession()
        }
        
        return Static.instance!
    }
    
    required override init(){
        
    }
    
    
    func cleanUser(){
        info = LoginResponse()
        user = UserBasicInfo()
    }
    
    func userWithLocation() -> Bool{
        
        let user = self.studentLocations?.filter{ $0.uniqueKey == self.info!.account!.key!}
        
        guard user?.count != 0 else{
            return false
        }
        
        return (user![0].latitude != nil)
    }
    
}
