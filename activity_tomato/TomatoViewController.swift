//
//  TomatoViewController.swift
//  tomato
//
//  Created by cm0532_macAir on 2019/12/31.
//  Copyright © 2019 cm0532_macAir. All rights reserved.
//

import UIKit

class TomatoViewController: UIViewController, UITableViewDataSource , UITableViewDelegate, TomatoAddViewControllerDelegate, TimerViewControllerDelegate{
    
    func timerViewControllerResponse(_ index : Int, _ parameter: Tomato) {
        returnTomato = parameter
        if returnTomato!.completed {
            returnTomato!.length = parameter.tomatoNum * sTomatoTime
            doneTomatos.append(returnTomato!)
            todoTomatos.remove(at: index)
            editConnectAi(parameter.tomatoId, parameter.name, parameter.result, index, parameter.color, parameter.icon, parameter.tomatoNum * sTomatoTime)
            print("sTomatoTime:\(sTomatoTime)")
            print("parameter.tomatoNum:\(parameter.tomatoNum)")
            if returnTomato!.onTime{
                onTimeCount += 1
            }
        }else if (returnTomato!.giveup){
            giveupCount += 1
        }
        activityTableView.reloadData()
        numberChange()
        
//        print("todoTomatos:\(todoTomatos.count)")
//        print("doneTomatos:\(doneTomatos.count)")
    }
    
    func tomatoEditResponse(_ parameter: Tomato, _ arrayIndex : Int) {
        todoTomatos[arrayIndex] = parameter
        editConnectAi(parameter.tomatoId, parameter.name, parameter.result, arrayIndex, parameter.color, parameter.icon, parameter.tomatoNum * sTomatoTime)
        activityTableView.reloadData()
    }
    
    func tomatoAddViewControllerResponse(_ parameter : Tomato) {
        returnTomato = parameter
        addConnectApi(returnTomato!)
    }
    //回傳回來start
    var returnTomato : Tomato?
    var activityIsDone : Bool = false
    var newTomato : Tomato? = nil
    var onTimeCount : Int = 0
    var giveupCount : Int = 0
    //回傳回來end
    @IBOutlet var addTomato: UITextField!
    @IBOutlet var activityTableView: UITableView!
    @IBOutlet var lbOnTimeNum: UILabel!
    @IBOutlet var lbDelayedNum: UILabel!
    @IBOutlet var lbTodoNum: UILabel!
    
    @IBOutlet var lbTotalNum: UILabel!
    var todoTomatos = [Tomato] ()
    var doneTomatos = [Tomato] ()
//    var cellData = [(String , Int, UIImage)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        nagigationSettings()
     //註冊，forCellReuseIdentifier是你的TableView裡面設定的Cell名稱
        //測資
//       todoTomatos.append(createTestdata("讀書", 2)) // 數字是番茄數量
//       todoTomatos.append(createTestdata("準備專題" , 8))
//       todoTomatos.append(createTestdata("建資料庫" , 1))
        self.activityTableView.dataSource = self;
        self.activityTableView.delegate = self;
        let nib = UINib(nibName: "TomatoTableViewCell", bundle: nil)
        activityTableView.register(nib, forCellReuseIdentifier: "datacell")
        activityTableView.tableFooterView = UIView()
//        loadDefaultData()
        loadData()
        numberChange()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        loadData()
        activityTableView.reloadData()
    }

    func loadData(){
        NetWorkController.sharedInstance.connectApiByGet(api: "/v1/exam/1/tomato",   header : ["Authorization" : "Bearer \(token)"]){(jsonData) in
                let resultData = jsonData.dictionary!
                    if resultData["message"]?.string == "success"{
                        for tomato in (resultData["unfinished"]?.array)!{
//                            if tomato["result"].int == 0{
                            self.todoTomatos.append(self.createTomato(tomato["name"].stringValue, tomato["length"].int!, tomato["color"].stringValue, tomato["icon"].stringValue, tomato["id"].stringValue, tomato["result"].int!,
//                                tomato["minute"].intValue,
                            tomato["pcs"].intValue))
                            print(self.todoTomatos)
                            }
                for tomato in (resultData["finished"]?.array)!{ self.doneTomatos.append(self.createTomato(tomato["name"].stringValue, tomato["length"].int!,         tomato["color"].stringValue,        tomato["icon"].stringValue, tomato["id"].stringValue, tomato["result"].intValue,                      tomato["pcs"].intValue))
                }
                self.activityTableView.reloadData()
                self.numberChange()
                print("get success")
                }else{
                    print("get wrong")
                }
        }
    }
    
    func addConnectApi( _ parmTomato : Tomato) {
        NetWorkController.sharedInstance.connectApiByPost(api: "/v1/exam/1/tomato", params: ["name": parmTomato.name, "icon" : "\(parmTomato.icon)","color": "\(parmTomato.color)", "length": parmTomato.tomatoNum * sTomatoTime, "result": "\(0)","minute": sTomatoTime,"pcs": "\(parmTomato.tomatoNum)", "position" : todoTomatos.count], header : ["Authorization" : "Bearer \(token)"])
               {(jsonData) in
               let resultData = jsonData.dictionary!
               let encoder = JSONEncoder()
               if resultData["message"]?.string == "success"{
                   let tomato = resultData["tomato"]?.dictionary

                    if let jsonData = try? encoder.encode(tomato!["id"]){
                       let idString = String(data:jsonData , encoding: .utf8)
                        self.returnTomato!.tomatoId = idString!
                        self.todoTomatos.append(self.returnTomato!)
                        self.activityTableView.reloadData()
                        self.numberChange()
                       print("addTomato success")
                   }
                }else{
                   print("addTomato fail")
               }
           }
       }
    
    func editConnectAi(_ id : String,_ name: String, _ result: Int, _ position: Int, _ color: String, _ icon : String, _ length: Int){
        NetWorkController.sharedInstance.connectApiByPatch(api: "/v1/exam/1/tomato/\(id)", params: ["name": name, "result": result, "position": position, "icon": "\(icon)", "color": "\(color)", "length": length], header : ["Authorization" : "Bearer \(token)"])
                {(jsonData) in
                    let resultData = jsonData.dictionary!
                    if resultData["message"]?.string == "success"{
                        print("tomato edit success")
                    }else{
                        print("tomato edit wrong")
                    }
            }
    }
    
    func deleteConnectAi(_ id : String){
        NetWorkController.sharedInstance.connectApiByDelete(api: "/v1/exam/1/tomato/\(id)", params: [:], header : ["Authorization" : "Bearer \(token)"])
            {(jsonData) in
                let resultData = jsonData.dictionary!
                if resultData["message"]?.string == "success"{
                    print("delete tomato success")
                }else{
                    print("delete tomato fail")
                }
        }
    }


    
//    @IBAction func test(_ sender: UIButton) {
////         tomatoAddViewControllerResponse()
//        //測資
//        todoTomatos.append(createTestdata("讀書", 2)) // 數字是番茄數量
//        todoTomatos.append(createTestdata("準備專題" , 8))
//        todoTomatos.append(createTestdata("建資料庫" , 1))
//        activityTableView.reloadData()
//        numberChange()
//    }
    
    func createTomato(_ name : String, _ length : Int, _ color : String,_ icon : String,_ tomatoId : String,_ result : Int, _ tomatoNum: Int) ->Tomato{
        var testTomato = Tomato()
        testTomato.name = name
        testTomato.tomatoNum = tomatoNum
        testTomato.length = length
        testTomato.color = color
        testTomato.icon = icon
        testTomato.result = result
        testTomato.tomatoId = tomatoId
        return testTomato
    }
    
    
    //決定有幾個區塊
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // 設置tableView每個Header的高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            if todoTomatos.count == 0{
                return 0
            }else{
                return 30
            }
        }else{
            if doneTomatos.count == 0{
                return 0
            }else{
                return 30
            }
        }
    }
        
        // 設置tableView每個Header的內容
      func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
          let view = UIView()
          view.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0)
          let viewLabel = UILabel(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width, height: 30))
          viewLabel.textColor = UIColor(red:0.31, green:0.31, blue:0.31, alpha:1.0)
          
          if section == 0{
                viewLabel.text = "未完成番茄"
          }else{
                viewLabel.text = "已完成番茄"
          }
          view.addSubview(viewLabel)
          tableView.addSubview(view)
          return view
      }

    //計算顯示列數
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return todoTomatos.count
        }
            return doneTomatos.count
    }
           
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //取得myTableView的cell，名稱是myTableView輸入的Cell Identifier
        
        let cellIdentifier = "datacell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! TomatoTableViewCell

         if(indexPath.section == 0){
            cell.lbActivity.text = todoTomatos[indexPath.row].name
            cell.lbTime.text = timeString((todoTomatos[indexPath.row].tomatoNum) * sTomatoTime)
            cell.myImageView.image = UIImage(named: todoTomatos[indexPath.row].icon)
            cell.backgroundColor = UIColor(named: todoTomatos[indexPath.row].color)
//            cell.btnEdit.setImage(UIImage(named : " tableView_pencil"), for: .normal)
            cell.index = indexPath.row
            cell.btnEdit.isHidden = false
            cell.completionHandler = {(index) in
            self.changeToEdit(self.todoTomatos[indexPath.row], indexPath.row)
            }
        }else if indexPath.section == 1{
            cell.lbActivity.text = doneTomatos[indexPath.row].name
            cell.lbTime.text =  timeString(doneTomatos[indexPath.row].length)
            cell.myImageView.image = UIImage(named: doneTomatos[indexPath.row].icon)
            cell.backgroundColor = UIColor(named: doneTomatos[indexPath.row].color)
            cell.btnEdit.isHidden = true
        }
            activityTableView.tableFooterView = UIView()
            return cell
    }
     
//        cell.layer.shadowColor = UIColor.groupTableViewBackground.cgColor
//         cell.layer.shadowOffset = CGSize(width: 2, height: 7)
//         cell.layer.shadowOpacity = 2
//         cell.layer.shadowRadius = 2
//         cell.layer.masksToBounds = true
//        activityTableView.reloadData()
        
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            changeToTimer(indexPath.row)
            tableView.deselectRow(at: indexPath, animated: false)
        }else{
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    //左滑刪除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if indexPath.section == 0{
           deleteConnectAi(todoTomatos[indexPath.row].tomatoId)
           todoTomatos.remove(at: indexPath.row)
        }else{
           deleteConnectAi(doneTomatos[indexPath.row].tomatoId)
           doneTomatos.remove(at: indexPath.row)
        }
        activityTableView.deleteRows(at: [indexPath], with: .automatic)
        activityTableView.reloadData() // 更新tableView
        numberChange()
    }
    
    @IBAction func inputTomato(_ sender: UITextField) {
        changeToAdd()
    }
    
    @IBAction func toAddPage(_ sender: UIButton) {
        changeToAdd()
    }
    
    @IBAction func changToChart(_ sender: UIBarButtonItem) {
        if let url = URL(string: "http://34.85.51.56/charts/\(userId)")
        {
            if #available(iOS 10.0, *)
            {
                UIApplication.shared.open(url, options: [:])
            }
            else
            {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func toSettingPage(_ sender: UIBarButtonItem) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "setting") {
        self.navigationController?.pushViewController(controller, animated: true)
          }
    }

    func changeToTimer(_ index :Int){
        let controller = storyboard?.instantiateViewController(withIdentifier: "timerPage") as! TimeViewController
        controller.tomato =  todoTomatos[index]
        controller.arrayIndex = index
        controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func changeToEdit(_ tomato : Tomato, _ arrayIndex : Int){
        let controller = storyboard?.instantiateViewController(withIdentifier: "tomatoAddPage") as! TomatoAddViewController
            controller.delegate = self
        controller.editTomato = tomato
        controller.editIndex = arrayIndex
        controller.editMode = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func changeToAdd(){
        let controller = storyboard?.instantiateViewController(withIdentifier: "tomatoAddPage") as! TomatoAddViewController
            controller.delegate = self
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func numberChange(){
        lbTodoNum.text = String(todoTomatos.count)
        lbOnTimeNum.text = String(onTimeCount)
        lbDelayedNum.text = String(doneTomatos.count - onTimeCount)
        lbTotalNum.text = String(todoTomatos.count+doneTomatos.count)
    }
    
   func timeString (_ min : Int) -> String{
       return (min < 60) ? "\(min)分鐘" :
       (min%60 == 0) ? "\(min/60)小時" : "\(min/60)小時\(min%60)分"
   }
    
    func keyboardGone(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
             self.view.addGestureRecognizer(tap) // to Replace "TouchesBegan"
     }

     @objc func dismissKeyBoard() {
         self.view.endEditing(true)
     }

}


//    func nagigationSettings(){
//        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
//        //set image for button
//        button.setImage(UIImage(named: "setting"), for: .normal)
//        //add function for button
//        button.addTarget(self, action: Selector("settingButtonPressed"), for: .touchUpInside)
//
//        //set frame
//        button.frame = CGRect(x: 0, y: 0, width: 53, height: 31)
//
//        let barButton = UIBarButtonItem(customView: button)
//        //assign button to navigationbar
//        self.navigationItem.rightBarButtonItem = barButton
//    }

    
    //tableView適應cell內容高度
//    override func viewDidLayouts(){Subview
//         activityTableView.frame = CGRect(x: activityTableView.frame.origin.x, y: activityTableView.frame.origin.y, width: activityTableView.frame.size.width, height: activityTableView.contentSize.height)
//         activityTableView.reloadData()
//    }

    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
