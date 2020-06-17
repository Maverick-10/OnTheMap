//
//  MapAndTabbedViewController.swift
//  OnTheMap
//
//  Created by bhuvan on 10/04/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

protocol MapAndTabbedViewDelegate {
    func logout()
    func refreshList()
    func addLocation()
}

class MapAndTabbedViewController: UITabBarController {
    
    public weak var mapAndTabDelegate: MapAndTabbedViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "On the Map"
        
        // Add left bar button
        let logoutBarButton = UIBarButtonItem(title: "LOGOUT", style: .done, target: self, action: #selector(logout))
        navigationItem.leftBarButtonItem = logoutBarButton
        
        // Add right bar button
        let refreshBarButton = UIBarButtonItem(image: UIImage(named: "icon_refresh"), style: .done, target: self, action: #selector(refreshRecentLocations))
        let addLocationButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLocation))
        navigationItem.rightBarButtonItems = [addLocationButton, refreshBarButton]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    @objc func logout() {
        UdacityClient.logout {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func refreshRecentLocations() {
        UdacityClient.getStudentInformation(completion: handleLocationResponse(response:error:))
    }
    
    func handleLocationResponse(response: StudentListResponse?, error: Error?) {
        if let response = response {
            UserManager.shared.locations = response.results
            if let listVC = selectedViewController as? ListViewController {
                listVC.tableView.reloadData()
            } else if let mapVC = selectedViewController as? MapViewController  {
                mapVC.updateAnnotations(response: response.results)
            }
        } else {
            UIAlertController.showAlert(from: self,
                                        title: AlertTitle.error,
                                        message: error?.localizedDescription ?? "")
        }
    }
    
    @objc func addLocation() {
        func openNextVC() {
            let informationPostingVC = storyboard?.instantiateViewController(identifier: "InformationPostingNavigation") as! UINavigationController
            present(informationPostingVC, animated: true, completion: nil)
        }
        
        if UserManager.shared.objectId.isEmpty {
            openNextVC()
        } else {
            let alert = UIAlertController(title: "", message: AlertMessage.overrideLocation, preferredStyle: .alert)
            let overwriteAction = UIAlertAction(title: "Overwrite", style: .default) { _ in
                performUIUpdate {
                    openNextVC()
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            alert.addAction(overwriteAction)
            present(alert, animated: true, completion: nil)
        }
    }
}
