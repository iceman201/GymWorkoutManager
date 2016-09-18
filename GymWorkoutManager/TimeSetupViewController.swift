//
//  TimeSetupViewController.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 16/1/18.
//  Copyright © 2016年 McKay. All rights reserved.
//

import UIKit
import RealmSwift

protocol TimeSetupViewControllerDelegate: NSObjectProtocol {
    func timeSetupFinish(_ timeSetupViewController: TimeSetupViewController, result: [String])
}

class TimeSetupViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource {
    // MARK: - Variables
    let seconds = Array(0...59)
    let minutes = Array(0...59)
    var result : [String] = ["0","0","0"] // Formate : [Mins : secs : rounds]
    weak var delegate : TimeSetupViewControllerDelegate? = nil
    weak internal var timerDelegate : TimeSetupViewControllerDelegate? {
        get {
            return self.delegate
        }
        set {
            self.delegate = newValue
        }
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak var NOR: UILabel!
    @IBAction func roundNumberStepper(_ sender: UIStepper) {
        NOR.text = String(Int(sender.value))
    }
    
    @IBOutlet var timePicker: UIPickerView!
    @IBOutlet weak var doneButton: UIButton!
    @IBAction func confirmButton(_ sender: AnyObject) {
        if self.NOR.text == "" {
            self.result[2] = "0"
        } else {
            self.result[2] = self.NOR.text!
        }
        
        self.view.endEditing(true);
        if let del = delegate {
            del.timeSetupFinish(self, result: self.result)
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - PickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 || component == 2{
            return 1
        } else if component == 1 {
            return minutes.count
        } else {
            return seconds.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString : NSAttributedString
        if component == 0 {
            attributedString = NSAttributedString(string: "Mins", attributes: [NSForegroundColorAttributeName : UIColor.white])
        } else if component == 1 {
            attributedString = NSAttributedString(string: String(minutes[row]), attributes: [NSForegroundColorAttributeName : UIColor.white])
        } else if component == 2 {
            attributedString = NSAttributedString(string: "Sec", attributes: [NSForegroundColorAttributeName : UIColor.white])
        } else {
            attributedString = NSAttributedString(string: String(seconds[row]), attributes: [NSForegroundColorAttributeName : UIColor.white])
        }
        return attributedString
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 1 {
            result[0] = String(minutes[row])
        } else if component == 3 {
            result[1] = String(seconds[row])
        }
    }
    
    // MARK: - View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timePicker.delegate = self
        self.timePicker.dataSource = self
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS {
            self.view.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
