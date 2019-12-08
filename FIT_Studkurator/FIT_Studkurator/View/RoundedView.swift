//
//  RoundedView.swift
//  FIT_Studkurator
//
//  Created by Денис Андриевский on 12/2/19.
//  Copyright © 2019 Денис Андриевский. All rights reserved.
//

import UIKit
@IBDesignable
class RoundedView: UIView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        customizeView()
    }
    
    override func prepareForInterfaceBuilder() {
        customizeView()
    }
    
    func customizeView() {
        layer.cornerRadius = 7.0
        layer.masksToBounds = true
    }

}
