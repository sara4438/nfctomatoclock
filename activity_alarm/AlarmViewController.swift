//
//  AlarmViewController.swift
//  tomato
//
//  Created by cm0532_macAir on 2019/12/31.
//  Copyright © 2019 cm0532_macAir. All rights reserved.
//

import UIKit

class AlarmViewController: UIViewController,AlarmAddViewControllerDelegate,UITableViewDataSource , UITableViewDelegate {
    func alarmAddViewControllerResponse(_ newAlarm: Alarm) {
        if newAlarm.type == "起床鬧鐘"{
            getupAlarms.append(newAlarm)
        }else{
            normalAlarms.append(newAlarm)
        }
        tableView.reloadData()
        numberChange()
    }
    
    func alarmEditResponse(_ parameter: Alarm, _ arrayIndex: Int) {
        
    }
    
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var lbLazyCount: UILabel!
    @IBOutlet var lbGetupTime: UILabel!
    var newAlarm : Alarm?
    var getupAlarms = [Alarm]()
    var normalAlarms = [Alarm]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        getupAlarms.append(testAlarm())
        
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        let nib = UINib(nibName: "AlarmTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "alarmCell")
        tableView.tableFooterView = UIView()
        
    }
    
    func testAlarm()->Alarm{
        var alarm = Alarm()
        alarm.name = "起床"
        alarm.type = "起床鬧鐘"
        alarm.cycle = "週一"
        alarm.time = "08:00"
        return alarm
    }
    
    func numberChange(){
        lbGetupTime.text = newAlarm?.time
    }
    
    @IBAction func addAlarm2(_ sender: UIButton) {
        toAddPage()
    }
    @IBAction func addAlarm(_ sender: UITextField) {
        toAddPage()
    }
    func toAddPage(){
        if let controller = storyboard?.instantiateViewController(withIdentifier: "addAlarmPage") {
    self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    //決定有幾個區塊
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    // 設置tableView每個Header的高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            if getupAlarms.count == 0{
                return 0
            }else{
                return 30
            }
        }else{
            if normalAlarms.count == 0{
                return 0
            }else{
                return 30
            }
        }
    }
        
        // 設置tableView每個Header的內容
      func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
          let view = UIView()
//          view.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.0)
          let viewLabel = UILabel(frame: CGRect(x: 10, y: 0, width: UIScreen.main.bounds.size.width, height: 30))
          viewLabel.textColor = UIColor(red:0.31, green:0.31, blue:0.31, alpha:1.0)
          
          if section == 0{
                viewLabel.text = "起床鬧鐘"
          }else{
                viewLabel.text = "一般鬧鐘"
          }
          view.addSubview(viewLabel)
          tableView.addSubview(view)
          return view
      }

        //計算顯示列數
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if section == 0{
                return getupAlarms.count
            }
                return normalAlarms.count
        }
               
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //取得myTableView的cell，名稱是myTableView輸入的Cell Identifier

            let cellIdentifier = "alarmCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! AlarmTableViewCell

             if(indexPath.section == 0){
                cell.lbName.text = getupAlarms[indexPath.row].name
                cell.lbTime.text = getupAlarms[indexPath.row].time
            cell.lbCycle.text = getupAlarms[indexPath.row].cycle

            }else if indexPath.section == 1{
                 cell.lbName.text = normalAlarms[indexPath.row].name
                 cell.lbTime.text = normalAlarms[indexPath.row].time
                 cell.lbCycle.text = normalAlarms[indexPath.row].cycle
            }
                tableView.tableFooterView = UIView()
                return cell
        }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            if indexPath.section == 0{
////                changeToTimer(indexPath.row)
//                tableView.deselectRow(at: indexPath, animated: false)
//            }else{
//                tableView.deselectRow(at: indexPath, animated: false)
//            }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if indexPath.section == 0{
             getupAlarms.remove(at: indexPath.row)
        }else{
            normalAlarms.remove(at: indexPath.row)
        }
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData() // 更新tableView
//        numberChange()
    }
    
    @IBAction func toSettingPage(_ sender: Any) {
        if let controller = storyboard?.instantiateViewController(withIdentifier: "setting") {
            self.navigationController?.pushViewController(controller, animated: true)
            }
    }
}

struct Alarm {
    var name : String?
    var time : String?
    var cycle : String?
    var type : String?
}
