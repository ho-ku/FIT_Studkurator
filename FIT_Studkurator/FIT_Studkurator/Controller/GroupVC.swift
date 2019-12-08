//
//  GroupVC.swift
//  FIT_Studkurator
//
//  Created by Денис Андриевский on 12/2/19.
//  Copyright © 2019 Денис Андриевский. All rights reserved.
//

import UIKit


class GroupVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    var searchController: UISearchController!
    @IBOutlet weak var tableView: UITableView!
    private var dataBase = [Student]()
    private var filteredResults = [Student]()
    private var studentIndex = Int()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        
        filteredResults = dataBase
        
        UserDefaults.standard.set(dataBase, forKey: "dataBase")
        
        // MARK:- Search Controller
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        tableView.tableHeaderView = searchController.searchBar
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search...".localized
    
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text
        filteredResults = []
        
        if text == "" {
            filteredResults = dataBase
        } else {
            var numberLine = ""
            var charsLine = ""
            for char in text! {
                if Int(String(char)) != nil {
                    numberLine += String(char)
                } else if char == " " || char == "," || char == ":" || char == ";" || char == "/" || char == "?" || char == "!" || char == "." {
                } else {
                    charsLine += String(char)
                }
            }
        
            for char in numberLine {
                let number = Int(String(char))
                for student in dataBase {
                    if "\(student.number)".contains(String(describing: number!)) {
                        filteredResults.append(student)
                    }
                }
            }
            
            
            for student in dataBase {
                if student.fullName.lowercased().contains(charsLine.lowercased()) {
                    filteredResults.append(student)
                }
            }
            
            if charsLine.count == 0 && numberLine.count == 0 {
                filteredResults = dataBase
            }
            
        }
        
        sort()
        tableView.reloadData()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: StudentCell.self), for: indexPath) as! StudentCell
        
        cell.nameLabel.text = filteredResults[indexPath.row].fullName
        cell.numberLabel.text = "\(filteredResults[indexPath.row].number)."
        cell.accessoryType = .disclosureIndicator
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        studentIndex = indexPath.row
        performSegue(withIdentifier: "detailStudentSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detail = segue.destination as? StudentDetailTVC {
            detail.student = filteredResults[studentIndex]
        }
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "newStudentSegue", sender: self)
        
    }
    
    func sort() {
        var dict = Dictionary<Int, Any>()
        var keyArray = [Int]()
        for student in filteredResults {
            dict[student.number] = student
            keyArray.append(student.number)
        }
        filteredResults = []
        keyArray.sort()
        for el in keyArray {
            filteredResults.append(dict[el] as! Student)
        }
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { (_, _, completionHandler) in
          
            self.dataBase.remove(at: indexPath.row)
            self.filteredResults.remove(at: indexPath.row)
            UserDefaults.standard.set(self.dataBase, forKey: "dataBase")
            self.tableView.reloadData()
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(named: "delete")
        
        let swipeActionsConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActionsConfiguration
    }
    
}
