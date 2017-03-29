//
//  AnalysisViewController.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 16/5/14.
//  Copyright © 2016年 McKay. All rights reserved.
//

import UIKit
import RealmSwift
import CoreMotion
import Charts


class AnalysisViewController: UITableViewController {
    var curentUser:Person?
    var result : [Double] = []
    var days:[String] = []
    let activityManager = CMMotionActivityManager()
    let pedoMeter = CMPedometer()
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if isNonData() {
            return 1
        } else {
            return 2
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section == 0 {
            return 223
        } else {
            return 305
        }
    }
    fileprivate func isNonData() -> Bool {
        if curentUser?.getPercentageOfWorkout("0").isNaN == true &&
            curentUser?.getPercentageOfWorkout("1").isNaN == true &&
            curentUser?.getPercentageOfWorkout("2").isNaN == true {
            return true
        } else {
            return false
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var startIndexAt: Int = 0
        if isNonData() {
            startIndexAt = -1
        }
        if (indexPath as NSIndexPath).section == startIndexAt {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "graphicCell", for: indexPath) as? GraphViewCell else {
                return UITableViewCell()
            }
            let data = [curentUser?.getPercentageOfWorkout("0") ?? 0.0,
                        curentUser?.getPercentageOfWorkout("1") ?? 0.0,
                        curentUser?.getPercentageOfWorkout("2") ?? 0.0
            ]
            let label = ["Cardio","Weights","Hiit"]
            
            var dataEntries:[ChartDataEntry] = []
            
            for i in 0..<label.count {
                if data[i] != 0.0 {
                    let dataEntry = PieChartDataEntry(value: data[i], label: label[i])
                    dataEntries.append(dataEntry)
                } else {
                    dataEntries.append(PieChartDataEntry())
                }
            }
            let colors: [UIColor] = [GWMPieGraphColorCardio,
                                     GWMPieGraphColorWeights,
                                     GWMPieGraphColorHiit]
            let textColor: [UIColor] = [UIColor.white, UIColor.black,UIColor.white]
            cell.title.text = "Proportion of Workout"
            
            let dataSet = PieChartDataSet(values: dataEntries, label: "")
            dataSet.colors = colors
            
            dataSet.valueColors = textColor
            
            let pieChartDatas = PieChartData(dataSet: dataSet)
            
            cell.graphicView.data = pieChartDatas
            
            cell.graphicView.chartDescription?.text = ""
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "pedmeterCell", for: indexPath) as? PedmeterViewCell else {
                return UITableViewCell()
            }
            if CMPedometer.isStepCountingAvailable() {
                let serialQueue : DispatchQueue  = DispatchQueue(label: "com.pedometer.MyQueue", attributes: [])
                let formatter = DateFormatter()
                formatter.dateFormat = "d MMM"
                serialQueue.sync(execute: { () -> Void in
                    for day in 0...6 {
                        let startDate = Date(timeIntervalSinceNow: Double(-7 + day) * 86400)
                        let endDate = Date(timeIntervalSinceNow: Double(-7 + day + 1) * 86400)
                        let dateString = formatter.string(from: endDate)
                        
                        self.pedoMeter.queryPedometerData(from: startDate, to: endDate, withHandler: { (CMData:CMPedometerData?, error) -> Void in
                            guard let data = CMData else {
                                return
                            }
                            cell.numberSteps.text = "\(data.numberOfSteps)"
                            self.days.append(dateString)
                            self.result.append(data.numberOfSteps.doubleValue)
                            if(self.days.count == 7){
                                DispatchQueue.main.sync(execute: { () -> Void in
//                                    let view = self.result.lineGraph().view(cell.graphicView.bounds).lineGraphConfiguration({ LineGraphViewConfig(lineColor: GWMColorRed,textColor:GWMColorYellow, contentInsets: UIEdgeInsets(top: 32.0, left: 32.0, bottom: 32.0, right: 32.0)) })
//                                    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//                                    cell.graphicView.addSubview(view)
                                })
                            }

                        })
                        
                    }
                })
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isNonData() {
            self.performSegue(withIdentifier: "graphView", sender: self)
        } else {
            if (indexPath as NSIndexPath).section == 1 {
                self.performSegue(withIdentifier: "graphView", sender: self)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        if isNonData() {
            return cell.selectionStyle = .default
        } else {
            if (indexPath as NSIndexPath).section == 0 {
                return cell.selectionStyle = .none
            } else {
                return cell.selectionStyle = .default
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Analysis"
        self.tableView.backgroundColor = GWMColorBackground
        self.tableView.separatorColor = UIColor.clear
        self.tableView.delegate = self
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS {
            self.view.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let cusers = DatabaseHelper.sharedInstance.queryAll(Person())
        curentUser = cusers?.first
        if curentUser == nil {
            curentUser = Person()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "graphView" {
            guard let destinationVC = segue.destination as? AnalysisGraphViewController else {
                return
            }
            destinationVC.data = result
            destinationVC.labels = days
        }
    }
}
