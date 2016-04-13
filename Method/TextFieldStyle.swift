//
//  TextFieldStyle.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 13/04/16.
//  Copyright © 2016 McKay. All rights reserved.
//

import UIKit

class TextFieldStyle: UITextField {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        let bottomBorder =  CALayer()
        bottomBorder.frame = CGRectMake(0.0, self.frame.size.height - 1, self.frame.size.width, 1.0)
        bottomBorder.backgroundColor = UIColor.blackColor().CGColor
        self.layer.addSublayer(bottomBorder)
    }
}
