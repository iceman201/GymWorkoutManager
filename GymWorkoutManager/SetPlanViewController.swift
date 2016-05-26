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
    
    var date: String = ""
    var updateplan : Plan?
    
    
    //MARK: function
    
    @IBAction func saveButton(sender: AnyObject) {
        
        var newPlan = Plan()
        if let updateplan = updateplan {
            newPlan = updateplan
        }
        
        newPlan.date = date
        newPlan.detail = planContent.text
        switch chooseType.selectedSegmentIndex {
        case 0:
            newPlan.type = "Cardio"
        case 1:
            newPlan.type = "Weights"
        case 2:
            newPlan.type = "HIIT"
        default:
            newPlan.type = "Cardio"
        }
        do {
            let r = try Realm()
            try r.write({
                r.add(newPlan)
            })
        } catch let error as NSError {
            print(error)
        }

        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let updateplan = updateplan {
            dateDisplayLabel.text = updateplan.date
            planContent.text = updateplan.detail
            switch updateplan.type {
            case "Cardio":
                chooseType.selectedSegmentIndex = 0
            case "Weights":
                chooseType.selectedSegmentIndex = 1
            case "HIIT":
                chooseType.selectedSegmentIndex = 2
            default:
                chooseType.selectedSegmentIndex = 0
            }
        }else {
            dateDisplayLabel.text = date
        }
        
    }
    
}
