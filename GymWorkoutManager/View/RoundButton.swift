//
//  RoundButton.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 18/03/16.
//  Copyright © 2016 McKay. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.layer.borderWidth = 1
        self.layer.borderColor = self.tintColor.cgColor
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
    }
}
