//
//  ProfileViewController.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 16/5/14.
//  Copyright © 2016年 McKay. All rights reserved.
//

import UIKit
import RealmSwift

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet var profilePicture: RoundButton!
    @IBOutlet var headerView: UIView!
    var Cuser:Person?
    
    @IBAction func selectPicture(sender: AnyObject) {
        let alert = UIAlertController(title: "Profile image", message: "Upload your profile image.", preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { (UIAlertAction) in
            //open camera
        }))
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .Default, handler: { (UIAlertAction) in
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            self.presentViewController(myPickerController, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        DatabaseHelper.sharedInstance.beginTransaction()
        //Write into Realm
        if let imageSourceData = UIImagePNGRepresentation(image!) {
            if Cuser!.profilePicture != nil {
                Cuser!.profilePicture = nil
            }
            Cuser!.profilePicture = imageSourceData
        }
        //设置Image data
        let sizedImage = resizeToAspectFit(profilePicture.frame.size, bounds: profilePicture.bounds, sourceImage: UIImage(data: Cuser!.profilePicture!)!)
        profilePicture.backgroundColor = UIColor(patternImage: sizedImage)
        profilePicture.setTitle("", forState: .Normal)

        DatabaseHelper.sharedInstance.commitTransaction()
        let cusers = DatabaseHelper.sharedInstance.queryAll(Person())
        if cusers?.count <= 0 {
            Cuser!.id = NSUUID.init().UUIDString
            DatabaseHelper.sharedInstance.insert(Cuser!)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = resizeToAspectFit(headerView.frame.size,bounds: headerView.bounds, sourceImage: UIImage(named: "profileHeader.png")!)
        self.headerView.backgroundColor = UIColor(patternImage: image)
        
        profilePictureStyleSheet()
        navigationControllerStyleSheet()
        
        let cusers = DatabaseHelper.sharedInstance.queryAll(Person())
        Cuser = cusers?.first
        if Cuser == nil {
            Cuser = Person()
        }
        // 这里应该是去read from realm读Image data
        if Cuser!.profilePicture != nil {
            DatabaseHelper.sharedInstance.beginTransaction()
            let sizedImage = resizeToAspectFit(profilePicture.frame.size, bounds: profilePicture.bounds, sourceImage: UIImage(data: Cuser!.profilePicture!)!)
            profilePicture.backgroundColor = UIColor(patternImage: sizedImage)
            profilePicture.setTitle("", forState: .Normal)
            DatabaseHelper.sharedInstance.commitTransaction()
        }
        
    }
    
    private func resizeToAspectFit(viewSize: CGSize, bounds: CGRect, sourceImage: UIImage) -> UIImage {
        UIGraphicsBeginImageContext(viewSize)
        sourceImage.drawInRect(bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    private func profilePictureStyleSheet() {
        profilePicture.layer.borderWidth = 3
        profilePicture.backgroundColor = GWMColorPurple
        profilePicture.layer.shadowColor = UIColor.blackColor().CGColor
        profilePicture.layer.shadowOffset = CGSize(width: 0, height: 0)
        profilePicture.layer.shadowRadius = 15
        profilePicture.layer.shadowOpacity = 0.8
    }
    
    private func navigationControllerStyleSheet() {
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = GWMColorYellow
        self.navigationController?.navigationBar.topItem?.title = "Profile"
        
        let navBarLineView = UIView(frame: CGRectMake(0,
            CGRectGetHeight((navigationController?.navigationBar.frame)!),
            CGRectGetWidth((self.navigationController?.navigationBar.frame)!),
            1))
        
        navBarLineView.backgroundColor = GWMColorYellow
        
        self.navigationController?.navigationBar.addSubview(navBarLineView)
        self.navigationController?.navigationBar.tintColor = GWMColorPurple
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : GWMColorPurple]
        self.tabBarController?.tabBar.backgroundColor = GWMColorYellow
        self.tabBarController?.tabBar.tintColor = GWMColorPurple
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
