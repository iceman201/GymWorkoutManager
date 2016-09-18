//
//  AnalysisGraphViewController.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 16/9/15.
//  Copyright © 2016年 McKay. All rights reserved.
//

import UIKit
import ScrollableGraphView

class AnalysisGraphViewController: UIViewController {

    @IBOutlet var graphView: ScrollableGraphView!
    let numberOfDataItems = 29

    var data: [Double]?
    var labels: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let data = data, let labels = labels else {
            return
        }
        self.title = "History"
        graphView?.setData(data, withLabels: formatingDate(labels))
        graphView.referenceLineLabelFont = UIFont(name: "HelveticaNeue", size: 12)!
    }
    
    fileprivate func formatingDate(_ dates:[String]) -> [String] {
        var result: [String] = []
        for eachDate in dates {
            result.append(eachDate.replacingOccurrences(of: " ", with: "-"))
        }
        return result
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
