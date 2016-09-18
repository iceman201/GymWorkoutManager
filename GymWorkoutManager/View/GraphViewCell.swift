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
        graphicView.backgroundColor = UIColor.clear
        title.textColor = GWMColorYellow
        
        cardioLabel.attributedText = generateLabel(GWMPieGraphColorCardio, text: "Cardio")
        weightLabel.attributedText = generateLabel(GWMPieGraphColorWeights, text: "Weights")
        hiitLabel.attributedText = generateLabel(GWMPieGraphColorHiit, text: "Hiit")
        
        cardioLabel.textColor = UIColor.white
        weightLabel.textColor = UIColor.white
        hiitLabel.textColor = UIColor.white
        
    }
    
    func generateLabel(_ color: UIColor, text: String) -> NSAttributedString{
        //Get image and set it's size
        let newSize = CGSize(width: 20, height: 20)
        let image = getImageWithColor(color, size: newSize)
        
        //Resize image
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let imageResized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Create attachment text with image
        let attachment = NSTextAttachment()
        attachment.image = imageResized
        let attachmentString = NSAttributedString(attachment: attachment)
        let myString = NSMutableAttributedString(string: text+"  ")
        myString.append(attachmentString)
        return myString
    }
    
    func getImageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
