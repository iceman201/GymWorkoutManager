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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 223
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
        cell.graphicView.addSubview(view)
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = .None
        
        return cell
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
        
        let cusers = DatabaseHelper.sharedInstance.queryAll(Person())
        curentUser = cusers?.first
        if curentUser == nil {
            curentUser = Person()
        }
        print(curentUser?.effectiveIndex)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
