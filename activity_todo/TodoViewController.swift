//
//  TodoViewController.swift
//  tomato
//
//  Created by cm0532_macAir on 2019/12/31.
//  Copyright © 2019 cm0532_macAir. All rights reserved.
//

import UIKit
import FSCalendar

class TodoViewController: UIViewController, UITableViewDataSource , UITableViewDelegate {
    @IBOutlet weak var dynamicTVHeight: NSLayoutConstraint!
    @IBOutlet var todoTableView: UITableView!
    @IBOutlet var lbTargetNum: UILabel!
    @IBOutlet var lbDoneNum: UILabel!
    @IBOutlet var lbTodoNum: UILabel!
    var todoTasks = [task]()
    var doneTasks = [task]()
    var taskId : String = ""
//    lazy var checkTodo = Array(repeating: false, count: todoTasks.count)
    lazy var checkDone = Array(repeating: false, count: doneTasks.count)
    @IBOutlet var tfAddTask: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.todoTableView.dataSource = self;
        self.todoTableView.delegate = self;
        let nib = UINib(nibName: "TodoTableViewCell", bundle: nil)
    //註冊，forCellReuseIdentifier是你的TableView裡面設定的Cell名稱
        todoTableView.register(nib, forCellReuseIdentifier: "todoCell")
        todoTableView.tableFooterView = UIView()
        numberChange()
        loadData()
//        keyboardGone()
    }

    func numberChange(){
        todoTableView.reloadData()
        lbTargetNum.text = String(todoTasks.count + doneTasks.count)
        lbDoneNum.text = String(doneTasks.count)
        lbTodoNum.text = String(todoTasks.count)
    }

    
    func addConnectApi() {
        NetWorkController.sharedInstance.connectApiByPost(api: "/v1/task", params: ["name": tfAddTask.text! , "result": false, "position" : todoTasks.count], header : ["Authorization" : "Bearer \(token)"])
                {(jsonData) in
                let resultData = jsonData.dictionary!
                let encoder = JSONEncoder()
                if resultData["message"]?.string == "success"{
                    let task = resultData["task"]?.dictionary

                     if let jsonData = try? encoder.encode(task!["id"]){
                        let idString = String(data:jsonData , encoding: .utf8)

                        print("add success")
                        self.taskId = idString!
                        self.todoTasks.append(self.createTask(self.tfAddTask.text!,idString!))
                        
                        self.tfAddTask.text = ""
                        self.numberChange()
                        self.todoTableView.reloadData()
                    }
                 }else{
                    print("add fail")
                }
        }
    }
    
    func loadData(){
        NetWorkController.sharedInstance.connectApiByGet(api: "/v1/task",   header : ["Authorization" : "Bearer \(token)"]){(jsonData) in
                let resultData = jsonData.dictionary!
                    if resultData["message"]?.string == "success"{
                       
                            print("not nul")
                            for task in (resultData["unfinished"]?.array)!{
                            self.todoTasks.append(self.createTask(task["name"].stringValue, task["id"].stringValue))
                                print(self.todoTasks)
                            }
                            for task in (resultData["finished"]?.array)!{
                            self.doneTasks.append(self.createTask(task["name"].stringValue, task["id"].stringValue))
                                print(self.doneTasks)
                            }
                            self.todoTableView.reloadData()
                            self.numberChange()
                            
                    print("get success")
                }else{
                    print("get wrong")
                }
        }
    }
    
    func isNsnullOrNil(object : AnyObject?) -> Bool
    {
        if (object is NSNull) || (object == nil){
            return true
        }else{
            return false
        }
    }
    
    func editConnectAi(_ id : String,_ name: String, _ result: Bool, _ position: Int){
        NetWorkController.sharedInstance.connectApiByPatch(api: "/v1/task/\(id)", params: ["name": name, "result": result, "position": position], header : ["Authorization" : "Bearer \(token)"])
            {(jsonData) in
                let resultData = jsonData.dictionary!
                if resultData["message"]?.string == "success"{
                    print("edit success")
                }else{
                    print("edit wrong")
//                        self.apiAlert()
                }
        }
    }
        
    func deleteConnectAi(_ id : String){
        NetWorkController.sharedInstance.connectApiByDelete(api: "/v1/task/\(id)", params: [:], header : ["Authorization" : "Bearer \(token)"])
            {(jsonData) in
                let resultData = jsonData.dictionary!
                if resultData["message"]?.string == "success"{
                    print("delete success")
                }else{
                    print("delete wrong")
                }
        }
    }
    
    func apiAlert(){
        let controller = UIAlertController(title: "登入失敗", message: "請重新檢查帳號密碼！", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
    
    
    func createTask(_ name : String, _ id : String)->task{
        var newTask = task(name, id)
//        print("createTaskId:\(id)")
//        print("creageTaskName:\(name)")
        return newTask
    }
    
    @IBAction func addTask(_ sender: UIButton) {
        if tfAddTask.text != ""{
           addConnectApi()
            
        }else{
            noTaskAlert()
        }
    }
    
    //決定有幾個區塊
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // 設置tableView每個Header的高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            if todoTasks.count == 0{
                return 0
            }else{
                return 30
            }
        }else{
            if doneTasks.count == 0{
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
//            if todoTasks.count == 0{
////                view.isHidden = true
//            }else{
                viewLabel.text = "未完成待辦事項"
//                view.isHidden = false
//           }
//          }else if section == 1{
//            if doneTasks.count == 0{
////                view.isHidden = true
            }else{
                viewLabel.text = "已完成待辦事項"
//                 view.isHidden = false
//            }
          }
          view.addSubview(viewLabel)
          tableView.addSubview(view)
          return view
      }
       // 根據各區去計算顯示列數
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           if section == 0{
               return todoTasks.count
           }
           return doneTasks.count
       }
      

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "todoCell"

        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! TodoTableViewCell

         if(indexPath.section == 0){
            cell.lbTodo.text = todoTasks[indexPath.row].name
            cell.btnEdit.isHidden = false
            cell.index = indexPath.row
            let cellId = todoTasks[indexPath.row].id
            cell.completionHandler = {(index, cellId) in
                self.editAlert(indexPath.row, self.todoTasks[indexPath.row].id)
            }
        }else if indexPath.section == 1{
            cell.lbTodo.text = doneTasks[indexPath.row].name
             cell.btnEdit.isHidden = true
        }

        //------------------
//        cell.layer.shadowColor = UIColor.groupTableViewBackground.cgColor
//        cell.layer.shadowOffset = CGSize(width: 2, height: 7)
//        cell.layer.shadowOpacity = 2
//        cell.layer.shadowRadius = 2
//        cell.layer.masksToBounds = false
            
        todoTableView.tableFooterView = UIView()
            
     return cell
            
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0){
            self.editConnectAi(todoTasks[indexPath.row].id, todoTasks[indexPath.row].name, true, indexPath.row)
            self.doneTasks.append(todoTasks[indexPath.row])
            self.todoTasks.remove(at: indexPath.row)
            print("todoTasksCount:\(todoTasks.count)")
            print("doneTasksCount:\(doneTasks.count)")
           //取消選取的列
        }else{
            self.editConnectAi(doneTasks[indexPath.row].id, doneTasks[indexPath.row].name, false, indexPath.row)
            self.todoTasks.append(doneTasks[indexPath.row])
            self.doneTasks.remove(at: indexPath.row)
            print("todoTasksCount:\(todoTasks.count)")
            print("doneTasksCoutn:\(doneTasks.count)")
//            self.checkDone.remove(at: indexPath.row)
            
        }
        numberChange()
        todoTableView.reloadData()
   }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    //左滑刪除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if indexPath.section == 0{
            deleteConnectAi(todoTasks[indexPath.row].id)
            todoTasks.remove(at: indexPath.row)
        }else{
            deleteConnectAi(doneTasks[indexPath.row].id)
            doneTasks.remove(at: indexPath.row)
        }
        todoTableView.deleteRows(at: [indexPath], with: .automatic)
        todoTableView.reloadData() // 更新tableView
        numberChange()
    }


   func noTaskAlert(){
       let controller = UIAlertController(title: "提醒", message: "請輸入待辦事項內容！", preferredStyle: .alert)

       let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
       }
       controller.addAction(okAction)
       present(controller, animated: true, completion: nil)
   }
        
    @IBAction func toSettingPage(_ sender: UIBarButtonItem) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "setting") {
        self.navigationController?.pushViewController(controller, animated: true)
          }
    }
    
    
    func editAlert(_ index : Int, _ id : String){
        let controller = UIAlertController(title: "修改", message: "請輸入修改代辦事項：", preferredStyle: .alert)
        controller.addTextField { (textField) in
            textField.text = "\(self.todoTasks[index].name)"
        }

        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            self.todoTasks[index].name = (controller.textFields?[0].text)!
            self.todoTableView.reloadData()
            print("editAlert的id:\(id)")
            self.editConnectAi(id, self.todoTasks[index].name, false, index)
            
        }
        controller.addAction(okAction)
        let cancelAction = UIAlertAction(title : "取消", style: .default){ (_) in
            
        }
        controller.addAction(cancelAction)
            present(controller, animated: true, completion: nil)
      }
    
    func changePage(_ pageId : String){
        if let controller = storyboard?.instantiateViewController(withIdentifier: "setting") {
          self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBegan")
        tfAddTask.resignFirstResponder()
//        self.view.endEditing(true)
    }
}

struct task {
    var name : String
    var id : String
    init(_ name : String, _ id : String){
        self.name = name
        self.id = id
    }
}




//    func keyboardGone(){
//      let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
//      self.view.addGestureRecognizer(tap)
//      tap.delegate = self
//   }
//
//       @objc func dismissKeyBoard() {
//           self.view.endEditing(true)
//       }


//extension TodoViewController : UIGestureRecognizerDelegate {
//
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        var view = touch.view
//        while view != nil {
//            if view is UICollectionView || view is UITableView {
//                return false
//            } else {
//                view = view!.superview
//            }
//        }
//        return true
//    }
//}



