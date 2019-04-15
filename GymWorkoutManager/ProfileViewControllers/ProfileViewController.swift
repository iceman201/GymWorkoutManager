//
//  ProfileViewController.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 16/5/14.
//  Copyright © 2016年 McKay. All rights reserved.
//

import UIKit
import RealmSwift
import JVFloatLabeledTextField


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    // MARK: - IBOutlet
    @IBOutlet var profilePicture: RoundButton!
    @IBOutlet var headerView: UIView!
    @IBOutlet var name: JVFloatLabeledTextField!
    @IBOutlet var bodyWeight: JVFloatLabeledTextField!
    @IBOutlet var age: JVFloatLabeledTextField!
    @IBOutlet var bodyHeight: JVFloatLabeledTextField!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var viewForAdaptForKeyboard: UIView!
    
    var keyboardIsShown = false
    
    var tapRecognizer: UITapGestureRecognizer? = nil

    //@IBOutlet weak var backgroundScrollView: UIScrollView!
    
    // MARK: - Variables
    var curentUser:Person?
    
    @IBAction func female(_ sender: AnyObject) {
        femaleButton.backgroundColor = GWMColorPurple
        maleButton.backgroundColor = GWMColorYellow
        DatabaseHelper.sharedInstance.beginTransaction()
        curentUser?.sex = "female"
        DatabaseHelper.sharedInstance.commitTransaction()
        let cusers = DatabaseHelper.sharedInstance.queryAll(Person())
        guard let numberOfUser = cusers?.count else {
            return
        }
        checkUser(numberOfUser)
    }
    @IBAction func male(_ sender: AnyObject) {
        maleButton.backgroundColor = GWMColorPurple
        femaleButton.backgroundColor = GWMColorYellow
        DatabaseHelper.sharedInstance.beginTransaction()
        curentUser?.sex = "male"
        DatabaseHelper.sharedInstance.commitTransaction()
        let cusers = DatabaseHelper.sharedInstance.queryAll(Person())
        guard let numberOfUser = cusers?.count else {
            return
        }
        checkUser(numberOfUser)
    }
    
    fileprivate func checkUser(_ numberOfUser:Int) {
        if numberOfUser <= 0 {
            curentUser!.id = UUID.init().uuidString
            DatabaseHelper.sharedInstance.insert(curentUser!)
        }
    }
    
    
    // MARK: Profile Image
    @IBAction func selectPicture(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Profile image", message: "Upload your profile image.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (UIAlertAction) in
            self.popupImageSelection(UIImagePickerController.SourceType.camera)
        }))
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { (UIAlertAction) in
            self.popupImageSelection(UIImagePickerController.SourceType.photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func popupImageSelection(_ type: UIImagePickerController.SourceType) {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = type
        myPickerController.allowsEditing = true
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardDismissRecognizer()
        self.unsubscribeToKeyboardNotifications()
        
        DatabaseHelper.sharedInstance.beginTransaction()
        curentUser?.name = name.text ?? ""
        curentUser?.age = Int(age.text ?? "0") as NSNumber? ?? 0
        curentUser?.weight = bodyWeight.text ?? ""
        curentUser?.height = bodyHeight.text ?? ""
        curentUser?.isProfileDetailsExist = true
        DatabaseHelper.sharedInstance.commitTransaction()
        let cusers = DatabaseHelper.sharedInstance.queryAll(Person())
        guard let numberOfUser = cusers?.count else {
            return
        }
        checkUser(numberOfUser)
        viewForAdaptForKeyboard.frame.origin.y = 0
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.placeholder != name.placeholder {
            return numberEnterOnly(replacementString: string)
        } else {
            return true
        }
    }

    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        
        let imageWithFixedDirection = fixOrientation(image)
        DatabaseHelper.sharedInstance.beginTransaction()
        if let imageSourceData = imageWithFixedDirection.pngData() {
            if curentUser!.profilePicture != nil {
                curentUser!.profilePicture = nil
            }
            profilePicture.setTitle("", for: UIControl.State.normal)
            curentUser!.profilePicture = imageSourceData
            profilePicture.setImage(UIImage(data: imageSourceData), for: UIControl.State())
            
            //profilePicture.setBackgroundImage(UIImage(data: imageSourceData), for: .normal)
        }
        DatabaseHelper.sharedInstance.commitTransaction()
        
        let cusers = DatabaseHelper.sharedInstance.queryAll(Person())
        guard let numberOfUser = cusers?.count else {
            return
        }
        checkUser(numberOfUser)
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func fixOrientation(_ image:UIImage) -> UIImage {
        if (image.imageOrientation == UIImage.Orientation.up) {
            return image
        }
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        image.draw(in: rect)
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return normalizedImage
    }
    
    fileprivate func profilePictureStyleSheet() {
        profilePicture.layer.borderWidth = 1
        profilePicture.backgroundColor = GWMColorPurple
        profilePicture.layer.shadowColor = UIColor.black.cgColor
        profilePicture.layer.shadowOffset = CGSize(width: 0, height: 0)
        profilePicture.layer.shadowRadius = 15
        profilePicture.layer.shadowOpacity = 0.8
    }
    
    // MARK: Navigation Controller
    fileprivate func navigationControllerStyleSheet() {
        self.navigationController?.navigationBar.topItem?.title = "Profile"
        // make the navigation bar edge disappear
        let navBarLineView = UIView(frame: CGRect(x: 0,
            y: (navigationController?.navigationBar.frame)!.height,
            width: (self.navigationController?.navigationBar.frame)!.width,
            height: 1))
        navBarLineView.backgroundColor = GWMColorYellow
        self.navigationController?.navigationBar.addSubview(navBarLineView)

        self.tabBarController?.tabBar.backgroundColor = GWMColorYellow
        self.tabBarController?.tabBar.tintColor = GWMColorPurple
        self.tabBarController?.tabBar.barTintColor = GWMColorYellow
        self.tabBarController?.tabBar.isTranslucent = false
    }
    
    // MARK: textFieldStyleSheet
    fileprivate func setLayer(_ input:JVFloatLabeledTextField) -> CALayer {
        let border = CALayer()
        let width = CGFloat(2.0)
        border.borderColor = GWMColorYellow.cgColor
        border.frame = CGRect(x: 0, y: input.frame.size.height - width, width:  input.frame.size.width, height: input.frame.size.height)
        border.borderWidth = width
        return border
    }
    
    fileprivate func textFieldStyleSheet() {
        name.layer.addSublayer(setLayer(name))
        name.textColor = UIColor.white
        name.layer.masksToBounds = true
        name.delegate = self
        
        bodyWeight.layer.addSublayer(setLayer(bodyWeight))
        bodyWeight.textColor = UIColor.white
        bodyWeight.layer.masksToBounds = true
        bodyWeight.delegate = self
        
        bodyHeight.layer.addSublayer(setLayer(bodyHeight))
        bodyHeight.textColor = UIColor.white
        bodyHeight.layer.masksToBounds = true
        bodyHeight.delegate = self
        
        age.layer.addSublayer(setLayer(age))
        age.textColor = UIColor.white
        age.layer.masksToBounds = true
        age.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if name.isFirstResponder {
            age.becomeFirstResponder()
        } else if age.isFirstResponder {
            bodyHeight.becomeFirstResponder()
        } else if bodyHeight.isFirstResponder {
            bodyWeight.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        return true
    }
    
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePictureStyleSheet()
        navigationControllerStyleSheet()
        textFieldStyleSheet()


        self.view.backgroundColor = GWMColorBackground
        
        /* Configure tap recognizer */
        tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.handleSingleTap(_:)))
        tapRecognizer?.numberOfTapsRequired = 1
        tapRecognizer?.delegate = self
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS {
            self.view.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addKeyboardDismissRecognizer()
        self.subscribeToKeyboardNotifications()
        
        keyboardIsShown = false
        
        profilePicture.imageView?.contentMode = UIView.ContentMode.scaleAspectFill
        profilePicture.imageView?.layer.cornerRadius = 0.5 * profilePicture.bounds.width
        
        let cusers = DatabaseHelper.sharedInstance.queryAll(Person())
        self.navigationController?.navigationBar.topItem?.title = "Profile"
        curentUser = cusers?.first
        if curentUser == nil {
            curentUser = Person()
        }
        
        if let user = curentUser {
            DatabaseHelper.sharedInstance.beginTransaction()
            if let userPicture = user.profilePicture {
                profilePicture.setTitle("", for: UIControl.State.normal)
                profilePicture.setImage(UIImage(data: userPicture as Data), for: UIControl.State())
            }
            name.text = user.name
            bodyHeight.text = user.height
            bodyWeight.text = user.weight
            if case user.age.intValue = 0 {
                return
            } else {
                age.text = "\(user.age)"

            }
            if user.sex == "male" {
                maleButton.backgroundColor = GWMColorPurple
                femaleButton.backgroundColor = GWMColorYellow
            } else if user.sex == "female" {
                femaleButton.backgroundColor = GWMColorPurple
                maleButton.backgroundColor = GWMColorYellow
            }
            
            DatabaseHelper.sharedInstance.commitTransaction()
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - ProfileViewController (Show/Hide Keyboard)

extension ProfileViewController:UIGestureRecognizerDelegate {
    
    
    func addKeyboardDismissRecognizer() {
        print("add keyboard dissmiss recognizer")
        view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        view.removeGestureRecognizer(tapRecognizer!)
    }
    
    @objc func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view {
            if view is UIButton{
                return false
            }
        }
        return true
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Foundation.Notification) {
        print("keyboard will show")
        print("height is " + String(describing: getKeyboardHeight(notification)/2))
        print("view frame origin y is " + String(describing: view.frame.origin.y))
        if(!keyboardIsShown){
            view.frame.origin.y -= getKeyboardHeight(notification) / 2
        }
        keyboardIsShown = true
    }

    
    @objc func keyboardWillHide(_ notification: Foundation.Notification) {
        print("keyboard will hide")
        view.frame.origin.y = 0.0
        keyboardIsShown = false
    }
    
    func getKeyboardHeight(_ notification: Foundation.Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
}
