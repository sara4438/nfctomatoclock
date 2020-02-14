//
//  ColorPopupViewController.swift
//  tomato
//
//  Created by cm0532_macAir on 2020/1/17.
//  Copyright © 2020 cm0532_macAir. All rights reserved.
//

import UIKit

class ColorPopupViewController: UIViewController {
    var delegate: ModalDelegate?
    var testValue: String = "I am testing"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func choose(_ sender: UIButton) {
        dismissViewController(sender.currentTitle!)
    }
        
    func dismissViewController(_ color : String ) {
        if let delegate = self.delegate {
            delegate.changeValue(value: color)
        }
   
        dismiss(animated: true, completion: nil)
    }
    
}

protocol ModalDelegate {
    func changeValue(value: String)
}




//
//if let presenter = presentingViewController as? TomatoAddViewController {
//       presenter.testValue = self.testValue
//   }
//
