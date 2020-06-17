//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by bhuvan on 10/04/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    // MARK - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    static let signUpUrlString = "https://auth.udacity.com/sign-up"
    
    
    // MARK - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK - Actions
    @IBAction func loginButtonPressed(_ sender: Any) {
        setLoggingIn(true)
        UdacityClient.login(email: emailTextField.text ?? "",
                            password: passwordTextField.text ?? "",
                            completion: handleLoginResponse(success:error:))
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        guard let url = URL(string: LoginViewController.signUpUrlString) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
    // MARK: - Helpers
    func handleLoginResponse(success: Bool, error: Error?) {
        setLoggingIn(false)
        if success {
            let mapAndListTabVC = storyboard?.instantiateViewController(identifier: "MapAndTabbedViewController") as! MapAndTabbedViewController
            navigationController?.pushViewController(mapAndListTabVC, animated: true)
        } else {
            UIAlertController.showAlert(from: self,
                                        title: AlertTitle.login,
                                        message: error?.localizedDescription ?? "")
        }
    }
    
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
}
