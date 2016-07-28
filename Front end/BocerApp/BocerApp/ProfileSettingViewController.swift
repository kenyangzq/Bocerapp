//
//  ProfileSettingViewController.swift
//  BocerApp
//
//  Created by Dempsy on 7/11/16.
//  Copyright © 2016 Dempsy. All rights reserved.
//

import UIKit

class ProfileSettingViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

//    @IBOutlet private weak var photoIV: UIImageView!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
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
    private let imagePickerController = UIImagePickerController()
    private let smallAvatarImage = "/smallAvatarImage"
    private var isFullScreen = false
    private let imageConvertion = UIImageConvertion()
    private var dataChunk = NSMutableData()
    private var imagebody = NSData()
    
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
    
    private func cancelHandler(alert: UIAlertAction!) {
        self.presentedViewController?.dismissViewControllerAnimated(false, completion: nil)
    }
    
    private func takePhotoHandler(alert: UIAlertAction!) {
        if UIImagePickerController.isSourceTypeAvailable(.Camera){
            //设置代理
            imagePickerController.delegate = self
            //设置来源
            imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
            //允许编辑
            imagePickerController.allowsEditing = true
            //打开相机
            self.presentViewController(self.imagePickerController, animated: true, completion: { () -> Void in
            })
        }else{
            print("找不到相机")
        }
    }
    
    private func choosePhotoHandler(alert: UIAlertAction!) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.imagePickerController.navigationBar.barTintColor = UIColor(red: 0, green: 128/255, blue: 128/255, alpha: 1)
        let navTitleAttribute: NSDictionary = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName)
        self.imagePickerController.navigationBar.titleTextAttributes = navTitleAttribute as? [String: AnyObject]
        self.imagePickerController.navigationBar.tintColor = UIColor.whiteColor()
        self.presentViewController(self.imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        picker.allowsEditing = true
        var image: UIImage!
        if picker.allowsEditing {
            image = info[UIImagePickerControllerEditedImage] as! UIImage
        } else {
            image = info[UIImagePickerControllerOriginalImage] as! UIImage
        }
        /* 此处info 有六个值
         * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
         * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
         * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
         * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
         * UIImagePickerControllerMediaURL;       // an NSURL
         * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
         * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
         */
        uploadAvatar(userInfo.getEmail()!,image: image)
//        self.saveImage(image, newSize: CGSize(width: 150, height: 150), percent: 0.5, imageName: smallAvatarImage)
//        
//        let savedImage: UIImage = UIImage(contentsOfFile: someConstants.fullAvatarPath)!
//        self.isFullScreen = false
//        avatarIV.image = savedImage
//        let smallImageConvertion = imageConvertion.imageToString(UIImage(contentsOfFile: someConstants.smallAvatarPath)!)

//        print("small pic string is \(smallImageConvertion)")
        //在这里调用网络通讯方法，上传头像至服务器...
        
    }
    
    @IBAction func changePhotoFired(sender: UIButton) {
//        let sb = UIStoryboard(name: "MainInterface", bundle: nil);
//        let vc = sb.instantiateViewControllerWithIdentifier("AvatarPresentViewController") as UIViewController
//        self.navigationController?.pushViewController(vc, animated: true)
        self.imagePickerController.delegate = self
        self.imagePickerController.allowsEditing = true
        let alertController = UIAlertController(title: nil, message: nil,
                                                preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelHandler)
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .Default, handler: takePhotoHandler)
        let choosePhotoAction = UIAlertAction(title: "Choose from Photos", style: .Default, handler: choosePhotoHandler)
        alertController.addAction(cancelAction)
        alertController.addAction(takePhotoAction)
        alertController.addAction(choosePhotoAction)
        self.presentViewController(alertController, animated: true, completion: nil)
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
    
    private func uploadAvatar(username:String, image: UIImage) {
        let newSize = CGSize(width: 150, height: 150)
        imagebody = compressImage(image, newSize: newSize, percent: 0.5)
        let dataString = NSString.localizedStringWithFormat("{\"username\":\"%@\",\"imagebody\":\"%@\"}",username,imagebody)
        let sent = NSData(data: dataString.dataUsingEncoding(NSASCIIStringEncoding)!)
        let dataLength = NSString.localizedStringWithFormat("%ld", sent.length)
        let path = usefulConstants().domainAddress + "/addUserSmallImage"
        let url = NSURL(string: path)
        print("login request address: \(path)\n")
        let request = NSMutableURLRequest()
        request.URL = url
        request.HTTPMethod = "POST"
        request.setValue(dataLength as String, forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = sent
        indicator.alpha = 1
        indicator.startAnimating()
        
        let conn = NSURLConnection(request: request, delegate: self, startImmediately: true)

        if (conn == nil) {
            let alertController = UIAlertController(title: "Warning",
                                                    message: "Connection Failure.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }

    }
    
    
    //压缩图片
    func compressImage(currentImage: UIImage, newSize: CGSize, percent: CGFloat) -> NSData{
        //压缩图片尺寸
        UIGraphicsBeginImageContext(newSize)
        currentImage.drawInRect(CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //高保真压缩图片质量
        //UIImageJPEGRepresentation此方法可将图片压缩，但是图片质量基本不变，第二个参数即图片质量参数。
        let imageData: NSData = UIImagePNGRepresentation(newImage)!
//        print("\(imageData)")
//        let imageNSString = NSString(data: imageData, encoding: NSUTF8StringEncoding)
//        print("\(imageNSString)")
//        let imageString = imageNSString as! String
//        print("\(imageString)")
        return imageData
        //        // 获取沙盒目录,这里将图片放在沙盒的documents文件夹中
        //        let fullPath: String = NSHomeDirectory().stringByAppendingString("/Documents").stringByAppendingString(imageName)
        //        // 将图片写入文件
        //        imageData.writeToFile(fullPath, atomically: false)
    }
    
    //保存图片
    func saveImage(currentImage: UIImage, newSize: CGSize, percent: CGFloat, imageName: String){
        //压缩图片尺寸
        UIGraphicsBeginImageContext(newSize)
        currentImage.drawInRect(CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //高保真压缩图片质量
        //UIImageJPEGRepresentation此方法可将图片压缩，但是图片质量基本不变，第二个参数即图片质量参数。
        let imageData: NSData = UIImagePNGRepresentation(newImage)!
        // 获取沙盒目录,这里将图片放在沙盒的documents文件夹中
        let fullPath: String = NSHomeDirectory().stringByAppendingString("/Documents").stringByAppendingString(imageName)
        // 将图片写入文件
        imageData.writeToFile(fullPath, atomically: false)
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        dataChunk = NSMutableData()
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        dataChunk.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        print("datachunk is \(dataChunk)")
        let backmsg: AnyObject! = try! NSJSONSerialization.JSONObjectWithData(dataChunk, options: NSJSONReadingOptions(rawValue: 0))
        let targetAction = backmsg.objectForKey("Target Action") as! String?
        let content = backmsg.objectForKey("content") as! String?
        indicator.stopAnimating()
        indicator.alpha = 0
        
        print("back message is \(backmsg)")
        //普通登录
        if targetAction == "addusersmallimageresult" {
            if content == "success" {
                //更改头像，保存头像
                avatarIV.image = UIImage(data: imagebody)
                saveImage(avatarIV.image!, newSize: CGSize(width: 150,height: 150), percent: 1, imageName: smallAvatarImage)
                print("upload avatar success\n")
            }
            else if content == "system error" {
                let alertController = UIAlertController(title: "Warning",
                                                        message: "Connection Failure", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
                print("Change avatar failed")
            } else {
                let alertController = UIAlertController(title: "Warning",
                                                        message: "Connection Failure.", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
                print("connection fails when trying email login")
            }
        } else {
            let alertController = UIAlertController(title: "Warning",
                                                    message: "Server Issues.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            
            print("unexpected server issues\n")
        }
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        NSLog("%@", error)
        indicator.stopAnimating()
        indicator.alpha = 0
        let alertController = UIAlertController(title: "Warning",
                                                message: "Connection Failure.", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        NSLog("connection failed")
        
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
