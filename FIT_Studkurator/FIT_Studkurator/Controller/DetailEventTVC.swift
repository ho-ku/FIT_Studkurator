//
//  DetailEvent.swift
//  FIT_Studkurator
//
//  Created by Денис Андриевский on 12/8/19.
//  Copyright © 2019 Денис Андриевский. All rights reserved.
//

import UIKit
import Firebase

class DetailEventTVC: UITableViewController {
    
    var event: Event!
    private var dataBase = [Event]()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var img: UIImageView!
    private var id: String {
        return UserDefaults.standard.value(forKey: "id") as! String
    }
    private var parser = EventParser()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let value = UserDefaults.standard.value(forKey: "eventDataBase") as? [String: [String: String]] {
            dataBase = parser.parse(dict: value)
        }
        
        titleLabel.text = event.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateLabel.text = dateFormatter.string(from: event.date ?? Date())
        
        fetchImage(name: event.image) { (result) in
            switch result {
            case .success(let val):
                self.img.image = UIImage(data: val)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchImage(name: String, completion: @escaping (Result<Data, Error>) -> ()) {
        
        let storageRef = Storage.storage().reference(withPath: "imgs/\(name).jpg")
        
        storageRef.getData(maxSize: 4 * 4098 * 4098) { (data, error) in
             if let error = error {
                 print(error.localizedDescription)
                 completion(.failure(error))
             }
            if let data = data {
                completion(.success(data))
                 
             }
         }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return 3
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "GroupVC")
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func markBtnPressed(_ sender: Any) {
        
        mark(event: event) { (_) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "GroupVC")
            self.present(controller, animated: true, completion: nil)
        }
        
    }
    
    func mark(event: Event, completionHandler: @escaping (Result<Any, Error>) -> ()) {
        let ref = Database.database().reference()
        ref.child("\(id)/eventDataBase/\(event.number)k/isDone").setValue("true")
        dataBase.enumerated().forEach { index, ev in
            if ev.number == event.number {
                self.dataBase[index].isDone = true
            }
        }
        UserDefaults.standard.set(self.parser.unparse(data: self.dataBase), forKey: "eventDataBase")
        completionHandler(.success(self.dataBase))
        
        
        
    }
    
}
