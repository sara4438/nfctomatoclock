//
//  AlarmTableViewCell.swift
//  tomato
//
//  Created by cm0532_macAir on 2020/1/15.
//  Copyright © 2020 cm0532_macAir. All rights reserved.
//

import UIKit

class AlarmTableViewCell: UITableViewCell {

    @IBOutlet var lbCycle: UILabel!
    @IBOutlet var lbName: UILabel!
    @IBOutlet var lbTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
