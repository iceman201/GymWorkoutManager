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
        let label = ["Cardio","Weights","Hiit"]
        let data = [curentUser?.getPercentageOfWorkout("0") ?? 0.0,
                    curentUser?.getPercentageOfWorkout("1") ?? 0.0,
                    curentUser?.getPercentageOfWorkout("2") ?? 0.0]
        let colors: [UIColor] = [GWMPieGraphColorCardio,
                                 GWMPieGraphColorWeights,
                                 GWMPieGraphColorHiit]
        
        var dataEntryColor: [UIColor] = []
        var dataEntries:[ChartDataEntry] = []
        var startIndexAt: Int = 0
        
        if isNonData() {
            startIndexAt = -1
        }
        if (indexPath as NSIndexPath).section == startIndexAt {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "graphicCell", for: indexPath) as? GraphViewCell else {
                return UITableViewCell()
            }
            
            for i in 0..<label.count {
                if data[i] != 0.0 {
                    let dataEntry = PieChartDataEntry(value: data[i], label: label[i])
                    dataEntryColor.append(colors[i])
                    dataEntries.append(dataEntry)
                }
            }

            let textColor: [UIColor] = [UIColor.white, UIColor.black,UIColor.white]
            cell.title.text = "Proportion of Workout"
            
            let dataSet = PieChartDataSet(values: dataEntries, label: "")
            dataSet.colors = dataEntryColor
            dataSet.valueColors = textColor
            
            let pieChartDatas = PieChartData(dataSet: dataSet)
            
            cell.graphicView.data = pieChartDatas
            cell.graphicView.legend.enabled = false
            cell.graphicView.chartDescription?.text = ""
            if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS {
                cell.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "pedmeterCell", for: indexPath) as? PedmeterViewCell else {
                return UITableViewCell()
            }
            /* TODO: Should use data from HealthKit instead of CoreMotion，
                        as the result from CoreMotion isnt that accurate  */
            if CMPedometer.isStepCountingAvailable() {
                let serialQueue : DispatchQueue  = DispatchQueue(label: "com.pedometer.MyQueue", attributes: [])
                let formatter = DateFormatter()
                formatter.dateFormat = "d MMM"
                self.pedoMeter.startUpdates(from: getFormatDate(startDate: 7, requireEndDate: false), withHandler: { (CMData, error) in
                    if let todayPedometerData = CMData {
                        cell.numberSteps.text = "\(todayPedometerData.numberOfSteps)"
                        cell.numberFloor.text = "\(todayPedometerData.floorsAscended)"
                        cell.numberDistance.text = "\(todayPedometerData.distance)"
                    }

                })
                serialQueue.sync(execute: { () -> Void in
                    for day in 1...7 {
                        let startDate = getFormatDate(startDate: day, requireEndDate: false)
                        let endDate = getFormatDate(startDate: day, requireEndDate: true)
                        self.pedoMeter.queryPedometerData(from: startDate, to: endDate, withHandler: { (CMData:CMPedometerData?, error) -> Void in
                            guard let data = CMData else {
                                return
                            }
                            self.result.append(data.numberOfSteps.doubleValue)
                        })
                    }
                })
            }
            if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS {
                cell.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
            }
            return cell
        }
    }
    
    private func getFormatDate(startDate: Int, requireEndDate: Bool) -> Date {
        let cal = Calendar.current
        let startOfDay = Calendar.current.startOfDay(for: Date())
        var comps = cal.dateComponents([.weekOfYear,.yearForWeekOfYear], from: startOfDay)
        comps.weekday = startDate
        
        if requireEndDate {
            comps.weekday = startDate + 1
            comps.second = -1
            if startDate == 7 {
                comps.weekday = 0
                comps.hour = 24
            }
        }
        let mondayInWeek = cal.date(from: comps)!
        return mondayInWeek
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
            return cell.selectionStyle = .none
            
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Analysis"
        self.tableView.backgroundColor = GWMColorBackground
        self.tableView.separatorColor = UIColor.clear
        self.tableView.delegate = self
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
            destinationVC.labels = ["Sun","Mon","Tue","Wed","Thur","Fri","Sat"]
        }
    }
}
