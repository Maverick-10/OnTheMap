//
//  UIView+Corners.swift
//  OnTheMap
//
//  Created by bhuvan on 12/04/2020.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func setCorner(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
}
