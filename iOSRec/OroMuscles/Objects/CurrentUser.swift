//
//  CurrentUser.swift
//  OroMuscles
//
//  Created by Elizabeth Evans on 7/20/23.
//

import Foundation

class CurrentUser : NSObject {
    ///This is basic Info for the user
    var UserID : String = ""
    var UserEmail : String = ""
    var UserName : String = ""
    var UserRole : String = ""
    var UserOrganization : String = ""
    var UserToken : String = ""
    var UserAuthorization : String = ""
    
    
    
    
    
    /////////////////////////////////////////////////////////////////
    //////////////Initilzation Information for this Object
    /////////////////////////////////////////////////////////////////
    override init() {
        
    }
    
    
    
    /////////////////////////////////////////////////////////////////
    ////////////Resets the needed info for a new Login
    ///This isn't actually needed as a new session
    ///is created entirely on the login screen.
    /////////////////////////////////////////////////////////////////
    func LogoutUser() {
        UserID = ""
        UserEmail = ""
        UserName = ""
        UserRole = ""
        UserAuthorization = ""
        UserToken = ""
        UserAuthorization = ""
    }
    
}
