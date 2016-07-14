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
    
    private let _key: T
    private let _value: U
    
    init(key: T, value: U) {
        self._key = key
        self._value = value
    }
    
    var key: T { get{ return self._key } }
    var value: U { get{ return self._value } }
}

class AnalysisViewController: UITableViewController {
    var curentUser:Person?
    
    let activityManager = CMMotionActivityManager()
    let pedoMeter = CMPedometer()
    var result : [Int] = []
    var days:[String] = []
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 223
        } else {
            return 258
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCellWithIdentifier("graphicCell", forIndexPath: indexPath) as? GraphViewCell else {
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
                    pieColors: [
                        GWMPieGraphColorCardio,
                        GWMPieGraphColorWeights,
                        GWMPieGraphColorHiit
                    ],
                    textColor: UIColor(red: 119.0/255.0, green: 136.0/255.0, blue: 153.0/255.0, alpha: 1.0)
                )
            }
        
            view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            cell.title.text = "Proportion of Workout"
            
            

            for each in data {
                guard !each._value.isNaN else {
                    return cell
                }
            }
            cell.graphicView.addSubview(view)
            return cell
        } else {
            
            guard let cell = tableView.dequeueReusableCellWithIdentifier("pedmeterCell", forIndexPath: indexPath) as? PedmeterViewCell else {
                return UITableViewCell()
            }
            
            if CMPedometer.isStepCountingAvailable() {
                self.pedoMeter.queryPedometerDataFromDate(NSDate().dateByAddingTimeInterval(-604800.0), toDate: NSDate(), withHandler: { (CMPData: CMPedometerData?, errors:NSError?) in
                    guard errors == nil else {
                        return
                    }
                    if let data = CMPData {
                        cell.numberSteps.text = "\(data.numberOfSteps)"
                    }
                })

                
            }
            
            let view = result.lineGraph().view(cell.graphicView.bounds).lineGraphConfiguration({ LineGraphViewConfig(lineColor: UIColor(hex: "#ff6699"), contentInsets: UIEdgeInsets(top: 32.0, left: 32.0, bottom: 32.0, right: 32.0)) })
            view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            cell.graphicView.addSubview(view)

            return cell
        }
    }
    
    func arrageSteps(){
        let today = NSDate()
        let one = today.dateByAddingTimeInterval(-604800.0)
        let two = today.dateByAddingTimeInterval(-518400.0)
        let three = today.dateByAddingTimeInterval(-432000.0)
        let four = today.dateByAddingTimeInterval(-345600.0)
        let five = today.dateByAddingTimeInterval(-259200.0)
        let six = today.dateByAddingTimeInterval(-172800.0)
        let seven = today.dateByAddingTimeInterval(-86400.0)
        
        self.getPedometer(one, endDay: two)
        self.getPedometer(two, endDay: three)
        self.getPedometer(three, endDay: four)
        self.getPedometer(four, endDay: five)
        self.getPedometer(five, endDay: six)
        self.getPedometer(six, endDay: seven)
        self.getPedometer(seven, endDay: today)
    }
    
    
    func getPedometer(startDay: NSDate, endDay: NSDate) {
        if CMPedometer.isStepCountingAvailable() {
            self.pedoMeter.queryPedometerDataFromDate(startDay, toDate: endDay, withHandler: { (CMPData: CMPedometerData?, errors:NSError?) in
                guard errors == nil else {
                    return
                }
                if let data = CMPData {
                    self.result.append(data.numberOfSteps.integerValue)
                }
            })
        } else {
            self.result.append(0)
        }
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = .None
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Analysis"
        self.tableView.backgroundColor = GWMColorBackground
        self.tableView.separatorColor = UIColor.clearColor()
        self.tableView.delegate = self
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        arrageSteps()
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
