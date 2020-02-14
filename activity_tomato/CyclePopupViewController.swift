//
//  CyclePopupViewController.swift
//  tomato
//
//  Created by cm0532_macAir on 2020/1/17.
//  Copyright © 2020 cm0532_macAir. All rights reserved.
//

import UIKit

class CyclePopupViewController: UIViewController, UITableViewDataSource , UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    
    var delegate : CycleDelegate?
    var weekArray = ["星期日","星期一", "星期二","星期三","星期四","星期五","星期六"]
    var checkArray = [Bool]()
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 0...6{
            checkArray.append(false)
        }
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        let nib = UINib(nibName: "WeekTableViewCell", bundle: nil)
              tableView.register(nib, forCellReuseIdentifier: "weekCell")
    }
    
    
     //計算顯示列數
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                return weekArray.count
        }
               
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //取得myTableView的cell，名稱是myTableView輸入的Cell Identifier
            
            let cellIdentifier = "weekCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath as IndexPath) as! WeekTableViewCell

            cell.lbWeek.text = weekArray[indexPath.row]
            cell.setSelected(checkArray[indexPath.row], animated: false)
//          print("cell:\(cell.lbWeek.text)")
                tableView.tableFooterView = UIView()
                return cell
        }
         

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let cell = tableView.cellForRow(at: indexPath)
            if !checkArray[indexPath.row]{
                cell?.accessoryType = .checkmark
                checkArray[indexPath.row] = true
                print("ifCheckArray:\(indexPath.row)")
            }else{
                tableView.deselectRow(at: indexPath, animated: false)
                cell?.accessoryType = .none
                checkArray[indexPath.row] = false
                print("elseCheckArray:\(indexPath.row)")
            }
            
        }
    
    @IBAction func save(_ sender: UIButton) {
        var checked = [Int]()
        var chosenString = [String]()
        for (index, value) in checkArray.enumerated(){
            if value {
                checked.append(index)
                print("save:\(index)")
            }
        }
        for n in checked {
            chosenString.append(weekArray[n])
        }
        dismissWithData(frequencyToString(chosenString))
    }
    
    func frequencyToString(_ datas : [String]) -> String{
        var dataString : String = ""
        for data in datas{
           if dataString == ""{
               dataString = dataString + data
           }
           dataString = dataString + "," + data
       }
        print("dataString:\(dataString)")
        return dataString
    }
    
    
    func dismissWithData(_ data : String ) {
        if let delegate = self.delegate {
            delegate.bringCycleData(value: data)
        }
   
        dismiss(animated: true, completion: nil)
    }
        
    
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

}
protocol CycleDelegate {
    func bringCycleData(value: String)
}

