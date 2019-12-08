//
//  RoundedCornerButton.swift
//  FIT_Studkurator
//
//  Created by Денис Андриевский on 12/7/19.
//  Copyright © 2019 Денис Андриевский. All rights reserved.
//

import UIKit
@IBDesignable
class RoundedCornerButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        customizeView()
    }
    
    override func prepareForInterfaceBuilder() {
        customizeView()
    }
    
    func customizeView() {
        layer.cornerRadius = 10.0
        layer.masksToBounds = true
    }

}
