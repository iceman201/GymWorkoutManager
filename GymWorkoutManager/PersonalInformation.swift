//
//  PersonalInformation.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 16/3/19.
//  Copyright © 2016年 McKay. All rights reserved.
//

import UIKit
import ChameleonFramework
import JVFloatLabeledTextField

class PersonalInformation: UIViewController {
    
    @IBOutlet var name: JVFloatLabeledTextField!
    @IBOutlet var gender: UISegmentedControl!
    @IBOutlet var age: JVFloatLabeledTextField!
    @IBOutlet var bodyFat: JVFloatLabeledTextField!
    @IBOutlet var weight: JVFloatLabeledTextField!
    @IBOutlet var height: JVFloatLabeledTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    private func BMRCalculation1(age:Int, weight:Float, height:Float, gender:String) {
        //Katch & McArdle Method
        /*BMR Men: = 66 + (6.23 X weight in pounds) + (12.7 X height in inches) – (6.8 X age)
        
        BMR Women: = 655 + (4.35 X weight in pounds) + (4.7 X height in inches) – (4.7 X age)*/
        
    }
    private func BMRCalculation2(age:Int, weight:Float, height:Float, gender:String, bodyFat:String) {
        //Katch & McArdle Method
        /*BMR (Men + Women) = 370 + (21.6 * Lean Mass in kg)
        Lean Mass = weight in kg – (weight in kg * body fat %)
        1 kg = 2.2 pounds, so divide your weight by 2.2 to get your weight in kg*/
    }

}
