//
//  EventCell.swift
//  FIT_Studkurator
//
//  Created by Денис Андриевский on 12/6/19.
//  Copyright © 2019 Денис Андриевский. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var img: UIImageView! {
        didSet {
            img.layer.cornerRadius = img.layer.frame.size.width/2
        }
    }
    @IBOutlet var doneImg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
