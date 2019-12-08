//
//  DetailEvent.swift
//  FIT_Studkurator
//
//  Created by Денис Андриевский on 12/8/19.
//  Copyright © 2019 Денис Андриевский. All rights reserved.
//

import UIKit

class DetailEventTVC: UITableViewController {
    
    var event: Event!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = event.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        dateLabel.text = dateFormatter.string(from: event.date!)
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
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "GroupVC")
        self.present(controller, animated: true, completion: nil)
    }
    
}
