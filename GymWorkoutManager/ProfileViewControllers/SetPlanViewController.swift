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

class SetPlanViewController: UIViewController, UITextViewDelegate {
    //MARK: Properties
    @IBOutlet weak var dateDisplayLabel: UILabel!
    @IBOutlet weak var chooseType: UISegmentedControl!
    @IBOutlet weak var planContent: JVFloatLabeledTextView!
    //MARK: Variable
    var date: String = ""
    var updateplan : Plan?
    var curentUser : Person?
    
    //MARK: function
    @IBAction func saveButton(_ sender: AnyObject) {
        guard chooseType.selectedSegmentIndex != -1 else {
            alertMessage("Reminder", alertMessage: "Please select your workout type.", cancleButtonTitle: "OK")
            return
        }
        guard planContent.text.isEmpty == false else {
            alertMessage("Reminder", alertMessage: "Please select your workout type.", cancleButtonTitle: "OK")
            return
        }
        
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
                break
        }

        if let localUser = self.curentUser {
            if localUser.plans.contains(where: { $0.date == newPlan.date }) {
                DatabaseHelper.sharedInstance.commitTransaction()
            } else {
                localUser.plans.append(newPlan)
                DatabaseHelper.sharedInstance.commitTransaction()
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func alertMessage(_ alertTitle:String, alertMessage:String, cancleButtonTitle:String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancleButtonTitle, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        planContent.delegate = self
        planContent.floatingLabelShouldLockToTop = true
        planContent.floatingLabel.font = UIFont.systemFont(ofSize: 18)
        
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
