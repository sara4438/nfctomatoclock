//
//  ForgetViewController.swift
//  tomato
//
//  Created by cm0532_macAir on 2020/1/20.
//  Copyright © 2020 cm0532_macAir. All rights reserved.
//

import UIKit

class ForgetViewController: UIViewController {

    @IBOutlet var tfEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
    }
    
    func forgetConnectApi(){
        NetWorkController.sharedInstance.connectApiByPost(api: "/warning", params: ["email": tfEmail.text], header: [:])
                {(jsonData) in
                    print(jsonData.description)
                    let resultData = jsonData.dictionary!
                    if resultData["message"]?.string == "success"{
                        self.alert("提醒", "已發送重設密碼連結至您的信箱")
                        self.changePage()
                        print("forget success")
                    }else{
                        print("forget fail")
                    }
        }
    }
    
    func alert(_ titleMsg : String, _ msg : String){
        let controller = UIAlertController(title: titleMsg, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            self.changePage()
        }
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
        
    }
    
    func changePage(){
        
        if let controller = storyboard?.instantiateViewController(withIdentifier: "loginPage") {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func send(_ sender: UIButton) {
       forgetConnectApi()
    }
    
}
