//
//  EventsVC.swift
//  FIT_Studkurator
//
//  Created by Денис Андриевский on 12/6/19.
//  Copyright © 2019 Денис Андриевский. All rights reserved.
//

import UIKit


class EventsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    var searchController: UISearchController!
    @IBOutlet weak var tableView: UITableView!
    private var dataBase = [Event]()
    private var filteredDataBase = [Event]()
    private var chosenEvent: Event!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
               
        // MARK:- Search Controller
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        tableView.tableHeaderView = searchController.searchBar
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search...".localized
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
        cell.dateLbl.text = dateFormatter.string(from: date!)
        if let image = UIImage(data: filteredDataBase[indexPath.row].image) {
            cell.img.image = image
        } else {
            cell.img.image = UIImage(named: "photo")
        }
        cell.doneImg.isHidden = !filteredDataBase[indexPath.row].isDone
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "") { (_, _, completionHandler) in
           
            self.dataBase.remove(at: indexPath.row)
            self.filteredDataBase.remove(at: indexPath.row)
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
