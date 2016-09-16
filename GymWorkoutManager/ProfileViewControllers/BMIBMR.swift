//
//  PersonalInformation.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 16/3/19.
//  Copyright © 2016年 McKay. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class BMIBMR: UIViewController, UITextFieldDelegate {
    // MARK: - IBOutlet
    @IBOutlet var bodyFat: JVFloatLabeledTextField!
    @IBOutlet weak var indexDisplayLabel: UILabel!
    
    var weight = ""
    var height = ""
    var age = 0
    var gender = 0
    var curentUser:Person?
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false

        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "profileBackground.jpg")!)
        bodyFat.delegate = self
        styleTextField()
        indexDisplayLabel.textColor = UIColor.white
        
        /* Configure tap recognizer */
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(BMIBMR.handleSingleTap(_:)))
        tapRecognizer?.numberOfTapsRequired = 1
        tapRecognizer?.delegate = self
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS {
            self.view.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addKeyboardDismissRecognizer()
        self.subscribeToKeyboardNotifications()
        
        self.navigationController?.navigationBar.topItem?.title = "BMI&BMR"
        let cusers = DatabaseHelper.sharedInstance.queryAll(Person())
        curentUser = cusers?.first
        if curentUser == nil {
            curentUser = Person()
        }
        if let user = curentUser {
            DatabaseHelper.sharedInstance.beginTransaction()
            height = user.height
            weight = user.weight
            DatabaseHelper.sharedInstance.commitTransaction()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardDismissRecognizer()
        self.unsubscribeToKeyboardNotifications()
    }
    
    @IBAction func BMRCalculation(_ sender: AnyObject) {
        if bodyFat.text?.isEmpty == true {
            let alert = UIAlertController(title: "Message", message: "Please enter your body fat percentage", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let result = BMRCalculation1(age, w: Float(weight ?? "") ?? 0.0, h: Float(height ?? "") ?? 0.0, gender: gender)
            indexDisplayLabel.text = String(result)
        }
    }
    
    @IBAction func BMICalculation(_ sender: AnyObject) {
        let result = BMICalculator(Float(weight ?? "") ?? 0.0, heights: Float(height ?? "") ?? 0.0)
        indexDisplayLabel.text = String(result)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return numberEnterOnly(replacementString: string)
    }
    
    fileprivate func setLayer(_ input:JVFloatLabeledTextField) -> CALayer {
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = self.view.tintColor.cgColor
        border.frame = CGRect(x: 0, y: input.frame.size.height - width, width:  input.frame.size.width, height: input.frame.size.height)
        border.borderWidth = width
        return border
    }
    
    fileprivate func styleTextField() {
        bodyFat.layer.addSublayer(setLayer(bodyFat))
        bodyFat.backgroundColor = UIColor.clear
        bodyFat.textColor = UIColor.white
        bodyFat.layer.masksToBounds = true
    }
    
    fileprivate func BMRCalculation1(_ a:Int, w:Float, h:Float, gender:Int) -> Float{
        /* Harris Benedict Method
           BMR Men: BMR = 66.5 + ( 13.75 x weight in kg ) + ( 5.003 x height in cm ) – ( 6.755 x age in years )
           BMR Women: BMR = 655.1 + ( 9.563 x weight in kg ) + ( 1.850 x height in cm ) – ( 4.676 x age in years ) */
        var result : Float = 0.0
        if gender == 0 { // 0 For male
            result = 66+(13.75*w)+(5.003*h)-(6.755 * Float(a))
        } else if gender == 1 { // 1 For female
            result = 655.1+(9.563*w)+(1.85*h)-(4.676 * Float(a))
        }
        return result
    }
    fileprivate func BMRCalculation2(_ age:Int, weights:Float, bodyFat:Float) -> Float {
        /*  Katch & McArdle Method
            BMR (Men + Women) = 370 + (21.6 * Lean Mass in kg)
            Lean Mass = weight in kg – (weight in kg * body fat %)
            1 kg = 2.2 pounds, so divide your weight by 2.2 to get your weight in kg */
        var result : Float = 0.0
        var leanMass : Float = 0.0
        leanMass = weights - (weights * bodyFat)
        result = 370 + (21.6 * leanMass)
        return result
    }
    fileprivate func BMICalculator(_ weights:Float, heights:Float) -> Float {
        // Metric Units: BMI = Weight (kg) / (Height (m) x Height (m))
        let result = 10000*(weights / (heights * heights))
        return result
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    
}

// MARK: - ProfileViewController (Show/Hide Keyboard)

extension BMIBMR:UIGestureRecognizerDelegate {
    
    func addKeyboardDismissRecognizer() {
        print("add keyboard dissmiss recognizer")
        view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view {
            if view is UIButton{
                return false
            }
        }
        return true
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        print("keyboard will show")
        print("height is " + String(describing: getKeyboardHeight(notification)/2))
        if(view.frame.origin.y == 0.0){
            view.frame.origin.y -= getKeyboardHeight(notification) / 2
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        print("keyboard will hide")
        view.frame.origin.y = 0.0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
}

