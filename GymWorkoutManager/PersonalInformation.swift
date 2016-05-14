//
//  PersonalInformation.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 16/3/19.
//  Copyright © 2016年 McKay. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class PersonalInformation: UIViewController, UITextFieldDelegate {
    @IBOutlet var name: JVFloatLabeledTextField!
    @IBOutlet var gender: UISegmentedControl!
    @IBOutlet var age: JVFloatLabeledTextField!
    @IBOutlet var bodyFat: JVFloatLabeledTextField!
    @IBOutlet var weight: JVFloatLabeledTextField!
    @IBOutlet var height: JVFloatLabeledTextField!
    
    @IBOutlet weak var indexDisplayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = "BMI&BMR"
        age.delegate = self
        bodyFat.delegate = self
        weight.delegate = self
        height.delegate = self
        styleTextField()
        print(gender.selectedSegmentIndex)
    }
    
    @IBAction func selectGender(sender: AnyObject) {
        if gender.selectedSegmentIndex == 0 {
            print("M")
        } else if gender.selectedSegmentIndex == 1 {
            print("F")
        }
    }
    
    @IBAction func BMRCalculation(sender: AnyObject) {
    }
    
    @IBAction func BMICalculation(sender: AnyObject) {
        let result = BMICalculator(Float(weight.text ?? "") ?? 0.0, heights: Float(height.text ?? "") ?? 0.0)
        indexDisplayLabel.text = String(result)
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let inverseSet = NSCharacterSet(charactersInString:"0123456789.").invertedSet
        let components = string.componentsSeparatedByCharactersInSet(inverseSet)
        let filtered = components.joinWithSeparator("")
        return string == filtered
    }
    
    private func setLayer(input:JVFloatLabeledTextField) -> CALayer {
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = self.view.tintColor.CGColor
        border.frame = CGRect(x: 0, y: input.frame.size.height - width, width:  input.frame.size.width, height: input.frame.size.height)
        border.borderWidth = width
        return border
    }
    
    private func styleTextField() {
        name.layer.addSublayer(setLayer(name))
        name.backgroundColor = UIColor.clearColor()
        name.textColor = UIColor.whiteColor()
        name.layer.masksToBounds = true
        
        age.layer.addSublayer(setLayer(age))
        age.backgroundColor = UIColor.clearColor()
        age.textColor = UIColor.whiteColor()
        age.layer.masksToBounds = true
        
        bodyFat.layer.addSublayer(setLayer(bodyFat))
        bodyFat.backgroundColor = UIColor.clearColor()
        bodyFat.textColor = UIColor.whiteColor()
        bodyFat.layer.masksToBounds = true
        
        weight.layer.addSublayer(setLayer(weight))
        weight.backgroundColor = UIColor.clearColor()
        weight.textColor = UIColor.whiteColor()
        weight.layer.masksToBounds = true
        
        height.layer.addSublayer(setLayer(height))
        height.backgroundColor = UIColor.clearColor()
        height.textColor = UIColor.whiteColor()
        height.layer.masksToBounds = true
        
    }
    
    private func BMRCalculation1(a:Int, w:Float, h:Float, gender:Int) -> Float{
        //Harris Benedict Method
        /*BMR Men: BMR = 66.5 + ( 13.75 x weight in kg ) + ( 5.003 x height in cm ) – ( 6.755 x age in years )
        
        BMR Women: BMR = 655.1 + ( 9.563 x weight in kg ) + ( 1.850 x height in cm ) – ( 4.676 x age in years )
        */
        var result : Float = 0.0
        if gender == 0 { // 0 For male
            result = 66+(13.75*w)+(5.003*h)-(6.755 * Float(a))
        } else if gender == 1 { // 1 For female
            result = 655.1+(9.563*w)+(1.85*h)-(4.676 * Float(a))
        }
        return result
    }
    private func BMRCalculation2(age:Int, weights:Float, bodyFat:Float) -> Float {
        //Katch & McArdle Method
        /*
        BMR (Men + Women) = 370 + (21.6 * Lean Mass in kg)
        
        Lean Mass = weight in kg – (weight in kg * body fat %)
        1 kg = 2.2 pounds, so divide your weight by 2.2 to get your weight in kg
        */
        var result : Float = 0.0
        var leanMass : Float = 0.0
        leanMass = weights - (weights * bodyFat)
        result = 370 + (21.6 * leanMass)
        return result
    }
    private func BMICalculator(weights:Float, heights:Float) -> Float {
        // Metric Units: BMI = Weight (kg) / (Height (m) x Height (m))
        let result = 10000*(weights / (heights * heights))
        return result
    }
}
