//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by bhuvan on 12/04/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import CoreLocation

class InformationPostingViewController: UIViewController {
    
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add cancel button
        let cancelButton = UIBarButtonItem(title: "CANCEL", style: .done, target: self, action: #selector(cancelButtonPressed))
        navigationItem.leftBarButtonItem = cancelButton
        
    }
    
    // MARK: -  Button Actions
    @IBAction func findLocationButtonPressed(_ sender: Any) {
        
        // Check if both the texfields have strings
        guard isValidFormData() else { return }
        
        // Search the location
        activityIndicatorView.startAnimating()
        CLGeocoder().geocodeAddressString(locationTextField.text!) { (placemarks, error) in
            
            performUIUpdate {
                
                self.activityIndicatorView.stopAnimating()
                
                guard
                    let placemark = placemarks?.first,
                    let location = placemark.location else { return }
                
                let addLocationVC = self.storyboard?.instantiateViewController(identifier: "AddLocationViewController") as! AddLocationViewController
                addLocationVC.coordinate = location.coordinate
                addLocationVC.link = self.linkTextField.text!
                addLocationVC.mapString = placemark.name ?? ""
                self.navigationController?.pushViewController(addLocationVC, animated: true)
            }
        }
    }
    
    // MARK: - Validation
    func isValidFormData() -> Bool {
        var isValid = false
        
        if let isMissingLocation = locationTextField.text?.isEmpty, isMissingLocation {
            UIAlertController.showAlert(from: self,
                                        title: AlertTitle.missingField,
                                        message: AlertMessage.locationMissing)
        } else if let isMissingLink = linkTextField.text?.isEmpty, isMissingLink {
            UIAlertController.showAlert(from: self,
                                        title: AlertTitle.missingField,
                                        message: AlertMessage.linkMissing)
        } else {
            isValid = true
        }
        
        return isValid
    }
    
    @objc func cancelButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Textfield delegate
extension InformationPostingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}


