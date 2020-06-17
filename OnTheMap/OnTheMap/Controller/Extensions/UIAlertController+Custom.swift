//
//  UIAlertController+Custom.swift
//  OnTheMap
//
//  Created by bhuvan on 12/04/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit

struct AlertTitle {
    static let login = "Login Failed"
    static let missingField = "Data Missing"
    static let error = "Error"
}

struct AlertMessage {
    static let locationMissing = "Please enter a location."
    static let linkMissing = "Please enter a link."
    static let overrideLocation = "You Have Already Posted a Student Location. Would You Like to Overwrite Your Current Location?"
}



extension UIAlertController {
    class func showAlert(from vc: UIViewController, title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alertVC, animated: true, completion: nil)
    }
}
