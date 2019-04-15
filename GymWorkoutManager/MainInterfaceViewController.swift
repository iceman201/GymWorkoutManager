//
//  MainInterfaceViewController.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 25/01/16.
//  Copyright © 2016 McKay. All rights reserved.
//

import UIKit
import MediaPlayer
import CircleMenu
import RealmSwift

class MainInterfaceViewController: UIViewController, CircleMenuDelegate {
    // MARK: - Variables
    
    @IBOutlet var startButton: CircleMenu!
    @IBOutlet var backLayer: UIImageView!
    @IBOutlet var startLabel: UILabel!
    var mainButtonTouched: Bool?
    
    var curentUser:Person?
    
    let items: [(icon: String, color: UIColor, Name: String)] = [
        ("icon_timer", GWMColorBlue, "Timer"),
        ("icon_record", GWMColorGreen, "Record"),
        ("icon-profile", GWMColorRed, "Profile"),
        ("icon-analysis", UIColor.white, "Analysis")]
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS {
            self.view.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }

    }
    @IBAction func tapStartButton(_ sender: AnyObject) {
        startLabel.isHidden = !startLabel.isHidden
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 2.0, delay: 0.3, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.startButton.alpha = 1.0
        }, completion: nil)
        self.backLayer.zoomOutWithEasing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        startLabel.isHidden = false
        let cusers = DatabaseHelper.sharedInstance.queryAll(Person())
        self.curentUser = cusers?.first
        
        if mainButtonTouched == true {
            startButton.sendActions(for: .touchUpInside)
            startLabel.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToMainView(_ segue: UIStoryboardSegue){
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    // MARK: <CircleMenuDelegate>
    
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        backLayer.isHidden = true
        button.backgroundColor = items[atIndex].color
        button.setImage(UIImage(imageLiteralResourceName: items[atIndex].icon), for: UIControl.State())
        button.setTitle(items[atIndex].Name, for: UIControl.State())
        button.setImageAndTitleLeft(0.0)

        if curentUser?.isProfileDetailsExist == true {
            button.isEnabled = true
        } else {
            let alertView = UIAlertController(title: "Hello", message: "Please enter your profile details first.", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            button.isEnabled = false
            if atIndex == 2 {
                button.isEnabled = true
            }
            self.present(alertView, animated: true, completion: nil)
        }

        // set highlited image
        let highlightedImage  = UIImage(imageLiteralResourceName: items[atIndex].icon).withRenderingMode(.alwaysTemplate)
        button.setImage(highlightedImage, for: .highlighted)
        button.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    func menuCollapsed(_ circleMenu: CircleMenu) {
        backLayer.isHidden = true
    }
    
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {
        self.mainButtonTouched = true
        switch atIndex {
        case 0:
            self.performSegue(withIdentifier: "timer", sender: self)
        case 1:
            self.performSegue(withIdentifier: "record", sender: self)
        case 2:
            self.performSegue(withIdentifier: "profile", sender: self)
        case 3:
            self.performSegue(withIdentifier: "analysis", sender: self)
        default:
            break
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

