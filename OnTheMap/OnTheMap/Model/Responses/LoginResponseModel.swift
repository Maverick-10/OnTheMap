//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by bhuvan on 10/04/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct LoginResponseModel: Codable {
    let account: AccountModel
    let session: SessionModel
    
    enum CodingKeys: String, CodingKey {
        case account
        case session
    }
}

struct AccountModel: Codable {
    let registered: Bool
    let key: String
    
    enum CodingKeys: String, CodingKey {
        case registered
        case key
    }
}

struct SessionModel: Codable {
    let sessionId: String
    let expiryDate: String
    
    enum CodingKeys: String, CodingKey {
        case sessionId = "id"
        case expiryDate = "expiration"
    }
}
