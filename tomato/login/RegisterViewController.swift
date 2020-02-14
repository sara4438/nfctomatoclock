//
//  RegisterViewController.swift
//  tomato
//
//  Created by cm0532_macAir on 2019/12/26.
//  Copyright © 2019 cm0532_macAir. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate ,UIPickerViewDelegate, UIPickerViewDataSource{
 
    
    var password : String = ""
    var name : String = ""
    var userType : String = ""
    var userTypeOptions = ["國考", "高考", "普考", "寫論文", "研究所/ 博班", "學測", "指考"]
//    var examDate : String = ""
    @IBOutlet var choices: [UIButton]!
    
    
    @IBOutlet var tfName: UITextField!
    @IBOutlet var tfEmail: UITextField!
    @IBOutlet var tfPassword: UITextField!
    
    @IBOutlet var tfConfirmPassword: UITextField!
    @IBOutlet var btnRegister: UIButton!
    let datePicker = UIDatePicker()
    
//    @IBOutlet var tfExamDate: UITextField!
    var selectedUserType : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        initBtn()
        keyboardGone()
        setPickerView()
    }
    
    @IBAction func checkLength(_ sender: UITextField) {
        if sender.text!.count < 8 {
            alertPassword("註冊訊息","密碼長度需超過8碼")
        }
    }
    func setPickerView(){
        let userTypeView = UIPickerView()
            datePickerView()
        // 設定 UIPickerView 的 delegate 及 dataSource
        userTypeView.delegate = self
        userTypeView.dataSource = self
        
             // 將 UITextField 原先鍵盤的視圖更換成 UIPickerView
       
    }
    func datePickerView(){
        datePicker.datePickerMode = .date
               
               //選取時間 -> 以15分鐘為一個間隔
               datePicker.minuteInterval = 15
               
               //設定預設顯示時間 -> 為現在時間
               datePicker.date = NSDate() as Date
               
               //設置NSDate的格式
               let formatter = DateFormatter()
               
               //設置顯示個格式
               formatter.dateFormat = "yyyy-MM-dd"
               
               //可以選擇的最早日期時間
               datePicker.minimumDate = NSDate() as Date
               
               //可以選擇的最晚日期時間
               datePicker.maximumDate = formatter.date(from: "2022-01-01")
               
               //picker預設英文，改為顯示中文
               datePicker.locale = Locale(identifier: "zh_CN")
               
               //設置改變日期時間時會執行動作的方法
               datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)

//               tfExamDate.inputView = datePicker
               
    }
    
    @objc func datePickerChanged(datePicker:UIDatePicker) {
           // 設置要顯示在 textField 的日期時間格式
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"

           // 更新 textField 的內容
//           tfExamDate.text = formatter.string(from: datePicker.date)
//           examDate = tfExamDate.text!
       }
    
    func initBtn(){
      btnRegister.layer.cornerRadius = 8
      btnRegister.clipsToBounds = true
    }
    
//    @IBAction func startSelect(_ sender: UIButton) {
//
//        for choice in choices{
//            UIView.animate(withDuration: 0.3, animations: {
//            choice.isHidden = !choice.isHidden
//                self.view.layoutIfNeeded()
//            })
//        }
//    }
    
    func registerApi(){
        NetWorkController.sharedInstance.connectApiByPost(api: "/auth/register", params: ["email": "\(userEmail)", "password": "\(password)", "name" : "\(name)"], header: ["Accept": "application/json"])
                {(jsonData) in
                    print(jsonData.description)
                    let resultData = jsonData.dictionary!
                    if resultData["message"]?.string == "success"{
                        self.alert("註冊訊息", "註冊成功")
                        self.loginConnectApi()
                        self.changePage()
                        print("register success")
                    }else{
                        self.alertPassword("註冊訊息", "註冊失敗, 此帳號已有人使用")
                        print("register fail")
                    }
        }
    }
    
    func loginConnectApi(){
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
                        self.createSettingApi()
                        self.loadDefaultData()
                        self.changePage()
                        
                    }else{
                        print("login fail")
                    }
        }
    }
    
    func createSettingApi() {
        NetWorkController.sharedInstance.connectApiByPost(api: "/v1/setting", params: [:], header : ["Authorization" : "Bearer \(token)"])
               {(jsonData) in
               let resultData = jsonData.dictionary!
               if resultData["message"]?.string == "success"{
                       print("create setting success")
                }else{
                   print("create setting fail")
               }
        }
   }
    
    func loadDefaultData(){
        NetWorkController.sharedInstance.connectApiByGet(api: "/auth/builder",   header : ["Authorization" : "Bearer \(token)"]){(jsonData) in
                       let resultData = jsonData.dictionary!
                           if resultData["message"]?.string == "success"{
                               print("get default success")
                       }else{
                           print("get default wrong")
                       }
               }
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
        if tfConfirmPassword.text != tfPassword.text {
            let controller = UIAlertController(title: "輸入不完整", message: "確認密碼有誤！", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
            return false
        }
        if tfName.text!.isEmpty{
            let controller = UIAlertController(title: "輸入不完整", message: "忘了輸入名稱喔！", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            controller.addAction(okAction)
            present(controller, animated: true, completion: nil)
            return false
        }
        if tfPassword.text!.count < 8 {
            alertPassword("註冊訊息","密碼長度需超過8碼")
            return false
        }
        
//        if tfUserType.text!.isEmpty {
//            let controller = UIAlertController(title: "輸入不完整", message: "請選擇考生種類！", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//            controller.addAction(okAction)
//            present(controller, animated: true, completion: nil)
//            return false
//        }
//        if tfExamDate.text!.isEmpty {
//            let controller = UIAlertController(title: "輸入不完整", message: "請選擇考試日期！", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//            controller.addAction(okAction)
//            present(controller, animated: true, completion: nil)
//            return false
//        }
        
            return true
    }
    
    @IBAction func register(_ sender: Any) {
        if checkField() {
            assignValue()
            registerApi()
            
            userEmail = tfEmail.text!
        }
    }
    
    // -----設定picker view 開始
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
             return 1
         }
         //裡面有幾列
         public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
             return userTypeOptions.count
         }
         //選擇到的那列要做的事
//         func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//             tfUserType.text = String(userTypeOptions[row])
//             userType = userTypeOptions[row]
//          }
          
         
      
         //設定每列PickerView要顯示的內容
         func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
             return String(userTypeOptions[row])
         }
    //-----設定picker view 結束
    
    
    func assignValue(){
        userEmail = tfEmail.text!
        password = tfPassword.text!
        name = tfName.text!
        userName = tfName.text!
    }
    
    func changePage(){
        
        if let controller = storyboard?.instantiateViewController(withIdentifier: "setting") {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    func alertPassword(_ titleMsg : String, _ msg : String){
        let controller = UIAlertController(title: titleMsg, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            
        }
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
        
    }
    
    func alert(_ titleMsg : String, _ msg : String){
        let controller = UIAlertController(title: titleMsg, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            self.changePage()
        }
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
        
    }
    
//    @IBAction func optionProgress(_ sender: UIButton) {
//        let userType = sender.currentTitle ?? ""
//        selectedUserType = userType
//        btnUserType.setTitle(selectedUserType, for: .normal)
////        print (userType)
//        for choice in choices{
//        UIView.animate(withDuration: 0.3, animations: {
//        choice.isHidden = !choice.isHidden
//            self.view.layoutIfNeeded()
//        })
//        }
//    }
    
    
    func keyboardGone(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
             self.view.addGestureRecognizer(tap) // to Replace "TouchesBegan"
     }

     @objc func dismissKeyBoard() {
         self.view.endEditing(true)
     }


}
