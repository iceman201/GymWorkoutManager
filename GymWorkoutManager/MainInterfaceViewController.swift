//
//  MainInterfaceViewController.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 25/01/16.
//  Copyright © 2016 McKay. All rights reserved.
//

import UIKit
import MediaPlayer

class MainInterfaceViewController: UIViewController {
    // MARK: - Variables
    var moviePlayer: MPMoviePlayerController!
    
    // MARK: - IBOutlet
    @IBOutlet var logo: UIImageView!

    
    @IBAction func timerButtonAnimation(sender: AnyObject) {
        UIView.animateWithDuration(1, animations: {
            if let button = sender as? SpringButton {
                button.animation = "pop"
                button.curve = "easeInOut"
                button.duration = 1
                button.scaleX = 2.7
                button.scaleY = 2.7
                button.damping = 1.0
                button.animate()
            }
            }) { (done) in
                self.performSegueWithIdentifier("timer", sender: sender)
        }
    }
    
    @IBAction func recordButtonAnimation(sender: AnyObject) {
        UIView.animateWithDuration(1.5, animations: {
            if let button = sender as? SpringButton {
                button.animation = "wobble"
                button.curve = "spring"
                button.force = 1.2
                button.scaleX = 3.0
                button.scaleY = 3.0
                button.duration = 1.5
                button.animate()
            }
        }) { (done) in
            self.performSegueWithIdentifier("record", sender: sender)
        }
    }
    
    @IBAction func profileButtonAnimation(sender: AnyObject) {
        UIView.animateWithDuration(1, animations: {
            if let button = sender as? SpringButton {
                button.animation = "morph"
                button.curve = "easeInOut"
                button.duration = 1
                button.scaleX = 2.0
                button.scaleY = 2.0
                button.animate()
            }
            }) { (Done) in
                self.performSegueWithIdentifier("profile", sender: sender)
        }
    }
    
    @IBAction func analysisButtonAnimation(sender: AnyObject) {
        UIView.animateWithDuration(1, animations: {
            if let button = sender as? SpringButton {
                button.animation = "swing"
                button.curve = "easeIn"
                button.duration = 1.0
                button.scaleX = -3.0
                button.scaleY = -3.0
                button.damping = 0.3
                button.velocity = 1.0
                button.animate()
            }
        }) { (done) in
            self.performSegueWithIdentifier("analysis", sender: sender)
        }
    }
    
    @objc private func loopVideo() {
        self.moviePlayer.play()
    }
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        let videoURL: NSURL = NSBundle.mainBundle().URLForResource("background", withExtension: "mov")!

        self.moviePlayer = MPMoviePlayerController(contentURL: videoURL)
        self.moviePlayer.controlStyle = MPMovieControlStyle.None
        self.moviePlayer.scalingMode = MPMovieScalingMode.AspectFit
        self.moviePlayer.view.frame = self.view.frame
        self.view .insertSubview(self.moviePlayer.view, atIndex: 0)
        
        self.moviePlayer.play()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(loopVideo), name: MPMoviePlayerPlaybackDidFinishNotification, object: self.moviePlayer)
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
}
