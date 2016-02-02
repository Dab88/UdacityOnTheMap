//
//  Messages.swift
//  OnTheMap-Udacity
//
//  Created by Daniela Velasquez on 1/27/16.
//  Copyright © 2016 Mahisoft. All rights reserved.
//

import UIKit

struct Messages {
    
    static let titleMyProfile =  ""
    static let titleAlert = "Sorry!"
    static let titleNetworkProblems = "Network Problems"
    
    
    
    static let mAccessTokenEmpty = "Access Token is empty"
    static let mFieldsEmpty =  "You need fill the password and email fields."
    static let mLoginFail =  "Login problems"
    static let mInvalidLink = "Invalid link"
    static let mUserWithLocation = "User \" \((UserSession.instance.user?.firstName)!) \((UserSession.instance.user?.lastName)!) \" has already posted a student location. Would you like to overwrite their location?"
    static let mGeocodeFail = "Could not geocode the string"
    static let mEnterLocation = "Enter Your Location here"
    static let mMustEnterLocation =  "Must Enter a Location"
    static let mEnterLink = "Enter a Link to Share Here"
    static let mMustEnterLink = "Must Enter a Link"
    static let mUpdateFail = "Update Fail"
    static let mNoInternetConnection =  "No internet access"
    static let mUnauthorizedUser =  "User unauthorized"
    
    static let bOk = "OK"
    static let bDismiss = "Dismiss"
    static let bCancel = "Cancel"
    static let bOverwrite = "Overwrite"
    
}
