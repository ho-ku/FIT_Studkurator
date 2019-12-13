//
//  EventsVC.swift
//  FIT_Studkurator
//
//  Created by Денис Андриевский on 12/6/19.
//  Copyright © 2019 Денис Андриевский. All rights reserved.
//

import UIKit
import Firebase

class EventsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    var searchController: UISearchController!
    @IBOutlet weak var tableView: UITableView!
    private var dataBase = [Event]()
    private var filteredDataBase = [Event]()
    private var chosenEvent: Event!
    private var id: String {
        return UserDefaults.standard.value(forKey: "id") as! String
    }
    private var parser = EventParser()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetch { (result) in
            switch result {
            case .success(let res):
                self.dataBase = res
                self.filteredDataBase = self.dataBase
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
        
               
        // MARK:- Search Controller
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        tableView.tableHeaderView = searchController.searchBar
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search...".localized
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
    
    func fetch(completionHandler: @escaping (Result<[Event], Error>) -> ()) {
        let ref = Database.database().reference()
        ref.child("\(id)").observeSingleEvent(of: .value) { (snapshot) in
    
            guard let snap = snapshot.value! as? NSDictionary, let val = snap.value(forKeyPath: "eventDataBase") else { return }
            guard let response = val as AnyObject as? [String: [String: String]] else { return }
            
            self.dataBase = self.parser.parse(dict: response)
            UserDefaults.standard.set(self.parser.unparse(data: self.dataBase), forKey: "eventDataBase")
            completionHandler(.success(self.dataBase))
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text

        if text == "" {
            filteredDataBase = dataBase
        } else {
            
            filteredDataBase = []
            dataBase.forEach { event in
                if (event.name.lowercased().contains(text!.lowercased())) {
                    filteredDataBase.append(event)
                    self.tableView.reloadData()
                }
            }
            
        }
        
        
        
        tableView.reloadData()
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredDataBase.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EventCell.self), for: indexPath) as! EventCell
        cell.titleLbl.text = filteredDataBase[indexPath.row].name
        let date = filteredDataBase[indexPath.row].date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
        cell.dateLbl.text = dateFormatter.string(from: date ?? Date())
        fetchImage(name: filteredDataBase[indexPath.row].image) { (result) in
            switch result {
            case .success(let data):
                cell.img.image = UIImage(data: data)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        cell.doneImg.isHidden = !filteredDataBase[indexPath.row].isDone
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { (_, _, completionHandler) in
           
            
            let ref = Database.database().reference()
            
            ref.child("\(self.id)/eventDataBase/\(self.dataBase[indexPath.row].number)k").removeValue()
            let storageRef = Storage.storage().reference(withPath: "imgs/event\(self.dataBase[indexPath.row].number).jpg")
            self.dataBase.remove(at: indexPath.row)
            self.filteredDataBase.remove(at: indexPath.row)
            UserDefaults.standard.set(self.parser.unparse(data: self.dataBase), forKey: "eventDataBase")
            storageRef.delete { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                
            }
            self.tableView.reloadData()
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(named: "delete")
        
        let swipeActionsConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActionsConfiguration
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenEvent = dataBase[indexPath.row]
        performSegue(withIdentifier: "detailEvent", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detail = segue.destination as? DetailEventTVC {
            detail.event = chosenEvent
        }
    }
    
    @IBAction func plusBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "newEventSegue", sender: self)
        
    }
    
}
