//
//  AlarmAddViewController.swift
//  tomato
//
//  Created by cm0532_macAir on 2020/1/14.
//  Copyright © 2020 cm0532_macAir. All rights reserved.
//

import UIKit

class AlarmAddViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var tfName: UITextField!
    @IBOutlet var tfCycle: UITextField!
    @IBOutlet var tfType: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    var typeOptions = ["起床鬧鐘", "一般鬧鐘"]
    var newAlarm : Alarm!
    var delegate: AlarmAddViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerSetting()
        pickerViewSetting()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            tfType.text = typeOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
             return typeOptions[row]
    }
      
    

    
    func pickerViewSetting(){
          let typePickerView = UIPickerView()
          // 設定 UIPickerView 的 delegate 及 dataSource
          typePickerView.delegate = self
          typePickerView.dataSource = self
          
          // 將 UITextField 原先鍵盤的視圖更換成 UIPickerView
          tfType.inputView = typePickerView
    }
    
    func datePickerSetting(){
        //設置datePicker格式
        datePicker.datePickerMode = .time
        
        //選取時間 -> 以15分鐘為一個間隔
        datePicker.minuteInterval = 15
        
        //設定預設顯示時間 -> 為現在時間
        datePicker.date = NSDate() as Date
        
        //設置NSDate的格式
        let formatter = DateFormatter()
        
        //設置顯示個格式
        formatter.dateFormat = "HH:mm"
        
//        //可以選擇的最早日期時間
//        datePicker.minimumDate = formatter.date(from: "2016-01-02 18:08")
//        //可以選擇的最晚日期時間
//        datePicker.maximumDate = formatter.date(from: "2020-01-03 18:08")
        //picker預設英文，改為顯示中文
        datePicker.locale = Locale(identifier: "zh_CN")
        //設置改變日期時間時會執行動作的方法
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)

//        tfDepartTime.inputView = datePicker
    }
    
    @objc func datePickerChanged(datePicker:UIDatePicker) {
        // 設置要顯示在 textField 的日期時間格式
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        // 更新 textField 的內容
//        tfDepartTime.text = formatter.string(from: datePicker.date)
    }
    @IBAction func saveBack(_ sender: UIButton) {
        createAlarm()
      self.delegate?.alarmAddViewControllerResponse(newAlarm!)
      self.navigationController?.popViewController(animated: true)
    }
    
    func createAlarm(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:MM"
        let time = dateFormatter.string(from:datePicker.date)
        
        newAlarm = Alarm()
        newAlarm.name = tfName.text
        newAlarm.cycle = tfCycle.text
        newAlarm.time = time
        newAlarm.type = tfType.text
    }
    
//    
    func timeString (_ min : Int) -> String{
        return (min < 60) ? "\(min)分鐘" :
        (min%60 == 0) ? "\(min/60)小時" : "\(min/60)小時\(min%60)分"
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//            print("touchesBegan")
//            tfAddTask.resignFirstResponder()
        self.view.endEditing(true)
    }
    

}
protocol AlarmAddViewControllerDelegate
{
    func alarmAddViewControllerResponse(_ parameter : Alarm )
    func alarmEditResponse(_ parameter : Alarm, _ arrayIndex : Int)
}
