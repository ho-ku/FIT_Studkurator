//
//  RoundedCornerTextField.swift
//  FIT_Studkurator
//
//  Created by Денис Андриевский on 11/29/19.
//  Copyright © 2019 Денис Андриевский. All rights reserved.
//

import UIKit

class RoundedCornerTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 10)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 15.0
        layer.masksToBounds = true
    }

}
