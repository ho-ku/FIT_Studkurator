//
//  StudentDetailTVC.swift
//  FIT_Studkurator
//
//  Created by Денис Андриевский on 12/2/19.
//  Copyright © 2019 Денис Андриевский. All rights reserved.
//

import UIKit

class StudentDetailTVC: UITableViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var currentAddressLabel: UILabel!
    @IBOutlet weak var homeAddressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var motherNameLabel: UILabel!
    @IBOutlet weak var motherPhoneLabel: UILabel!
    @IBOutlet weak var fatherNameLabel: UILabel!
    @IBOutlet weak var fatherPhoneLabel: UILabel!
    
    var student: Student!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // MARK:- Setup UI
        nameLabel.text = student.fullName
        numberLabel.text = "\(student.number)."
        currentAddressLabel.text = student.address
        homeAddressLabel.text = student.homeAddress
        motherNameLabel.text = student.mother.fullName
        fatherNameLabel.text = student.father.fullName
        motherPhoneLabel.text = student.mother.phoneNumber
        fatherPhoneLabel.text = student.father.phoneNumber
        phoneLabel.text = student.phoneNumber
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 6
    }

    
    @IBAction func backBtnPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "GroupVC")
        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func editBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "editSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? EditTVC {
            dest.student = student
        }
    }
    
}
