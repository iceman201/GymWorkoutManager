//
//  RecordInfoCell.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 16/5/12.
//  Copyright © 2016年 McKay. All rights reserved.
//

import UIKit

class RecordInfoCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var weight: UILabel!
    
    @IBOutlet weak var activeDay: UILabel!
    
    @IBOutlet weak var lastTimeWorkout: UILabel!
    
    @IBOutlet weak var effectiveIndex: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        profileImage.layer.borderColor = GWMColorYellow.cgColor
        profileImage.layer.borderWidth = 5
        
        profileImage.layer.cornerRadius = profileImage.frame.size.height * 0.5
        profileImage.layer.masksToBounds = true
        profileImage.image = UIImage(named: "logo.png")// 这行只是我刚才添加的
    }
    override var intrinsicContentSize : CGSize {
        return CGSize(width: 414, height: 152)
    }
}
