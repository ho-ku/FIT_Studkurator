//
//  Parser.swift
//  FIT_Studkurator
//
//  Created by Денис Андриевский on 12/9/19.
//  Copyright © 2019 Денис Андриевский. All rights reserved.
//

import Foundation

class Parser {
    
    func parse(dict: [String: [String: String]]) -> [Student] {
        
        var base = [Student]()
        for (key, value) in dict {
            let student = Student(fullName: value["name"]!, number: Int(String(key.first!))!+1, address: value["address"]!, mother: Parent(type: .mother, fullName: value["motherName"]!, phoneNumber: value["motherPhone"]!), father: Parent(type: .father, fullName: value["fatherName"]!, phoneNumber: value["fatherPhone"]!), homeAddress: value["homeAddress"]!, phoneNumber: value["phone"]!)
            base.append(student)
        }
        
        return base
        
    }
    
    
    func unparse(data: [Student]) -> [String: [String: String]]{
        var dict = [String: [String: String]]()
        data.forEach { student in
            dict["\(student.number-1)k"] = ["address": student.address, "fatherName": student.father.fullName, "fatherPhone": student.father.phoneNumber, "name": student.fullName, "homeAddress": student.homeAddress, "motherName": student.mother.fullName, "motherPhone": student.mother.phoneNumber, "phone": student.phoneNumber]
        }
        
        return dict
    }
    
}
