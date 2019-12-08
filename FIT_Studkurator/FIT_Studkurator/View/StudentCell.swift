//
//  StudentCell.swift
//  FIT_Studkurator
//
//  Created by Денис Андриевский on 12/2/19.
//  Copyright © 2019 Денис Андриевский. All rights reserved.
//

import UIKit

class StudentCell: UITableViewCell {
    
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
