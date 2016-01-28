//
//  Settings.swift
//  OnTheMap-Udacity
//
//  Created by Daniela Velasquez on 12/15/15.
//  Copyright © 2015 Mahisoft. All rights reserved.
//

import UIKit

struct APISettings{

    static let BASE_URL:String = "https://www.udacity.com/api"
    static let PARSE_BASE_URL:String = "https://api.parse.com/1/classes"
    static let API_KEY = "ENTER_YOUR_API_KEY_HERE"
    static let PARSE_ID  = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    static let REST_API_KEY  = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"

    static let URI_LOGIN = "/session"
    static let URI_USER = "/users/"
    static let URI_UPDATELOC = "/StudentLocation"
    static let URI_STUDENTLOC = URI_UPDATELOC + "?order=-updatedAt"
    
 
    
    static let SIGN_UP_URL = "https://www.google.com/url?q=https://www.udacity.com/account/auth%23!/signin&sa=D&usg=AFQjCNHOjlXo3QS15TqT0Bp_TKoR9Dvypw"
    
    static let tagFB = "tagLoginFb"
    static let tagAuth = "tagLogin"
    static let tagGetUser = "tagUserInfo"
    static let tagGetLoc = "tagStudentsLoc"
    static let tagLogout = "tagLogout"
    static let tagAddLoc = "tagAddStudentLoc"
}

struct Interface {
     static let fontFamily = "Roboto"
}
public struct ScreenSize{
    static let width         = UIScreen.mainScreen().bounds.size.width
    static let height        = UIScreen.mainScreen().bounds.size.height
    static let max_length    = max(ScreenSize.width, ScreenSize.height)
    static let min_length    = min(ScreenSize.width, ScreenSize.height)
}

