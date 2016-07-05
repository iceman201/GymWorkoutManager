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

class AnalysisViewController: UITableViewController {
    var curentUser:Person?
    /*
    struct Data<T: Hashable, U: NumericType>: GraphData {
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
    
    let data = [
        Data(key: "John", value: 18.9),
        Data(key: "Ken", value: 32.9),
        Data(key: "Taro", value: 15.3),
        Data(key: "Micheal", value: 22.9),
        Data(key: "Jun", value: 12.9),
        Data(key: "Hanako", value: 32.2),
        Data(key: "Kent", value: 3.8)
    ]
    */
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 312
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("graphicCell", forIndexPath: indexPath) as? GraphViewCell else {
            return UITableViewCell()
        }
        /*
        let view = data.pieGraph() { (unit, totalValue) -> String? in
            return unit.key! + "\n" + String(format: "%.0f%%", unit.value / totalValue * 100.0)
            }.view(cell.graphicView.frame)
        */
        let view = ["a": 3, "b": 8, "c": 9, "d": 20].pieGraph().view(cell.graphicView.bounds)
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        cell.graphicView.addSubview(view)
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "Analysis"
        self.tableView.backgroundColor = GWMColorBackground
        self.tableView.separatorColor = GWMColorYellow
        self.tableView.delegate = self
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
