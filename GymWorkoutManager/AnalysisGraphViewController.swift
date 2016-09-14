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
    var data: [Double]?
    var labels: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let data = data, let labels = labels else {
            return
        }
        graphView?.setData(data, withLabels: labels)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
