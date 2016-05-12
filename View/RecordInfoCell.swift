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
    
    @IBOutlet weak var age: UILabel!
    
    @IBOutlet weak var weight: UILabel!
    
    @IBOutlet weak var activeDay: UILabel!
    
    @IBOutlet weak var lastTimeWorkout: UILabel!
    
    @IBOutlet weak var effectiveIndex: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.blueColor()
    }
    override func intrinsicContentSize() -> CGSize {
        return CGSize(width: 414, height: 152)
    }
}
