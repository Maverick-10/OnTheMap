//
//  UdacityResponse.swift
//  OnTheMap
//
//  Created by bhuvan on 12/04/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct UdacityResponse: Codable {
    
    let status: Int
    let errorMessage: String
    
    enum CodingKeys: String, CodingKey {
        case status
        case errorMessage = "error"
    }
}

extension UdacityResponse: LocalizedError {
    var errorDescription: String? {
        return errorMessage
    }
}
