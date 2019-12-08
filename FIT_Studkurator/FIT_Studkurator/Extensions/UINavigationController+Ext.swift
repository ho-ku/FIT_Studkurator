//
//  UINavigationController+Ext.swift
//  FIT_Studkurator
//
//  Created by Денис Андриевский on 11/29/19.
//  Copyright © 2019 Денис Андриевский. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
}
