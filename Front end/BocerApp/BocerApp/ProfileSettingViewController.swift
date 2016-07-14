//
//  ProfileSettingViewController.swift
//  BocerApp
//
//  Created by Dempsy on 7/11/16.
//  Copyright © 2016 Dempsy. All rights reserved.
//

import UIKit

class ProfileSettingViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet private weak var photoIV: UIImageView!
    @IBOutlet private weak var changePhotoBtn: UIButton!
    @IBOutlet private weak var firstNameTF: MinoruTextField!
    @IBOutlet private weak var lastNameTF: MinoruTextField!
    @IBOutlet private weak var emailTF: MinoruTextField!
    @IBOutlet private weak var phoneTF: MinoruTextField!
    private var mNavBar: UINavigationBar?
    private var avatarIV: UIImageView = UIImageView(image: UIImage())
    private let userInfo = UserInfo()
    private let someConstants = usefulConstants()
    private var firstName: String?
    private var lastName: String?
    private var email: String?
    private var phoneNumber: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //设置导航栏
        let screenMaxX = UIScreen.mainScreen().bounds.maxX
        mNavBar = UINavigationBar(frame: CGRectMake(0,0,screenMaxX,54))
        mNavBar?.translucent = true
        mNavBar?.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        mNavBar?.shadowImage = UIImage()
        mNavBar?.backgroundColor = usefulConstants().defaultColor
        
        //设置状态栏颜色
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        let navTitleAttribute: NSDictionary = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName)
        mNavBar?.titleTextAttributes = navTitleAttribute as? [String : AnyObject]
        
        self.view.addSubview(mNavBar!)
        mNavBar?.pushNavigationItem(onMakeNavitem(), animated: true)
        
        //set a image view for avatar
        let avatarLocalString = userInfo.getImageString()
        var avatarImage: UIImage? = nil
        if avatarLocalString == nil {
            avatarImage = UIImage(contentsOfFile: someConstants.smallAvatarPath)
        } else {
            avatarImage = UIImage(contentsOfFile: avatarLocalString!)!
        }
        if avatarImage != nil {
            let frame = CGRect(x: 30, y: 82, width: 56, height: 56)
            avatarIV = UIImageView(frame: frame)
            avatarIV.image = avatarImage
            avatarIV.layer.cornerRadius = 28
        }
        self.view.addSubview(avatarIV)
        
        changePhotoBtn.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).CGColor
        changePhotoBtn.layer.borderWidth = 1
        
        //customize text field
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        emailTF.delegate = self
        phoneTF.delegate = self
        
        firstNameTF.placeholderColor = .darkGrayColor()
        lastNameTF.placeholderColor = .darkGrayColor()
        emailTF.placeholderColor = .darkGrayColor()
        phoneTF.placeholderColor = .darkGrayColor()
        
        
        (firstName, lastName) = userInfo.getName()
        email = userInfo.getEmail()
        phoneNumber = userInfo.getPhoneNumber()
        
        firstNameTF.text = someConstants.defaultFirstName
        if firstName != nil {
            firstNameTF.text = firstName!
        }
        
        lastNameTF.text = someConstants.defaultLastName
        if lastName != nil {
            lastNameTF.text = lastName
        }
        
        emailTF.text = someConstants.defaultEmail
        if email != nil {emailTF.text = email}
        
        if phoneNumber == nil {phoneNumber = someConstants.defaultPhoneNumber}
        phoneNumber?.adjustPhoneNumber()
        phoneTF.text = phoneNumber
        
        firstNameTF.animateViewsForTextDisplay()
        lastNameTF.animateViewsForTextDisplay()
        emailTF.animateViewsForTextDisplay()
        phoneTF.animateViewsForTextDisplay()
        
    }
    
    //创建一个导航项
    private func onMakeNavitem()->UINavigationItem{
        let backBtn = UIBarButtonItem(title: "ㄑBack", style: .Plain,
                                      target: self, action: #selector(ProfileSettingViewController.onCancel))
        backBtn.tintColor = UIColor.whiteColor()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(ProfileSettingViewController.onDone))
        doneBtn.tintColor = UIColor.whiteColor()
        let mNavItem = UINavigationItem()
        mNavItem.title = "SIGN IN"
        mNavItem.setLeftBarButtonItem(backBtn, animated: true)
        mNavItem.setRightBarButtonItem(doneBtn, animated: true)
        return mNavItem
    }
    
    @objc private func onDone() {
        userInfo.setEmail(email!)
        userInfo.setName(firstName!, mLast: lastName!)
        userInfo.setPhoneNumber(phoneNumber!)
        self.navigationController?.popViewControllerAnimated(true)
    }

    @objc private func onCancel() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func resignKeyboards() {
        firstName = firstNameTF.text
        lastName = lastNameTF.text
        email = emailTF.text
        phoneNumber = phoneTF.text
        firstNameTF.resignFirstResponder()
        lastNameTF.resignFirstResponder()
        emailTF.resignFirstResponder()
        phoneTF.resignFirstResponder()
        phoneTF.text?.adjustPhoneNumber()
        firstNameTF.animateViewsForTextDisplay()
        lastNameTF.animateViewsForTextDisplay()
        emailTF.animateViewsForTextDisplay()
        phoneTF.animateViewsForTextDisplay()
    }
    
    @IBAction func viewClicked(sender: AnyObject) {
        resignKeyboards()
    }
    
    @IBAction func changePhotoFired(sender: UIButton) {
        let sb = UIStoryboard(name: "MainInterface", bundle: nil);
        let vc = sb.instantiateViewControllerWithIdentifier("AvatarPresentViewController") as UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == phoneTF {
            phoneTF.text = phoneNumber
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        resignFirstResponder()
        switch textField {
        case firstNameTF:
            firstNameTF.animateViewsForTextDisplay()
            firstName = firstNameTF.text
            lastNameTF.becomeFirstResponder()
            break
        case lastNameTF:
            lastNameTF.animateViewsForTextDisplay()
            lastName = lastNameTF.text
            emailTF.becomeFirstResponder()
            break
        case emailTF:
            emailTF.animateViewsForTextDisplay()
            email = emailTF.text
            phoneTF.becomeFirstResponder()
            break
        case phoneTF:
            phoneTF.animateViewsForTextDisplay()
            phoneNumber = phoneTF.text
            phoneTF.text?.adjustPhoneNumber()
//            nextBtnPerformed()
            break
        default:
            break
        }
        return true
    }
    
    //键盘->屏幕滑动
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //update avatar
        let avatarLocalString = userInfo.getImageString()
        avatarIV.removeFromSuperview()
        var avatarImage: UIImage? = nil
        if avatarLocalString == nil {
            avatarImage = UIImage(contentsOfFile: someConstants.smallAvatarPath)
        } else {
            avatarImage = UIImage(contentsOfFile: avatarLocalString!)!
        }
        if avatarImage != nil {
            let frame = CGRect(x: 30, y: 82, width: 56, height: 56)
            avatarIV = UIImageView(frame: frame)
            avatarIV.image = avatarImage
            avatarIV.layer.cornerRadius = 28
        }
        self.view.addSubview(avatarIV)
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileSettingViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProfileSettingViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //Bugfix- July, 6th. Dempsy
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        
    }
    
    @objc private func keyboardWillShow(notification:NSNotification){
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()) != nil {
            //let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            //let keyboardheight  = keyboardSize.height as CGFloat
            //let frame = self.nameInput.frame
            // frame.origin.y = frame.origin.y - keyboardheight
            //var offset = 156 as CGFloat
            var viewDisplacement: CGFloat
            let width = self.view.frame.size.width;
            let height = self.view.frame.size.height;
            if (firstNameTF.isFirstResponder() || lastNameTF.isFirstResponder()) {
                viewDisplacement = 0
            } else {
                let keyboardinfo = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]
                let keyboardheight:CGFloat = (keyboardinfo?.CGRectValue.size.height)!
                viewDisplacement = height - 420 - keyboardheight
                //Bugfix - 在6s及其他大屏上的屏幕向下滑动问题
                if viewDisplacement > 0 {viewDisplacement = 0}
            }
            let rect = CGRectMake(0.0, viewDisplacement,width,height);
            self.view.frame = rect
        }
    }
    
    @objc private func keyboardWillHide(notification:NSNotification){
        let width = self.view.frame.size.width;
        let height = self.view.frame.size.height;
        let rect = CGRectMake(0.0, 0,width,height);
        self.view.frame = rect
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
