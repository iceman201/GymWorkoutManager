//
//  MainInterfaceViewController.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 25/01/16.
//  Copyright © 2016 McKay. All rights reserved.
//

import UIKit
import ChameleonFramework

class MainInterfaceViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let colorset:[UIColor] = [
            UIColor.flatYellowColor(),
            UIColor.flatYellowColorDark(),
            UIColor.flatLimeColor(),
            UIColor.flatLimeColorDark(),
            UIColor.flatGreenColor(),
            UIColor.flatGreenColorDark()
        ]
        self.view.backgroundColor = GradientColor(.TopToBottom, frame: self.view.frame, colors: colorset)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToMainView(segue: UIStoryboardSegue){
        
    }
}
