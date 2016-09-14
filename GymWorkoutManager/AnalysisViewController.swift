//
//  AnalysisViewController.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 16/5/14.
//  Copyright © 2016年 McKay. All rights reserved.
//

import UIKit
import RealmSwift
import Graphs
import CoreMotion

struct graphData<T: Hashable, U: NumericType> : GraphData {
    typealias GraphDataKey = T
    typealias GraphDataValue = U
    
    fileprivate let _key: T
    fileprivate let _value: U
    
    init(key: T, value: U) {
        self._key = key
        self._value = value
    }
    
    var key: T { get{ return self._key } }
    var value: U { get{ return self._value } }
}

class AnalysisViewController: UITableViewController {
    var curentUser:Person?
    var result : [Int] = []
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
            return 225
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
            let data = [
                //Cardio
                graphData(key: "", value: curentUser?.getPercentageOfWorkout("0") ?? 0.0),
                //Weights
                graphData(key: "", value: curentUser?.getPercentageOfWorkout("1") ?? 0.0),
                //Hiit
                graphData(key: "", value: curentUser?.getPercentageOfWorkout("2") ?? 0.0)
            ]
            
            let view = data.pieGraph() { (unit, totalValue) -> String? in
                return unit.key! + "\n" + String(format: "%.0f%%", unit.value / totalValue * 100.0)
                }.view(cell.graphicView.bounds)
            view.pieGraphConfiguration{
                PieGraphViewConfig(textFont: UIFont(name: "DINCondensed-Bold", size: 14.0), isDounut: true, contentInsets: UIEdgeInsets(top: 16.0, left: 16.0, bottom: 16.0, right: 16.0),
                    pieColors: [GWMPieGraphColorCardio, GWMPieGraphColorWeights, GWMPieGraphColorHiit],
                    textColor: UIColor(red: 119.0/255.0, green: 136.0/255.0, blue: 153.0/255.0, alpha: 1.0)
                )
            }
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            cell.title.text = "Proportion of Workout"
            for each in data {
                guard !each._value.isNaN else { return cell }
            }
            cell.graphicView.addSubview(view)
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
                        self.pedoMeter.queryPedometerData(from: startDate, to: endDate) { (CMData: CMPedometerData?, errors:NSError?) -> Void in
                            guard let data = CMData else { return }
                            cell.numberSteps.text = "\(data.numberOfSteps)"
                            self.days.append(dateString)
                            self.result.append(data.numberOfSteps.intValue)
                            if(self.days.count == 7){
                                DispatchQueue.main.sync(execute: { () -> Void in
                                    let view = self.result.lineGraph().view(cell.graphicView.bounds).lineGraphConfiguration({ LineGraphViewConfig(lineColor: GWMColorRed, contentInsets: UIEdgeInsets(top: 32.0, left: 32.0, bottom: 32.0, right: 32.0)) })
                                    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                                    cell.graphicView.addSubview(view)
                                    //cell.graphicView.layer.borderWidth = 1
                                    //cell.graphicView.layer.borderColor = GWMColorRed.CGColor
                                })
                            }
                            
                        } as! CMPedometerHandler as! CMPedometerHandler as! CMPedometerHandler as! CMPedometerHandler as! CMPedometerHandler as! CMPedometerHandler as! CMPedometerHandler
                    }
                })
            }
            return cell
        }
    }
    /*
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if
    }*/
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
