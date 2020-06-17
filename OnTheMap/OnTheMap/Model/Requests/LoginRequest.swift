//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by bhuvan on 10/04/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct UdacityLoginRequest: Codable {
    let udacity: LoginRequest
    
    enum CodingKeys: String, CodingKey {
        case udacity
    }
}

struct LoginRequest: Codable {
    let email: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case email = "username"
        case password
    }
}
