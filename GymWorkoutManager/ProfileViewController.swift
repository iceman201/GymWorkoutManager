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
    // MARK: - IBOutlet
    @IBOutlet var profilePicture: RoundButton!
    @IBOutlet var headerView: UIView!
    // MARK: - Variables
    var curentUser:Person?
    
    // MARK: Profile Image
    @IBAction func selectPicture(sender: AnyObject) {
        let alert = UIAlertController(title: "Profile image", message: "Upload your profile image.", preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { (UIAlertAction) in
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = UIImagePickerControllerSourceType.Camera
            myPickerController.allowsEditing = true
            self.presentViewController(myPickerController, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .Default, handler: { (UIAlertAction) in
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            myPickerController.allowsEditing = true
            self.presentViewController(myPickerController, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let i = info[UIImagePickerControllerOriginalImage] as? UIImage
        let image = fixOrientation(i!)
        DatabaseHelper.sharedInstance.beginTransaction()
        if let imageSourceData = UIImagePNGRepresentation(image) {
            if curentUser!.profilePicture != nil {
                curentUser!.profilePicture = nil
            }
            curentUser!.profilePicture = imageSourceData
        }
        let sizedImage = resizeToAspectFit(profilePicture.frame.size, bounds: profilePicture.bounds, sourceImage: UIImage(data: curentUser!.profilePicture!)!)
        profilePicture.backgroundColor = UIColor(patternImage: sizedImage)
        profilePicture.setTitle("", forState: .Normal)

        DatabaseHelper.sharedInstance.commitTransaction()
        let cusers = DatabaseHelper.sharedInstance.queryAll(Person())
        if cusers?.count <= 0 {
            curentUser!.id = NSUUID.init().UUIDString
            DatabaseHelper.sharedInstance.insert(curentUser!)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func fixOrientation(image:UIImage) -> UIImage {
        if (image.imageOrientation == UIImageOrientation.Up) {
            return image
        }
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        image.drawInRect(rect)
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImage
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
    
    // MARK: Navigation Controller
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
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image = resizeToAspectFit(headerView.frame.size,bounds: headerView.bounds, sourceImage: UIImage(named: "profileHeader.png")!)
        self.headerView.backgroundColor = UIColor(patternImage: image)
        
        profilePictureStyleSheet()
        navigationControllerStyleSheet()
        
        let cusers = DatabaseHelper.sharedInstance.queryAll(Person())
        curentUser = cusers?.first
        if curentUser == nil {
            curentUser = Person()
        }
        if curentUser!.profilePicture != nil {
            DatabaseHelper.sharedInstance.beginTransaction()
            let sizedImage = resizeToAspectFit(profilePicture.frame.size, bounds: profilePicture.bounds, sourceImage: UIImage(data: curentUser!.profilePicture!)!)
            profilePicture.backgroundColor = UIColor(patternImage: sizedImage)
            profilePicture.setTitle("", forState: .Normal)
            DatabaseHelper.sharedInstance.commitTransaction()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
