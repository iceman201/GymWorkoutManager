//
//  AnalysisGraphViewController.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 16/9/15.
//  Copyright © 2016年 McKay. All rights reserved.
//

import UIKit
import ScrollableGraphView

class AnalysisGraphViewController: UIViewController, ScrollableGraphViewDataSource {
    @IBOutlet var graphView: ScrollableGraphView!
    let numberOfDataItems = 29

    var data: [Double]?
    var labels: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "History"
        self.graphView.dataSource = self
//        graphView.setData(data, withLabels: formatingDate(labels))
//        graphView.referenceLineLabelFont = UIFont(name: "HelveticaNeue", size: 12)!
    }
    
    fileprivate func formatingDate(_ dates:[String]) -> [String] {
        var result: [String] = []
        for eachDate in dates {
            result.append(eachDate.replacingOccurrences(of: " ", with: "-"))
        }
        return result
    }
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        guard let data = data else { return 0.0 }
        return data[pointIndex]
    }
    
    func label(atIndex pointIndex: Int) -> String {
        guard let label = labels else { return "" }
        return label[pointIndex]
    }
    
    func numberOfPoints() -> Int {
        return data?.count ?? 0
    }
}
