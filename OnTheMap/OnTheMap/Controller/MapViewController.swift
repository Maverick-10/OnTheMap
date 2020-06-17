//
//  MapViewController.swift
//  OnTheMap
//
//  Created by bhuvan on 10/04/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getStudentInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateAnnotations(response: UserManager.shared.locations)
    }
    
    // MARK: - Helpers
    func getStudentInfo() {
        UdacityClient.getStudentInformation(completion: handleStudentInformationResponse(response:error:))
    }
    
    func handleStudentInformationResponse(response: StudentListResponse?, error: Error?) {
        if let response = response {
            UserManager.shared.locations = response.results
            updateAnnotations(response: UserManager.shared.locations)
        } else {
            UIAlertController.showAlert(from: self,
                                        title: AlertTitle.error,
                                        message: error?.localizedDescription ?? "")
        }
    }
    
    // MARK: - Add Annotations
    func updateAnnotations(response: [StudentInformation]) {
        
        let currentAnnotations = mapView.annotations
        mapView.removeAnnotations(currentAnnotations)
        
        for studentInfo in response {
            mapView.addAnnotation(coordinate: studentInfo.getCoordinate(), title: studentInfo.mapString, subtitle: studentInfo.mediaURL)
        }
        
        // Set region to recent updated location
        if let studentInfo = response.first {
            mapView.setRegion(coordinate: studentInfo.getCoordinate())
        }
    }
}

// MARK: - Map View Delegate
extension MapViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "reuseId"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.pinTintColor = .red
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard
            let urlString = view.annotation?.subtitle!,
            let url = URL(string: urlString),
            control == view.rightCalloutAccessoryView else {
                return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
