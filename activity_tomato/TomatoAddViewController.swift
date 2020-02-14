//
//  TomatoAddViewController.swift
//  tomato
//
//  Created by cm0532_macAir on 2020/1/3.
//  Copyright © 2020 cm0532_macAir. All rights reserved.
//

import UIKit

class TomatoAddViewController: UIViewController,UIPickerViewDelegate, UIPopoverPresentationControllerDelegate, ModalDelegate,IconPopupDelegate{
   
    
    
    func changeIcon(value: String) {
        btnIcon.setImage(UIImage(named: value), for: .normal)
        btnIcon.setTitle(value, for: .normal)
//        btnIcon.setImage(value, for: .normal)
    }
    
//    func bringCycleData(value : String){
//        if value == ""{
//            btnFrequency.setTitle("無", for: .normal)
//        }else{
//            btnFrequency.setTitle("有", for: .normal)
//        }
//    }
    func changeValue(value: String) {
//         testValue = value
        btnColor.tintColor = UIColor(named:value)
        btnColor.setTitle(value, for: .normal)
    }
    
    
    var delegate: TomatoAddViewControllerDelegate?
    
    @IBOutlet var btnTomato1: UIButton!
    @IBOutlet var btnTomato2: UIButton!
    @IBOutlet var btnTomato3: UIButton!
    @IBOutlet var btnTomato4: UIButton!
    @IBOutlet var btnTomato5: UIButton!
    @IBOutlet var btnTomato6: UIButton!
    @IBOutlet var btnTomato7: UIButton!
    @IBOutlet var btnTomato8: UIButton!
    
    @IBOutlet var btnIcon: UIButton!
    
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var lbTaskTime: UILabel!
    
//    @IBOutlet var tfIcon: UITextField!
    
//    @IBOutlet var btnFrequency: UIButton!
    @IBOutlet var tfName: UITextField!
    
    @IBOutlet var btnColor: UIButton!
    var numbers = [Int]()
    var tomatoNum : Int = 0
    var newTomato : Tomato?
    var editTomato : Tomato = Tomato()
    var editIndex : Int?
//    var frequency : String = ""
    var testString : String = ""
    var nameText : String = ""
//    var frequencyOptions = ["僅一次", "工作日", "週末", "每天"]
    var editMode = false
    
    var testValue: String = ""
    
    func putNum(){
           for i in 1...8 {
              numbers.append(i)
           }
       }

    override func viewDidLoad() {
        super.viewDidLoad()
//        setPickerView()
        putNum()
        preEdit()
        keyboardGone()
    }
    
    
    @IBAction func chooseTomatoNum(_ sender: UIButton) {
        for n in 1...sender.tag{
            let foundView = view.viewWithTag(n)
            foundView?.tintColor = UIColor.red
        }
        
        if sender.tag != 8{
            for n in (sender.tag+1)...8{
                let foundView = view.viewWithTag(n)
                foundView?.tintColor = UIColor.lightGray
            }
        }
        tomatoNum = sender.tag
        lbTaskTime.text = timeString(sTomatoTime * sender.tag)
    }

    
    @IBAction func toColorPopup(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "colorPopup") as? ColorPopupViewController else{
           assertionFailure("[AssertionFailure] StoryBoard: pickerStoryboard can't find!! (ViewController)")
           return
        }
        controller.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        controller.delegate = self
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
    navigationController?.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func toIconPopup(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "iconPopup") as? IconPopupViewController else{
           assertionFailure("[AssertionFailure] StoryBoard: pickerStoryboard can't find!! (ViewController)")
           return
        }
        controller.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        controller.delegate = self
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
    navigationController?.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func toCyclePopup(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "cyclePopup") as? CyclePopupViewController else{
           assertionFailure("[AssertionFailure] StoryBoard: pickerStoryboard can't find!! (ViewController)")
           return
        }
        controller.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
//        controller.delegate = self
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .overCurrentContext
        navigationController?.present(controller, animated: true, completion: nil)
    }
    
    func preEdit(){
        if editMode {
            btnSave.setTitle("確定修改", for: .normal) 
            setDataToView()
        }else{
            return
        }
    }
    
    func  setTomatoNum(){
        
        if tomatoNum != 0{
            for n in 1...tomatoNum {
                let foundView = view.viewWithTag(n)
                foundView?.tintColor = UIColor.red
            }
        }
          if tomatoNum != 8{
            for n in (tomatoNum + 1)...8{
                  let foundView = view.viewWithTag(n)
                  foundView?.tintColor = UIColor.lightGray
              }
          }
    }
    
    func setDataToView(){
        self.tfName.text = editTomato.name
//        self.tfTomatoNum.text! = String (editTomato?.tomatoNum)
        tomatoNum = editTomato.tomatoNum
        setTomatoNum()
 
        self.lbTaskTime.text = timeString(sTomatoTime * tomatoNum)
        
//        self.btnFrequency.setTitle(editTomato.frequency, for: .normal)
        self.btnColor.tintColor = UIColor(named: editTomato.color)
        self.btnColor.setTitle(editTomato.color, for: .normal)
        self.btnIcon.setImage(UIImage(named: editTomato.icon), for: .normal)
    }
    
    func setViewToData(){
        editTomato.name = self.tfName.text!
        editTomato.tomatoNum = tomatoNum
//        editTomato.frequency = btnFrequency.currentTitle!
        editTomato.color =  self.btnColor.currentTitle!
        editTomato.icon = self.btnIcon.currentTitle!
    }
  
    func checkField()-> Bool{
        if (tfName.text == ""){
            alert("輸入不完整", "忘了輸入任務內容")
            return false
        }else if (tomatoNum == 0){
            alert("輸入不完整", "忘了輸入番茄數量")
            return false
        }
        return true
    }
    
    func createTomato(){
        newTomato = Tomato()
        newTomato!.name = tfName.text!
//        newTomato!.tomatoNum = Int(tfTomatoNum.text!)!
        newTomato!.tomatoNum = tomatoNum
//        newTomato!.frequency = btnFrequency.currentTitle!
        newTomato!.color = btnColor.currentTitle!
        newTomato!.icon = btnIcon.currentTitle!
//        newTomato!.icon = tfIcon.text!
        
//        (tfName.text!, Int(tfMin.text!)!, tfFrequency.text!, Int(tfColor.text!)!, Int(tfIcon.text!)!)
    }
    
    @IBAction func saveAndBack(_ sender: UIButton) {
        if !checkField(){
            return
        }
        if editMode{
           setViewToData()
            self.delegate?.tomatoEditResponse(editTomato, editIndex!) //把改過資料和arrayIndex傳回去
            self.navigationController?.popViewController(animated: true)
        }else{
            createTomato()
            self.delegate?.tomatoAddViewControllerResponse(newTomato!)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func timeString (_ min : Int) -> String{
        return (min < 60) ? "\(min)分鐘" :
        (min%60 == 0) ? "\(min/60)小時" : "\(min/60)小時\(min%60)分"
    }
    func alert(_ title: String, _ msg: String){
        let controller = UIAlertController(title: title, message: msg, preferredStyle: .alert)
               let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
               controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
    
    
    
    func keyboardGone(){
          let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
               self.view.addGestureRecognizer(tap) // to Replace "TouchesBegan"
       }

   @objc func dismissKeyBoard() {
           self.view.endEditing(true)
       }
    
}

protocol TomatoAddViewControllerDelegate
{
    func tomatoAddViewControllerResponse(_ parameter : Tomato )
    func tomatoEditResponse(_ parameter : Tomato, _ arrayIndex : Int)
}

struct Tomato{
    var name : String = ""
    var tomatoNum : Int = 0
//    var frequency : String = ""
    var color : String = "activity_default"
//    var icon : UIImage = UIImage(named : "icon_read")!
    var length : Int = 0
    var icon : String = "icon_read"
    var result : Int = 0
    var completed : Bool = false
    var onTime : Bool = false
    var delayed : Bool = false
    var giveup : Bool = false
    var tomatoId : String = ""
}






