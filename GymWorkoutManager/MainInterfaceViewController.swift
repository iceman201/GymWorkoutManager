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

class MainInterfaceViewController: UIViewController, CircleMenuDelegate {
    // MARK: - Variables
    
    @IBOutlet var startButton: CircleMenu!
    @IBOutlet var backLayer: UIImageView!
    @IBOutlet var startLabel: UILabel!
    var mainButtonTouched : Bool?
    
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
        
        UIView.animate(withDuration: 2.0, delay: 0.3, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.startButton.alpha = 1.0
        }, completion: nil)
        self.backLayer.zoomOutWithEasing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        startLabel.isHidden = false
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
        button.setImage(UIImage(imageLiteral: items[atIndex].icon), for: UIControlState())
        button.setTitle(items[atIndex].Name, for: UIControlState())
        button.setImageAndTitleLeft(0.0)
        
        // set highlited image
        let highlightedImage  = UIImage(imageLiteral: items[atIndex].icon).withRenderingMode(.alwaysTemplate)
        button.setImage(highlightedImage, for: .highlighted)
        button.tintColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3)
    }
    func menuCollapsed(_ circleMenu: CircleMenu) {
        backLayer.isHidden = false
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
}
extension UIImageView {
    func zoomOutWithEasing(duration: TimeInterval = 7.7, easingOffset: CGFloat = 0.23) {
        let easeScale = 1.0 + easingOffset
        let easingDuration = TimeInterval(easingOffset) * duration / TimeInterval(easeScale)
        let scalingDuration = duration - easingDuration
        UIView.animate(withDuration: easingDuration, delay: 0.0, options: [.repeat,.curveEaseOut], animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: easeScale, y: easeScale)
            }, completion: { (completed: Bool) -> Void in
                UIView.animate(withDuration: scalingDuration, delay: 0.0, options: [.repeat,.curveEaseOut], animations: { () -> Void in
                    self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
                    }, completion: { (completed: Bool) -> Void in
                })
        })
    }
}
extension UIButton {
    func setImageAndTitleLeft(_ spacing:CGFloat){
        let spacing: CGFloat = 6.0
        let imageSize: CGSize = self.imageView!.image!.size
        let labelString = NSString(string: self.titleLabel!.text!)
        let titleSize = labelString.size(attributes: [NSFontAttributeName: self.titleLabel!.font])
        let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0
        
        self.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0.0, 0.0, -titleSize.width)
        if DeviceType.IS_IPHONE_6P {
            self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + spacing)*2, 0.0)
            self.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset*3.5, 0.0, edgeOffset, 0.0)
        } else {
            self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + spacing)*1.5, 0.0)
            self.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset*2, 0.0, edgeOffset, 0.0)
        }

    }
    
}
