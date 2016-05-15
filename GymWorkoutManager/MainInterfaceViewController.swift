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
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        let videoURL: NSURL = NSBundle.mainBundle().URLForResource("background", withExtension: "mov")!

        self.moviePlayer = MPMoviePlayerController(contentURL: videoURL)
        self.moviePlayer.controlStyle = MPMovieControlStyle.None
        self.moviePlayer.scalingMode = MPMovieScalingMode.AspectFill
        self.moviePlayer.view.frame = self.view.frame
        self.view .insertSubview(self.moviePlayer.view, atIndex: 0)
        self.moviePlayer.play()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(loopVideo), name: MPMoviePlayerPlaybackDidFinishNotification, object: self.moviePlayer)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
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
