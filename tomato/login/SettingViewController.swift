//
//  SettingViewController.swift
//  tomato
//
//  Created by cm0532_macAir on 2019/12/30.
//  Copyright © 2019 cm0532_macAir. All rights reserved.
//

var sTomatoTime : Int = 0
var sRestTime : Int = 0
var sFightingMode : Bool = false
var sIsVibrating : Bool = false
var sIsRinging : Bool = false

var settingId : String = ""
var imgPath : String = ""

import UIKit
import DatePickerDialog
import AudioToolbox

class SettingViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var btnSave: UIButton!
    
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet var lbEmail: UILabel!
//    @IBOutlet var lbTaskIntervalInfo: UILabel!
    @IBOutlet var lbRestInfo: UILabel!
    @IBOutlet var lbTomatoInfo: UILabel!
    @IBOutlet weak var tfTomatoTime: UITextField!
    @IBOutlet var tfRestTime: UITextField!
    
    @IBOutlet var swRing: UISwitch!
    @IBOutlet var swVibrate: UISwitch!
//    @IBOutlet var swAutoNext: UISwitch!
    @IBOutlet var lbUserName: UILabel!
//    @IBOutlet var tfTaskInterval: UITextField!
//    @IBOutlet var lbTaskIntervalMin: UILabel!
//    @IBOutlet var lbLongRest: UILabel!
//    @IBOutlet var btnLongRestInfo: UIButton!
//    @IBOutlet var tfLongRest: UITextField!
//    @IBOutlet var lbLongRestMin: UILabel!
//    @IBOutlet var lbAuto: UILabel!
    @IBOutlet var lbShortRest: UILabel!
    
    let settingDefaults = UserDefaults.standard
    var numbers = [Int]()
    var tomatoInfoIsClicked : Bool = true
    var restInfoIsClicked : Bool = true
    var taskIntervalIsClicked : Bool = true
    
    var tomatoTime : Int = 5
    var restTime : Int = 3
    var taskInterval :Int = 20
    var fightingMode : Bool = false
    var isVibrating : Bool = false
    var isRinging : Bool = false
    var photoArray  = [String]()
    var dateFormatString: String = ""

    func update() {
        tfTomatoTime.text = ""
    }
    func putNum(){
        for i in 1...180 {
           numbers.append(i)
        }
    }

    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        super.viewDidLoad()
        lbEmail.text = userEmail
        lbUserName.text = userName
//        lbTaskIntervalInfo.isHidden = true
        lbTomatoInfo.isHidden = true
        lbRestInfo.isHidden = true
        putNum()
        loadSettingApi()
        keyboardGone()
        pickerSetting()
//        getDataFromSp()
        loadFile()
        createToday()
        hideTabBar()
    }
    func createToday(){
        let today = Date()
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatString = dateFormatter.string(from: today)
        print(dateFormatString)
        
    }
    
    func getDataFromSp(){
        if let tomatoTime = settingDefaults.value(forKey: "tomatoTime") as? String{
            tfTomatoTime.text = tomatoTime
        }
        if let restTime = settingDefaults.value(forKey: "restTime") as? String{
            tfRestTime.text = restTime
        }
//        if let autoNext = settingDefaults.value(forKey: "autoNext") as? Bool{
//            swAutoNext.isOn = autoNext
//        }
        if let vibrate = settingDefaults.value(forKey: "vibrate") as? Bool{
            swVibrate.isOn = vibrate
        }
        if let ring = settingDefaults.value(forKey: "ring") as? Bool{
            swRing.isOn = ring
//
//            print(tfEmail.text!)
//            print(tfPassword.text!)
        }
    }
    
    func pickerSetting(){
        // 建立 UIPickerView
          let tomatoView = UIPickerView()
          let restPickerView = UIPickerView()
          let taskIntervalPickerView = UIPickerView()
          // 設定 UIPickerView 的 delegate 及 dataSource
          tomatoView.delegate = self
          tomatoView.dataSource = self
           restPickerView.delegate = self
           restPickerView.dataSource = self
           taskIntervalPickerView.delegate = self
           taskIntervalPickerView.dataSource = self
          // 將 UITextField 原先鍵盤的視圖更換成 UIPickerView
          tfTomatoTime.inputView = tomatoView
          tfRestTime.inputView = restPickerView
//          tfTaskInterval.inputView = taskIntervalPickerView
        
        // 在imgProfile加入偵測點擊
           let tap = UITapGestureRecognizer.init(target: self, action: #selector(showAlertDialogue))
          
        profileImg.isUserInteractionEnabled = true
        profileImg.addGestureRecognizer(tap)
    }
    
    //當使用者選完照片之後的行為
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImg.image = selectedImage
            profileImg.contentMode = .scaleAspectFill
            profileImg.clipsToBounds = true
            profileImg.layer.cornerRadius = 35
            
            let fileManager = FileManager.default
            let docUrls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
            let docUrl = docUrls.first
            let interval = Date.timeIntervalSinceReferenceDate
            let name = "\(interval).jpg"
            
            let url = docUrl?.appendingPathComponent(name)
            let data = profileImg.image!.jpegData(compressionQuality: 0.9)
            try! data?.write(to: url!)
            print("name:\(name)")
            imgPath = name
            //儲存
//            photoArray[0] = name
            
            
        }
        dismiss(animated: true, completion: nil)
    }
    //儲存紀錄位址的photoArray
//       func saveFile(){
//          let fileManager = FileManager.default
//          let docUrls = fileManager.urls(for: .documentDirectory, in:
//       .userDomainMask)
//          let docUrl = docUrls.first
//          let url = docUrl?.appendingPathComponent("photoArray.txt")
//          let array = photoArray
//          (array as NSArray).write(to: url!, atomically: true)
//       }
//       //讀取紀錄位址的photoArray
       func loadFile(){
          let fileManager = FileManager.default
          let docUrls = fileManager.urls(for: .documentDirectory, in:
          .userDomainMask)
          let docUrl = docUrls.first
//          let url = docUrl?.appendingPathComponent("photoArray.txt")
//          if let array = NSArray(contentsOf: url!){
//            photoArray = array as! [String]
        print("imgPath:\(imgPath)")
            if imgPath != "default" && imgPath != ""{
                let url1 = docUrl?.appendingPathComponent(imgPath)
               profileImg.image = UIImage(contentsOfFile: (url1?.path)!)
               profileImg.contentMode = .scaleAspectFill
               profileImg.clipsToBounds = true
               profileImg.layer.cornerRadius = 35
            }else{
                profileImg.image = UIImage(systemName: "person.circle")
            }
       
    }
    
    @objc func showAlertDialogue(){
        let photoSourceAlert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let cameraAction = UIAlertAction(title: "拍照", style: .default, handler: {
            (action:UIAlertAction) -> Void in
            //本裝置具備拍照功能
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .camera

                self.present(imagePicker, animated: true, completion: nil)
            }
        })

        let photoLibraryAction = UIAlertAction(title: "選擇相片", style: .default, handler: {
            (action:UIAlertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary

                self.present(imagePicker, animated: true, completion: nil)
            }
        })

        //加入取消動作
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        photoSourceAlert.addAction(cancelAction)

        photoSourceAlert.addAction(cameraAction)
        photoSourceAlert.addAction(photoLibraryAction)

        present(photoSourceAlert, animated: true, completion: nil)
    }
    
//
//    @IBAction func autoNext(_ sender: UISwitch) {
//        if sender.isOn{
////            tfTaskInterval.isHidden = false
////            lbTaskIntervalMin.isHidden = false
//            fightingMode = true
//
//            }else{
//            tfTaskInterval.isHidden = true
//            lbTaskIntervalMin.isHidden = true
//            fightingMode = false
//        }
//    }
    @IBAction func vibrate(_ sender: UISwitch) {
        if sender.isOn{
            isVibrating = true
            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { }
        }else{
            isVibrating = false
        }
    }
    
    @IBAction func ring(_ sender: UISwitch) {
        if sender.isOn{
            isRinging = true
        }else{
            isRinging = false
        }
    }
    
    @IBAction func tomatoInfoTapped(_ sender: UIButton) {
        if sender.tag == 1{
            if tomatoInfoIsClicked{
                lbTomatoInfo.isHidden = false
                tomatoInfoIsClicked = false
            }else{
                lbTomatoInfo.isHidden = true
                tomatoInfoIsClicked = true
            }
        }else if sender.tag == 2 {
            if restInfoIsClicked{
                lbRestInfo.isHidden = false
                restInfoIsClicked = false
            }else {
                lbRestInfo.isHidden = true
                restInfoIsClicked = true
            }
//        }else if sender.tag == 3 {
//            if taskIntervalIsClicked{
//                lbTaskIntervalInfo.isHidden = false
//                taskIntervalIsClicked = false
//            }else{
//                lbTaskIntervalInfo.isHidden = true
//                taskIntervalIsClicked = true
//            }
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        _ = tapGestureRecognizer.view as! UIImageView
        let imagePicker = UIImagePickerController()
        // 設定影像來源 這裡設定為相簿
        imagePicker.sourceType = .photoLibrary
        // 設置 delegate
        imagePicker.delegate = self
        // 顯示相簿
        self.present(imagePicker, animated: true, completion: nil)
}
    
    
    var picker1:UIImagePickerController?
    var alert1:UIAlertController?
    
    
    //有幾個區塊
       public func numberOfComponents(in pickerView: UIPickerView) -> Int{
           return 1
       }
       //裡面有幾列
       public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
           return numbers.count
       }
       //選擇到的那列要做的事
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(pickerView == tfTomatoTime.inputView){
           tfTomatoTime.text = String(numbers[row])
           tomatoTime = numbers[row]
        }else if (pickerView == tfRestTime.inputView){
            tfRestTime.text = String(numbers[row])
            restTime = numbers[row]
//        }else if (pickerView == tfTaskInterval.inputView){
//            tfTaskInterval.text = String(numbers[row])
            taskInterval = numbers[row]
        }
       }
    
       //設定每列PickerView要顯示的內容
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           return String(numbers[row])
       }
    
    
    @IBAction func cancelBack(_ sender: UIButton) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "tabBarController") {
        self.navigationController?.pushViewController(controller, animated: true)
            }
        showTabBar()
        hideNavigation()
    }

    func dataToView(){
        tfTomatoTime.text = "\(sTomatoTime)"
        tfRestTime.text = "\(sRestTime)"
        swRing.isOn = sIsRinging
        swVibrate.isOn = sIsVibrating
    }
    func viewtoData(){
        let tomatoTimeString = tfTomatoTime.text
        let restTimeString = tfRestTime.text
        sTomatoTime = Int(tomatoTimeString!)!
        sRestTime = Int(restTimeString!)!
        print("tomatoTime: \(sTomatoTime)")
        print("restTime: \(sRestTime)")
        sIsRinging = swRing.isOn
        sIsVibrating = swVibrate.isOn
    }
    
  func loadSettingApi(){
    NetWorkController.sharedInstance.connectApiByGet(api: "/v1/setting",   header : ["Authorization" : "Bearer \(token)"]){(jsonData) in
            let resultData = jsonData.dictionary!
                if resultData["message"]?.string == "success"{
                    for set in (resultData["setting"]?.array)!{
                        settingId = set["id"].stringValue
                        sTomatoTime = set["minute"].intValue
                        sRestTime = set["short"].intValue
                        sIsRinging = set["ring"].boolValue
                        sIsVibrating = set["vibration"].boolValue
                        imgPath = set["path"].stringValue
                        self.dataToView()
                    }
                    print("getSetting success")
            }else{
                print("getSetting wrong")
            }
        }
    }
      
    func editSettingApi(){
        NetWorkController.sharedInstance.connectApiByPatch(api: "/v1/setting/\(settingId)", params: ["minute": tfTomatoTime.text, "short": tfRestTime.text, "ring": swRing.isOn, "vibration": swVibrate.isOn, "path": imgPath], header : ["Authorization" : "Bearer \(token)"])
                {(jsonData) in
                    let resultData = jsonData.dictionary!
                    if resultData["message"]?.string == "success"{
                        print("setting edit success")
                    }else{
                        print("setting edit wrong")
                    }
            }
    }
    
    @IBAction func saveAndBack(_ sender: Any) {
        viewtoData()
        editSettingApi()
        batchReviseApi()
        
//        sTomatoTime = tomatoTime
//        sRestTime = restTime
//        sTaskInterval = taskInterval
//        sFightingMode = fightingMode
//        sIsVibrating = isVibrating
//        sIsRinging = isRinging
        
//        settingDefaults.set(tfTomatoTime.text, forKey: "tomatoTime")
//        settingDefaults.set(tfRestTime.text, forKey: "restTime")
//        settingDefaults.set(fightingMode, forKey:"autoNext")
//        settingDefaults.set(isVibrating, forKey: "vibrate")
//        settingDefaults.set(isRinging, forKey: "ring")
        
        
        if let controller = storyboard?.instantiateViewController(withIdentifier: "tabBarController") {
       self.navigationController?.pushViewController(controller, animated: true)
           }
        showTabBar()
        hideNavigation()
    }
    
    func hideNavigation(){
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    func showNavigation(){
           navigationController?.setNavigationBarHidden(false, animated: true)
       }
    
    func connectApi(){
        NetWorkController.sharedInstance.connectApiByGet(api: "/auth/logout", header : ["Authorization" : "Bearer \(token)"])
                {(jsonData) in
                let resultData = jsonData.dictionary!
                if resultData["message"]?.string == "success"{
                    print("logout success")
                    imgPath = "default"
                    self.logoutChangePage()
                }else{
                    print("logout fail")
                }
        }
    }
    
    func batchReviseApi(){
        NetWorkController.sharedInstance.connectApiByPost(api: "/v1/exam/1/tomato/reset_tomatoes_minute", params: ["today" : dateFormatString, "minute" : sTomatoTime ], header : ["Authorization" : "Bearer \(token)"])
                  {(jsonData) in
                  let resultData = jsonData.dictionary!
                  if resultData["message"]?.string == "success"{
                    print("tomatoTime: \(sTomatoTime)")
                    print("batch edit success")
                  }else{
                      print("batch edit fail")
                  }
          }
      }
    
    
    func logoutChangePage(){
        if let controller = storyboard?.instantiateViewController(withIdentifier: "loginPage") {
        self.navigationController?.pushViewController(controller, animated: true)
            }
        
    }
    
    @IBAction func logout(_ sender: UIButton) {
        connectApi()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//
//    func datePickerTapped() {
//        let currentDate = Date()
//        var dateComponents = DateComponents()
//        dateComponents.month = -3
//
////        let now = dateComponents.date
////        let threeMonthAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
////        datePicker.addTarget()
//        datePicker.show( "請選擇時間",
//                        doneButtonTitle: "完成",
//                        cancelButtonTitle: "取消",
////                        minuteInterval : 180,
//                        datePickerMode: .countDownTimer) { (time) in
//            if let dt = time {
//                let formatter = DateFormatter()
//                formatter.dateFormat = "HH:MM"
//                self.textField.text = formatter.string(from: dt)
//            }
//        }
//    }

    override func viewWillAppear(_ animated: Bool) {
              super.viewWillAppear(animated)
              hideTabBar()
        navigationController?.setNavigationBarHidden(true, animated: animated)
      }
    
    func showTabBar(){
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func hideTabBar(){
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func keyboardGone(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
             self.view.addGestureRecognizer(tap) // to Replace "TouchesBegan"
     }

     @objc func dismissKeyBoard() {
         self.view.endEditing(true)
     }
            
}


    
    

    
    
    
