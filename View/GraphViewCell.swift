//
//  GraphViewCell.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 5/07/16.
//  Copyright © 2016 McKay. All rights reserved.
//

import UIKit

class GraphViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var graphicView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        graphicView.backgroundColor = UIColor.clearColor()
        title.textColor = GWMColorYellow
    }
}
