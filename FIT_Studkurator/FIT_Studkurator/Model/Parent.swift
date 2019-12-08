//
//  Parent.swift
//  FIT_Studkurator
//
//  Created by Денис Андриевский on 11/29/19.
//  Copyright © 2019 Денис Андриевский. All rights reserved.
//

import Foundation

enum ParentType: String {
    
    case mother = "Mother"
    case father = "Father"
    
}

struct Parent {
    
    var type: ParentType
    var fullName: String
    var phoneNumber: String
    
}
