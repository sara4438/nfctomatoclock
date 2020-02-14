//
//  CalendarViewController.swift
//  tomato
//
//  Created by cm0532_macAir on 2020/1/8.
//  Copyright © 2020 cm0532_macAir. All rights reserved.
//

import UIKit
import FSCalendar
class CalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate{

    


    @IBOutlet var tableView: UITableView!
    @IBOutlet var calendar: FSCalendar!
    var todoArray = [String]()
    var tomatoArray = [Tomato]()
    
        fileprivate lazy var dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            return formatter
        }()
        
        
        fileprivate let formatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd"
            return formatter
        }()
        
        fileprivate let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
        
        fileprivate let datesWithTomato = ["2020/01/01","2020/01/05","2020/01/10","2020/02/05"]
        
    //    fileprivate weak var calendar: FSCalendar!

        override func viewDidLoad() {
            super.viewDidLoad()
    //        createCalendar()
            createCalendar2()
        }
        deinit {
               print("\(#function)")
           }
        
        func createCalendar2(){
    //        let calendar = FSCalendar()
            calendar.dataSource = self
            calendar.delegate = self
            view.addSubview(calendar)
            self.calendar.select(self.formatter.date(from: "2020/01/01")!)
    //        self.view.addGestureRecognizer(self.scopeGesture)
    //        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
    //        self.calendar.scope = .week
           
            
           // For UITest
           self.calendar.accessibilityIdentifier = "calendar"
        }
        
        func createCalendar(){
            let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 320, height: 300))
            calendar.dataSource = self
            calendar.delegate = self
            view.addSubview(calendar)
            
            calendar.translatesAutoresizingMaskIntoConstraints = false
            
            calendar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            calendar.topAnchor.constraint(equalTo: view.topAnchor, constant: 230).isActive = true
            calendar.widthAnchor.constraint(equalToConstant: 320).isActive = true
             calendar.heightAnchor.constraint(equalToConstant: 300).isActive = true
       
        }
    
        //觸發新增事件鈕
        var eventDate : String = ""
        var event : String = ""
        lazy var eventDic : Dictionary = [eventDate : event]
        @IBAction func addNewTask(_ sender: UIButton) {
            let controller = UIAlertController(title: "新增待辦事項", message: "請輸入代辦事項敘述：", preferredStyle: .alert)
            controller.addTextField { (textField) in
                
    //           textField.keyboardType = UIKeyboardType.phonePad
            }
          
            let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
                self.event = (controller.textFields?[0].text)!
                
            }
            controller.addAction(okAction)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            controller.addAction(cancelAction)
            present(controller, animated: true, completion: nil)
        }
        
        

         // MARK:- FSCalendarDataSource
         
         func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
             return self.gregorian.isDateInToday(date) ? "今天" : nil
         }
         
    //
    //     func maximumDate(for calendar: FSCalendar) -> Date {
    //         return self.formatter.date(from: "2017/10/30")!
    //     }
    //
         func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
             let day: Int! = self.gregorian.component(.day, from: date)
             return day % 5 == 0 ? day/5 : 0;
         }
         
         func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
    //         let day: Int! = self.gregorian.component(.day, from: date)
            let dateStr : String! = self.dateFormatter.string(from: date)
             return datesWithTomato.contains(dateStr) ? UIImage(named: "tab bar_tomato") : nil
         }
         // MARK:- FSCalendarDelegate

         func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
             print("change page to \(self.formatter.string(from: calendar.currentPage))")
         }
         
         func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            self.eventDate = self.formatter.string(from: date)
             print("calendar did select date \(self.formatter.string(from: date))")
             
             
             if monthPosition == .previous || monthPosition == .next {
                 calendar.setCurrentPage(date, animated: true)
             }
         }
         
    //     func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
    //         self.calendarHeightConstraint.constant = bounds.height
    //         self.view.layoutIfNeeded()
    //     }
         
        
    // MARK:- UITableViewDataSource
      
      func numberOfSections(in tableView: UITableView) -> Int {
          return 2
      }
//
//      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//          return [2,20][section]
//      }
//
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          if indexPath.section == 0 {
              let identifier = ["cell_month", "cell_week"][indexPath.row]
              let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
              return cell
          } else {
              let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
              return cell
          }
      }
//

        // 設置tableView每個Header的高度
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 0
        }

        //計算顯示列數
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return todoArray.count + tomatoArray.count
        }
               
//        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        //取得myTableView的cell，名稱是myTableView輸入的Cell Identifier
//
//            let cellIdentifier = "calendarCell"
//            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! CalendarTableViewCell
//
//             if(indexPath.section == 0){
//                cell.lbName.text = todoArray[indexPath.row]
//                cell.icon.image = (UIImage(named: "tab bar_tomato")
//
//            }else if indexPath.section == 1{
//                cell.lbName.text = todoArray[indexPath.row]
//:"activity_coding")!
//                cell.btnEdit.isHidden = true
//            }
//                activityTableView.tableFooterView = UIView()
//                return cell
//        }
         
    //        cell.layer.shadowColor = UIColor.groupTableViewBackground.cgColor
    //         cell.layer.shadowOffset = CGSize(width: 2, height: 7)
    //         cell.layer.shadowOpacity = 2
    //         cell.layer.shadowRadius = 2
    //         cell.layer.masksToBounds = true
    //        activityTableView.reloadData()
            

//        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            if indexPath.section == 0{
//                changeToTimer(indexPath.row)
//                tableView.deselectRow(at: indexPath, animated: false)
//            }else{
//                tableView.deselectRow(at: indexPath, animated: false)
//            }
//        }
//
//        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
//            if indexPath.section == 0{
//                todoTomatos.remove(at: indexPath.row)
//            }else{
//                doneTomatos.remove(at: indexPath.row)
//            }
//            activityTableView.deleteRows(at: [indexPath], with: .automatic)
//            activityTableView.reloadData() // 更新tableView
//            numberChange()
//
//
//
          
          // MARK:- UITableViewDelegate
          
          func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
              tableView.deselectRow(at: indexPath, animated: true)
              if indexPath.section == 0 {
                  let scope: FSCalendarScope = (indexPath.row == 0) ? .month : .week
    //              self.calendar.setScope(scope, animated: self.animationSwitch.isOn)
              }
          }
          
//    private func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//              return 10
//          }

        
    }

