//
//  PedmeterViewCell.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 13/07/16.
//  Copyright © 2016 McKay. All rights reserved.
//

import UIKit

class PedmeterViewCell: UITableViewCell {
    
    @IBOutlet weak var graphicView: UIImageView!
    @IBOutlet var numberSteps: UILabel!
    @IBOutlet var stepsLabel: UILabel!
    
    override func awakeFromNib() {
        numberSteps.textColor = UIColor.whiteColor()
        stepsLabel.textColor = UIColor.whiteColor()
    }
}
