//
//  LoginViewController.swift
//  tomato
//
//  Created by cm0532_macAir on 2019/12/26.
//  Copyright © 2019 cm0532_macAir. All rights reserved.
//

import UIKit

var token : String = ""
var userId : Int = 0
var userEmail : String = ""
var userName : String = ""
class LoginViewController:  UIViewController, UITextFieldDelegate{
    
    var password : String = ""
    @IBOutlet var btnLogin: UIButton!
    let userDefaults = UserDefaults.standard
    
    @IBOutlet var tfPassword: UITextField!
    @IBOutlet var tfEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        tfPassword.delegate = self
        tfEmail.delegate = self
        initBtn()
        getDataFromSp()
        keyboardGone()
       
    }
    func getDataFromSp(){
        if let userId = userDefaults.value(forKey: "account") as? String{
            tfEmail.text = userId
            if let userPassword = userDefaults.value(forKey: "password") as? String{
                tfPassword.text = userPassword
            }
            
            print(tfEmail.text!)
            print(tfPassword.text!)
        }
    }

//
    func initBtn(){
        btnLogin.layer.cornerRadius = 8
        btnLogin.clipsToBounds = true
        
    }
    func loadSettingApi(){
        NetWorkController.sharedInstance.connectApiByGet(api: "/v1/setting",   header : ["Authorization" : "Bearer \(token)"]){(jsonData) in
                let resultData = jsonData.dictionary!
                    if resultData["message"]?.string == "success"{
                        for set in (resultData["setting"]?.array)!{
                            sTomatoTime = set["minute"].intValue
                            sRestTime = set["short"].intValue
                            sIsRinging = set["ring"].boolValue
                            print("isRing:\(sIsRinging)")
                            sIsVibrating = set["vibration"].boolValue
                            imgPath = set["path"].stringValue
    //                        if set["ring"].int! == 1{
    //                            sIsRinging = false
    //                        }else{
    //                            sIsRinging = true
    //                        }
                        }
                        print("getSetting success")
                }else{
                    print("getSetting wrong")
                }
            }
        }
    
    @IBAction func login(_ sender: UIButton) {
        if checkField() {
            userEmail = tfEmail.text!
            password = tfPassword.text!
        }
        userDefaults.set(tfEmail.text, forKey: "account")
        userDefaults.set(tfPassword.text, forKey: "password")
//        changePage()  //測試階段
       connectApi()  // 測試階段
            
    }
    
    @IBAction func changeToForget(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "forgetPage")
        self.navigationController?.pushViewController(controller!, animated: true)
    }
    
    func changePage(){
        if let controller = storyboard?.instantiateViewController(withIdentifier: "tabBarController") {
        
        present(controller, animated: true, completion: nil)
        }
    }
    
    func connectApi(){
       print("email:\(userEmail)")
       print("password:\(password)")
        NetWorkController.sharedInstance.connectApiByPost(api: "/auth/login", params: ["email": "\(userEmail)", "password": "\(password)"], header : [:])
                {(jsonData) in
                    let resultData = jsonData.dictionary!
                    if resultData["message"]?.string == "success"{
                        token = (resultData["access_token"]?.string)!
                        let user = resultData["user"]?.dictionary
                        userName = (user!["name"]?.string)!
                        userId = (user!["id"]?.intValue)!
                        print("userName:\(user!["name"])")
                        print("token:\(token)")
                        print("login success")
                        self.loadSettingApi()
                        self.changePage()
                    }else{
                        print("login fail")
                        self.apiAlert()
                    }
        }
    }
    
    func apiAlert(){
        let controller = UIAlertController(title: "登入失敗", message: "請重新檢查帳號密碼！", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
    
    
    func checkField()->Bool{
        if tfEmail.text!.isEmpty {
           let controller = UIAlertController(title: "輸入不完整", message: "忘了輸入E-mail喔！", preferredStyle: .alert)
           let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
           controller.addAction(okAction)
           present(controller, animated: true, completion: nil)
            return false
        }
        if tfPassword.text!.isEmpty{
            let controller = UIAlertController(title: "輸入不完整", message: "忘了輸入密碼喔！", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
            return false
        }
            return true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    func keyboardGone(){
       let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
            self.view.addGestureRecognizer(tap) // to Replace "TouchesBegan"
    }

    @objc func dismissKeyBoard() {
            self.view.endEditing(true)
    }



}
