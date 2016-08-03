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
    var moviePlayer: MPMoviePlayerController!

    let items: [(icon: String, color: UIColor)] = [
        ("icon_timer", GWMColorBlue),
        ("icon_record", GWMColorGreen),
        ("icon-profile", GWMColorRed),
        ("icon-analysis", UIColor.whiteColor()),
        ]
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        /*
        UIView.animateWithDuration(3.5, delay: 0.3, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.startButton.alpha = 1.0
            self.startButton.transform = CGAffineTransformMakeRotation(CGFloat(M_2_PI*4))
        }, completion: nil)*/
        self.buttonBackgroundAnimation()
        dispatch_async(dispatch_get_main_queue(), {
            
        })
    }
    
    private func buttonBackgroundAnimation() {
        UIView.animateWithDuration(1, delay: 0.3, options: [.Repeat, .Autoreverse], animations: {
            self.backLayer.transform = CGAffineTransformMakeScale(0.1, 0.1)
            self.backLayer.alpha = 0
            }) { (finished) in
                UIView.animateWithDuration(1, animations: {
                    self.backLayer.alpha = 0.8
                    self.backLayer.transform = CGAffineTransformMakeScale(1, 1)
                    }, completion: { (done) in
                        self.backLayer.alpha = 0
                })
        }
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
        button.backgroundColor = items[atIndex].color
        button.setImage(UIImage(imageLiteral: items[atIndex].icon), forState: .Normal)
        
        // set highlited image
        let highlightedImage  = UIImage(imageLiteral: items[atIndex].icon).imageWithRenderingMode(.AlwaysTemplate)
        button.setImage(highlightedImage, forState: .Highlighted)
        button.tintColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3)
    }
/*
    func circleMenu(circleMenu: CircleMenu, buttonWillSelected button: UIButton, atIndex: Int) {
        print("button will selected: \(atIndex)")
    }
*/
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
