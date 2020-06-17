//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by bhuvan on 10/04/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Properties
    internal var coordinate: CLLocationCoordinate2D!
    internal var mapString: String!
    internal var link: String!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)        
        mapView.addAnnotation(coordinate: coordinate, title: mapString, subtitle: link)
        mapView.setRegion(coordinate: coordinate)
    }
    
    func setupUI() {
        indicatorView.setCorner(radius: 4.0)
    }
    
    func activitIndicator(enabled: Bool) {
        indicatorView.isHidden = !enabled
        mapView.isUserInteractionEnabled = !enabled
        finishButton.isEnabled = !enabled
        if enabled {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }
    }
    
    // MARK: - Actions
    @IBAction func finishButtonPressed(_ sender: Any) {
        // Show indicator
        activitIndicator(enabled: true)
        
        if let usermodel = UserManager.shared.userModel {
            handleUserInfoResponse(response: usermodel, error: nil)
        } else {
            UdacityClient.getUserInfo(completion: handleUserInfoResponse(response:error:))
        }
        
        
    }
    
    func handleUserInfoResponse(response: UserModel?, error: Error?) {
        if let response = response {
            UserManager.shared.userModel = response
            let studentInfo = AddStudentInformationRequest(firstName: response.firstName,
                                                           lastName: response.lastName,
                                                           longitude: coordinate.longitude,
                                                           latitude: coordinate.latitude,
                                                           mapString: mapString,
                                                           mediaURL: link,
                                                           uniqueKey: UserManager.shared.accountModel?.key ?? "")
            
            // If object id already present then update the location for existing user
            if UserManager.shared.objectId.isEmpty {
                UdacityClient.add(studentInfo: studentInfo, completion: handleAddStudentInfoResponse(response:error:))
            } else {
                UdacityClient.update(studentInfo: studentInfo, completion: handleUpdateStudentInfoResponse(success:error:))
            }
            
        } else {
            // Hide indicator
            activitIndicator(enabled: false)
            UIAlertController.showAlert(from: self,
                                        title: AlertTitle.missingField,
                                        message: error?.localizedDescription ?? "")
        }
    }
    
    func handleAddStudentInfoResponse(response: AddLocationResponseModel?, error: Error?) {
        // Hide indicator
        activitIndicator(enabled: false)
        
        if let response = response {
            UserManager.shared.objectId = response.objectId
            self.dismiss(animated: true, completion: nil)
        } else {
            UIAlertController.showAlert(from: self,
                                        title: AlertTitle.missingField,
                                        message: error?.localizedDescription ?? "")
        }
    }
    
    func handleUpdateStudentInfoResponse(success: Bool, error: Error?) {
        // Hide indicator
        activitIndicator(enabled: false)
        
        if success {
            self.dismiss(animated: true, completion: nil)
        } else {
            UIAlertController.showAlert(from: self,
                                        title: AlertTitle.missingField,
                                        message: error?.localizedDescription ?? "")
        }
    }
}


extension AddLocationViewController : MKMapViewDelegate {
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
}
