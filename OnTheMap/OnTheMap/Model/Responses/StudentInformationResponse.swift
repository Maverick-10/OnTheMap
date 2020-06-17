//
//  StudentInformationResponse.swift
//  OnTheMap
//
//  Created by bhuvan on 12/04/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import CoreLocation

struct StudentListResponse: Codable {
    let results: [StudentInformation]
}


struct StudentInformation: Codable {
    let firstName: String
    let lastName: String
    let longitude: Double
    let latitude: Double
    let mapString: String
    let mediaURL: String
    let uniqueKey: String
    let objectId: String
    let createdAt: String
    let updatedAt: String
    
    func getCoordinate() -> CLLocationCoordinate2D {
        let lat = CLLocationDegrees(latitude)
        let lang = CLLocationDegrees(longitude)
        return CLLocationCoordinate2D(latitude: lat, longitude: lang)
    }
    
}
