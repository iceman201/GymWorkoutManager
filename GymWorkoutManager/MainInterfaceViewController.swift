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
    
    let items: [(icon: String, color: UIColor, Name: String)] = [
        ("icon_timer", GWMColorBlue, "Timer"),
        ("icon_record", GWMColorGreen, "Record"),
        ("icon-profile", GWMColorRed, "Profile"),
        ("icon-analysis", UIColor.whiteColor(), "Analysis"),
        ]
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(2.0, delay: 0.3, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.startButton.alpha = 1.0
        }, completion: nil)
        self.backLayer.zoomOutWithEasing()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToMainView(segue: UIStoryboardSegue){
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
    
    // MARK: <CircleMenuDelegate>
    
    func circleMenu(circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        backLayer.hidden = true
        button.backgroundColor = items[atIndex].color
        button.setImage(UIImage(imageLiteral: items[atIndex].icon), forState: .Normal)
        button.setTitle(items[atIndex].Name, forState: .Normal)
        button.setImageAndTitleLeft(0.0)

        // set highlited image
        let highlightedImage  = UIImage(imageLiteral: items[atIndex].icon).imageWithRenderingMode(.AlwaysTemplate)
        button.setImage(highlightedImage, forState: .Highlighted)
        button.tintColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3)
    }
    func menuCollapsed(circleMenu: CircleMenu) {
        backLayer.hidden = false
    }
    func circleMenu(circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {
        switch atIndex {
        case 0:
            self.performSegueWithIdentifier("timer", sender: self)
        case 1:
            self.performSegueWithIdentifier("record", sender: self)
        case 2:
            self.performSegueWithIdentifier("profile", sender: self)
        case 3:
            self.performSegueWithIdentifier("analysis", sender: self)
        default:
            break
        }
    }
}
extension UIImageView {
    func zoomOutWithEasing(duration duration: NSTimeInterval = 7.7, easingOffset: CGFloat = 0.23) {
        let easeScale = 1.0 + easingOffset
        let easingDuration = NSTimeInterval(easingOffset) * duration / NSTimeInterval(easeScale)
        let scalingDuration = duration - easingDuration
        UIView.animateWithDuration(easingDuration, delay: 0.0, options: [.Repeat,.CurveEaseOut], animations: { () -> Void in
            self.transform = CGAffineTransformMakeScale(easeScale, easeScale)
            }, completion: { (completed: Bool) -> Void in
                UIView.animateWithDuration(scalingDuration, delay: 0.0, options: [.Repeat,.CurveEaseOut], animations: { () -> Void in
                    self.transform = CGAffineTransformMakeScale(0.0, 0.0)
                    }, completion: { (completed: Bool) -> Void in
                })
        })
    }
}
extension UIButton {
    func setImageAndTitleLeft(spacing:CGFloat){
        if let imageSize =  self.imageView?.frame.size,
            let titleSize = self.titleLabel?.frame.size {
            let totalHeight = imageSize.height + titleSize.height + spacing
            
            self.imageEdgeInsets = UIEdgeInsetsMake(-(totalHeight - imageSize.height)/7, self.frame.size.width/7.5, 0.0, 0.0)
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -(totalHeight - titleSize.height)*2, 0.0)
        }
    }
    
}