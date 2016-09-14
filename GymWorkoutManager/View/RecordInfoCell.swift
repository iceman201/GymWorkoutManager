//
//  RecordInfoCell.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 16/5/12.
//  Copyright © 2016年 McKay. All rights reserved.
//

import UIKit

class RecordInfoCell: UITableViewCell {
    
    @IBOutlet var profileImage: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var weight: UILabel!
    
    @IBOutlet weak var activeDay: UILabel!
    
    @IBOutlet weak var lastTimeWorkout: UILabel!
    
    @IBOutlet weak var effectiveIndex: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImage.layer.borderWidth = 1.0
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds = true
    }
    override var intrinsicContentSize : CGSize {
        return CGSize(width: 414, height: 152)
    }
}
