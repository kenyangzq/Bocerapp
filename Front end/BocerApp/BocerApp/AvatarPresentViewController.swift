//
//  avatarPresentViewController.swift
//  BocerApp
//
//  Created by Dempsy on 6/28/16.
//  Copyright © 2016 Dempsy. All rights reserved.
//

import UIKit

class AvatarPresentViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    @IBOutlet private weak var avatarIV: UIImageView!
    let fullAvatarImage = "/fullAvatarImage"
    let smallAvatarImage = "/smallAvatarImage"
    private var mNavBar: UINavigationBar?
    private let base = baseClass()
    private var isFullScreen = false
    //创建图片控制器
    private let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let screenMaxX = UIScreen.mainScreen().bounds.maxX
        mNavBar = UINavigationBar(frame: CGRectMake(0,0,screenMaxX,54))
        mNavBar?.translucent = true
        mNavBar?.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        mNavBar?.shadowImage = UIImage()
        mNavBar?.backgroundColor = UIColor(red: 0/255, green: 128/255, blue: 128/255, alpha: 1)
        
        let navTitleAttribute: NSDictionary = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName)
        mNavBar?.titleTextAttributes = navTitleAttribute as? [String : AnyObject]
        
        self.view.addSubview(mNavBar!)
        mNavBar?.pushNavigationItem(onMakeNavitem(), animated: true)
    }
    
    @objc private func onCancel(){
        self.navigationController?.popViewControllerAnimated(true)
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
            self.presentViewController(imagePickerController, animated: true, completion: { () -> Void in
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
        self.saveImage(image, newSize: CGSize(width: 256, height: 256), percent: 0.5, imageName: fullAvatarImage)
        self.saveImage(image, newSize: CGSize(width: 90, height: 90), percent: 0.5, imageName: smallAvatarImage)
        let fullPath: String = NSHomeDirectory().stringByAppendingString("/Documents").stringByAppendingString(fullAvatarImage)
        print("fullpath is \(fullPath)")
        let savedImage: UIImage = UIImage(contentsOfFile: fullPath)!
        self.isFullScreen = false
        avatarIV.image = savedImage
        //在这里调用网络通讯方法，上传头像至服务器...
        
    }
    
    //保存图片至沙盒
    func saveImage(currentImage: UIImage, newSize: CGSize, percent: CGFloat, imageName: String){
        //压缩图片尺寸
        UIGraphicsBeginImageContext(newSize)
        currentImage.drawInRect(CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //高保真压缩图片质量
        //UIImageJPEGRepresentation此方法可将图片压缩，但是图片质量基本不变，第二个参数即图片质量参数。
        let imageData: NSData = UIImageJPEGRepresentation(newImage, percent)!
        // 获取沙盒目录,这里将图片放在沙盒的documents文件夹中
        let fullPath: String = NSHomeDirectory().stringByAppendingString("/Documents").stringByAppendingString(imageName)
        print("fullpath in saveImage function is \(fullPath)\n")
        // 将图片写入文件
        imageData.writeToFile(fullPath, atomically: false)
     }
    
    @objc private func onMore(){
        self.imagePickerController.delegate = self
        self.imagePickerController.allowsEditing = true
        let alertController = UIAlertController(title: nil, message: nil,
                                                preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelHandler)
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .Default, handler: takePhotoHandler)
        let choosePhotoAction = UIAlertAction(title: "Choose from Photos", style: .Default, handler: choosePhotoHandler)
        let archiveAction = UIAlertAction(title: "Save Photo", style: .Default, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(takePhotoAction)
        alertController.addAction(choosePhotoAction)
        alertController.addAction(archiveAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //创建一个导航项
    private func onMakeNavitem()->UINavigationItem{
        let navigationItem = UINavigationItem()
        let backBtn = UIBarButtonItem(title: "ㄑBack", style: .Plain,
                                      target: self, action: #selector(AvatarPresentViewController.onCancel))
        backBtn.tintColor = UIColor.whiteColor()
        let rightBtn = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(AvatarPresentViewController.onMore))
        rightBtn.tintColor = UIColor.whiteColor()
        navigationItem.title = "PHOTO"
        navigationItem.setLeftBarButtonItem(backBtn, animated: true)
        navigationItem.setRightBarButtonItem(rightBtn, animated: true)
        navigationItem.setHidesBackButton(false, animated: true)
        return navigationItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
