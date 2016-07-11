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
    
    @IBOutlet var cardioLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var hiitLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        graphicView.backgroundColor = UIColor.clearColor()
        title.textColor = GWMColorYellow
        
        cardioLabel.attributedText = generateLabel(GWMPieGraphColorCardio, text: "Cardio")
        weightLabel.attributedText = generateLabel(GWMPieGraphColorWeights, text: "Weights")
        hiitLabel.attributedText = generateLabel(GWMPieGraphColorHiit, text: "Hiit")
        
        cardioLabel.textColor = UIColor.whiteColor()
        weightLabel.textColor = UIColor.whiteColor()
        hiitLabel.textColor = UIColor.whiteColor()
        
    }
    
    func generateLabel(color: UIColor, text: String) -> NSAttributedString{
        //Get image and set it's size
        let newSize = CGSize(width: 20, height: 20)
        let image = getImageWithColor(color, size: newSize)
        
        //Resize image
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let imageResized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Create attachment text with image
        let attachment = NSTextAttachment()
        attachment.image = imageResized
        let attachmentString = NSAttributedString(attachment: attachment)
        let myString = NSMutableAttributedString(string: text+"  ")
        myString.appendAttributedString(attachmentString)
        return myString
    }
    
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
