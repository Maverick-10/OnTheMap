//
//  StudentsModel.swift
//  OnTheMap
//
//  Created by bhuvan on 12/04/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

class UserManager {
    
    /// Sigleton instance
    static let shared = UserManager()
    
    /// All the locations of the students
    var locations = [StudentInformation]()
    
    /// Random user information
    var userModel: UserModel?
    
    /// User session details
    var accountModel: AccountModel?
    
    /// User session details
    var sessionModel: SessionModel?
        
    /// The object id fetched when a location is added by the user.
    var objectId: String = ""
    
}
