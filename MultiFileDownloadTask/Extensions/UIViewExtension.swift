//
//  UIViewExtension.swift
//  MultiFileDownloadTask
//
//  Created by Admin on 16/01/21.
//  Copyright © 2021 Subburaman, Rajai Kumar. All rights reserved.
//

import Foundation
import UIKit
// MARK: - UIView extension
extension UIView {
    
    @IBInspectable var cornerRadiusLocal: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
   
    
    
}
