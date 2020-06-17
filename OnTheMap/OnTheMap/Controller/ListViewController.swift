//
//  ListViewController.swift
//  OnTheMap
//
//  Created by bhuvan on 10/04/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController {
    
    // MARK: - Outlets
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Table view delegate and datasource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UserManager.shared.locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")!
        
        let model = UserManager.shared.locations[indexPath.row]
        cell.textLabel?.text = model.firstName + " " + model.lastName
        cell.detailTextLabel?.text = model.mediaURL
        cell.imageView?.image = UIImage(named: "icon_pin")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: UserManager.shared.locations[indexPath.row].mediaURL) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
