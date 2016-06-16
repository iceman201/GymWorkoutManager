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
    //MARK: Properties
    @IBOutlet weak var dateDisplayLabel: UILabel!
    @IBOutlet weak var chooseType: UISegmentedControl!
    @IBOutlet weak var planContent: JVFloatLabeledTextView!
    //MARK: Variable
    var date: String = ""
    var updateplan : Plan?
    var curentUser : Person?
    
    
    //MARK: function
    
    @IBAction func saveButton(sender: AnyObject) {
        
        var newPlan = Plan()
        let cusers = DatabaseHelper.sharedInstance.queryAll(Person())
        self.curentUser = cusers?.first
        if self.curentUser == nil{
            self.curentUser = Person()
        }
        
        if let updateplan = updateplan {
            newPlan = updateplan
        }
        DatabaseHelper.sharedInstance.beginTransaction()
        newPlan.date = date
        newPlan.detail = planContent.text
        switch chooseType.selectedSegmentIndex {
        case 0:
            newPlan.exerciseType = "Cardio"
        case 1:
            newPlan.exerciseType = "Weights"
        case 2:
            newPlan.exerciseType = "HIIT"
        default:
            newPlan.exerciseType = "Cardio"
        }
        
        //TODO: replace the plan if it's exist otherwise save it
        if let localUser = self.curentUser {
            if localUser.plans.contains({ $0.date == newPlan.date }) {
                localUser.plans.replace(localUser.plans.indexOf(newPlan)!, object: newPlan)
            } else {
                localUser.plans.append(newPlan)
            }
        }
        DatabaseHelper.sharedInstance.commitTransaction()

        planContent.text = ""
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let updateplan = updateplan {
            dateDisplayLabel.text = updateplan.date
            planContent.text = updateplan.detail
            switch updateplan.exerciseType {
            case "Cardio":
                chooseType.selectedSegmentIndex = 0
            case "Weights":
                chooseType.selectedSegmentIndex = 1
            case "HIIT":
                chooseType.selectedSegmentIndex = 2
            default:
                chooseType.selectedSegmentIndex = 0
            }
        } else {
            dateDisplayLabel.text = date
        }
        
    }
    
}
