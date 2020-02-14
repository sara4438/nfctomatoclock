//
//  ProfileViewController.swift
//  tomato
//
//  Created by cm0532_macAir on 2020/1/7.
//  Copyright © 2020 cm0532_macAir. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var userTypeOptions = ["國考", "高考", "普考", "寫論文", "研究所/ 博班", "學測", "指考"]
    var revisedExam : String = ""
    var revisedName : String = ""
    var revisedPassword : String = ""
    var revisedExamDate : String = ""
    let datePicker = UIDatePicker()
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var tfRevisedName: UITextField!
    @IBOutlet var tfRevisedPassword: UITextField!
    @IBOutlet var tfRevisedExam: UITextField!
    @IBOutlet var tfRevisedExamDate: UITextField!
    
    
    @IBAction func save(_ sender: UIButton) {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardGone()
        setPickerView()
        datePickerView()
        setProfilePhoto()
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

          tfRevisedExamDate.inputView = datePicker
       }
       
       @objc func datePickerChanged(datePicker:UIDatePicker) {
              // 設置要顯示在 textField 的日期時間格式
              let formatter = DateFormatter()
              formatter.dateFormat = "yyyy-MM-dd"

              // 更新 textField 的內容
              tfRevisedExamDate.text = formatter.string(from: datePicker.date)
              revisedExamDate = tfRevisedExamDate.text!
          }
    
    
    func setPickerView(){
        let userTypeView = UIPickerView()
        // 設定 UIPickerView 的 delegate 及 dataSource
        userTypeView.delegate = self
        userTypeView.dataSource = self
//        tfRevisedExam.inputView = userTypeView
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
         func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//             tfRevisedExam.text = String(userTypeOptions[row])
//             revisedExam = userTypeOptions[row]
          }
          
         //設定每列PickerView要顯示的內容
         func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
             return String(userTypeOptions[row])
         }
    //-----設定picker view 結束
    

    
    func setProfilePhoto(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
               
         profileImage.isUserInteractionEnabled = true
         profileImage.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        let imagePicker = UIImagePickerController()
        // 設定影像來源 這裡設定為相簿
        imagePicker.sourceType = .photoLibrary
        // 設置 delegate
        imagePicker.delegate = self
        // 顯示相簿
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func assignValue(){
//        revisedExam = tfRevisedExam.text!
        revisedName = tfRevisedName.text!
        revisedPassword = tfRevisedPassword.text!
        revisedExamDate = tfRevisedExamDate.text!
    }
    
        
        var picker1:UIImagePickerController?
        var alert1:UIAlertController?
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          ///關閉ImagePickerController
          picker.dismiss(animated: true, completion: nil)
          if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            ///取得使用者選擇的圖片
    //        btnPhoto.setImage(image,for:.normal)
            profileImage.image = image
            profileImage.layer.cornerRadius = 40
          }
        }
    
    func keyboardGone(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
             self.view.addGestureRecognizer(tap) // to Replace "TouchesBegan"
     }

     @objc func dismissKeyBoard() {
         self.view.endEditing(true)
     }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
