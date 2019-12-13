//
//  EventParser.swift
//  FIT_Studkurator
//
//  Created by Денис Андриевский on 12/9/19.
//  Copyright © 2019 Денис Андриевский. All rights reserved.
//

import Foundation

class EventParser {
    
    func parse(dict: [String: [String: String]]) -> [Event] {
           
        var base = [Event]()
        for (key, value) in dict {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
            let event = Event(name: value["name"]!, date: dateFormatter.date(from: value["date"]!), isDone: Bool(value["isDone"]!)!, notify: Bool(value["notify"]!)!, image: value["image"]!, number: Int(String(key.first!))!)
            base.append(event)
        }
           
        return base
           
       }
       
       
    func unparse(data: [Event]) -> [String: [String: String]] {
        var dict = [String: [String: String]]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
        data.forEach { event in
            dict["\(event.number)k"] = ["name": event.name, "date": dateFormatter.string(from: event.date ?? Date()), "isDone": String(event.isDone), "notify": String(event.notify), "image": "event\(event.number)"]
        }
           
        return dict
    }
    
}
