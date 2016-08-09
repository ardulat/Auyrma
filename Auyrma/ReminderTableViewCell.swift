//
//  ReminderTableViewCell.swift
//  Auyrma
//
//  Created by MacBook on 25.07.16.
//  Copyright © 2016 Yerzhan Mademikhanov. All rights reserved.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {

    @IBOutlet weak var reminderName: UILabel!
    @IBOutlet weak var reminderTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
