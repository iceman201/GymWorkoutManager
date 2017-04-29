//
//  PedmeterViewCell.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 13/07/16.
//  Copyright © 2016 McKay. All rights reserved.
//

import UIKit

class PedmeterViewCell: UITableViewCell {
    
    @IBOutlet weak var bottomLabel: UILabel!
    @IBOutlet weak var graphicView: UIImageView!
    @IBOutlet weak var numberSteps: UILabel!
    @IBOutlet var stepsLabel: UILabel!
    
    @IBOutlet var distanceLabel: UILabel!
    
    @IBOutlet weak var numberDistance: UILabel!
    
    @IBOutlet var floorLabel: UILabel!
    
    @IBOutlet weak var numberFloor: UILabel!
    
    
    override func awakeFromNib() {
        numberSteps.textColor = .white
        numberDistance.textColor = .white
        numberFloor.textColor = .white
        
        stepsLabel.textColor = .white
        floorLabel.textColor = .white
        distanceLabel.textColor = .white
        
        stepsLabel.text = "Steps of today"
        distanceLabel.text = "Walking Distance of today"
        floorLabel.text = "Flights Climbed of today"
        
        bottomLabel.textColor = UIColor.white
        bottomLabel.text = "* Tap for Steps history."
    }
}
