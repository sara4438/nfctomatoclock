//
//  IconPopupViewController.swift
//  tomato
//
//  Created by cm0532_macAir on 2020/1/25.
//  Copyright © 2020 cm0532_macAir. All rights reserved.
//

import UIKit

class IconPopupViewController: UIViewController {
    var delegate:IconPopupDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
    }

  
    @IBAction func choose(_ sender: UIButton) {
        dismissViewController(sender.currentTitle!)
       }

    func dismissViewController(_ image : String ) {
        if let delegate = self.delegate {
        delegate.changeIcon(value: image)
        }
        dismiss(animated: true, completion: nil)
    }
}

protocol IconPopupDelegate {
    func changeIcon(value: String)
}
