//
//  TodoTableViewCell.swift
//  tomato
//
//  Created by cm0532_macAir on 2020/1/8.
//  Copyright © 2020 cm0532_macAir. All rights reserved.
//

import UIKit

class TodoTableViewCell: UITableViewCell {

    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var lbTodo: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    var index :Int?
    var id : String = ""
    var completionHandler :((Int, String)->Void)?

    
    @IBAction func editTomato(_ sender: UIButton) {
        if let index = index{
            completionHandler?(index, id)
        }
      }

    
}
