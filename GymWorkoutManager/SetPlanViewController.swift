//
//  SetPlanViewController.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 16/5/26.
//  Copyright © 2016年 McKay. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import RealmSwift

class SetPlanViewController: UIViewController {
    
    @IBOutlet weak var dateDisplayLabel: UILabel!
    
    @IBOutlet weak var chooseType: UISegmentedControl!
    
    @IBOutlet weak var planContent: JVFloatLabeledTextView!
    
    @IBAction func saveButton(sender: AnyObject) {
        
    }
    let date: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateDisplayLabel.text = date
    }
}
