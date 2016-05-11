//
//  MainInterfaceViewController.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 25/01/16.
//  Copyright © 2016 McKay. All rights reserved.
//

import UIKit
import ChameleonFramework
import MediaPlayer

class MainInterfaceViewController: UIViewController {
    var moviePlayer: MPMoviePlayerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load the video from the app bundle.
        let videoURL: NSURL = NSBundle.mainBundle().URLForResource("background", withExtension: "mov")!
        
        // Create and configure the movie player.
        self.moviePlayer = MPMoviePlayerController(contentURL: videoURL)
        
        self.moviePlayer.controlStyle = MPMovieControlStyle.None
        self.moviePlayer.scalingMode = MPMovieScalingMode.AspectFill
        
        self.moviePlayer.view.frame = self.view.frame
        self.view .insertSubview(self.moviePlayer.view, atIndex: 0)
        
        self.moviePlayer.play()
        
        // Loop video.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(loopVideo), name: MPMoviePlayerPlaybackDidFinishNotification, object: self.moviePlayer)
    }
    
    @objc private func loopVideo() {
        self.moviePlayer.play()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToMainView(segue: UIStoryboardSegue){
        
    }
}
