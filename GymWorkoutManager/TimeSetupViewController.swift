//
//  TimeSetupViewController.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 16/1/18.
//  Copyright © 2016年 McKay. All rights reserved.
//

import UIKit

class TimeSetupViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource {
    
    // MARK: - Variables
    let seconds = Array(0...59)
    let minutes = Array(0...59)
    var result : [String] = ["","",""] // Formate : [Mins : secs : rounds]
    
    // MARK: - IBOutlet
    
    @IBOutlet var numberOfRounds: UITextField!
    @IBOutlet var timePicker: UIPickerView!
    @IBAction func confirmButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            self.result[2] = self.numberOfRounds.text!
            //TODO : pass date to FirstViewController
            print(self.result)
        }
    }
    
    // MARK: - PickerView
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 || component == 2{
            return 1
        } else if component == 1 {
            return minutes.count
        } else {
            return seconds.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return String("Mins")
        } else if component == 1 {
            return String(minutes[row])
        } else if component == 2 {
            return String("Sec")
        } else {
            return String(seconds[row])
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
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
        // Do any additional setup after loading the view.
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
