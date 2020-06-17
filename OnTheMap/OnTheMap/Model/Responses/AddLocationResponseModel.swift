//
//  AddStudentInfoResponse.swift
//  OnTheMap
//
//  Created by bhuvan on 12/04/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct AddLocationResponseModel: Codable {
    
    let createdAt: String
    let objectId: String
}

struct UpdateLocationResponseModel: Codable {
    let updatedAt: String
}
