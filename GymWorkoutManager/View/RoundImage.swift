//
//  RoundImage.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 16/5/14.
//  Copyright © 2016年 McKay. All rights reserved.
//

import UIKit

class RoundImage: UIImageView {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.layer.borderWidth = 6
        self.layer.borderColor = tintColor.cgColor
        self.layer.cornerRadius = 0.5 * self.bounds.size.width
    }
}
