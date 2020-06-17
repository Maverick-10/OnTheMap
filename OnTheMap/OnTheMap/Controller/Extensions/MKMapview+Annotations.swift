//
//  MKMapview+Annotations.swift
//  OnTheMap
//
//  Created by bhuvan on 12/04/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {
    
    func addAnnotation(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        annotation.subtitle = subtitle
        addAnnotation(annotation)
    }
    
    func setRegion(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, span: self.region.span)
        setRegion(region, animated: true)
    }
}
