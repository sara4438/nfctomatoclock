//
//  TamatoTableViewCell.swift
//  tomato
//
//  Created by cm0532_macAir on 2020/1/5.
//  Copyright © 2020 cm0532_macAir. All rights reserved.
//

import UIKit

class TomatoTableViewCell: UITableViewCell {

  
    @IBOutlet var lbTime: UILabel!
    @IBOutlet var lbActivity: UILabel!
    @IBOutlet var myImageView: UIImageView!
    
    @IBOutlet var btnEdit: UIButton!
    var index :Int?
    var completionHandler :((Int)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editTomato(_ sender: UIButton) {
        if let index = index{
            completionHandler?(index)
        }
      }

    
}
