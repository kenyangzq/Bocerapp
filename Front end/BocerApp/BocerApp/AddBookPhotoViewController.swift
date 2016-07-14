//
//  AddBookPhotoViewController.swift
//  BocerApp
//
//  Created by Dempsy on 7/13/16.
//  Copyright © 2016 Dempsy. All rights reserved.
//

import UIKit

protocol  ChangeBookImagesDelegate:NSObjectProtocol {
    func changeImage(controller: AddBookPhotoViewController, frontimage:UIImage, backimage:UIImage, sideimage: UIImage)
}

class AddBookPhotoViewController: UIViewController, ChangeImageDelegate {

    enum photoPos: Int {
        case none = 0, front = 1, back = 2,side = 3
    }
    @IBOutlet private weak var frontIV: UIImageView!
    @IBOutlet private weak var backIV: UIImageView!
    @IBOutlet private weak var sideIV: UIImageView!
    @IBOutlet private weak var frontBtn: UIButton!
    @IBOutlet private weak var backBtn: UIButton!
    @IBOutlet private weak var sideBtn: UIButton!
    private var mNavBar: UINavigationBar!
    private var mImage = UIImage?()
    private var mImagePos = photoPos(rawValue: 0)
    var delegate : ChangeBookImagesDelegate?
    var frontImage: UIImage?
    var backImage: UIImage?
    var sideImage: UIImage?
    
    @IBAction private func frontFired(sender: UIButton) {
        mImagePos = .front
        presentView(frontIV.image)
        //网络获取大图片资源
    }
    
    @IBAction private func backFired(sender: UIButton) {
        mImagePos = .back
        presentView(backIV.image)
        //TODO: 网络获取图片资源
    }
    
    @IBAction private func sideFired(sender: UIButton) {
        mImagePos = .side
        presentView(sideIV.image)
        //TODO: 网络获取大图片
    }
    
    private func presentView(image: UIImage?) {
        print("go to add book photo picker")
        let sb = UIStoryboard(name: "MainInterface", bundle: nil);
        let vc = sb.instantiateViewControllerWithIdentifier("AddBookPhotoPickerViewController") as! AddBookPhotoPickerViewController
        vc.delegate = self
        vc.image = image
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
//    @objc func getPresentImage(notification: NSNotification) {
//        let userInfo = notification.userInfo as! [String: AnyObject]
//        print("user info is \(userInfo)")
//        mImage = userInfo["newphoto"] as? UIImage
//    }
    
    func changeImage(controller: AddBookPhotoPickerViewController, image: UIImage) {
        mImage = image
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        if mImagePos != .none {
//    
//            print("\(mImage)")
//
//            NSNotificationCenter.defaultCenter().removeObserver(self, name: "NewPhotoForBook", object: nil)
//            NSNotificationCenter.defaultCenter().removeObserver(self)
//        }
        if mImagePos == .front {
            frontIV.image = mImage
            frontBtn.setTitle(nil, forState: .Normal)
            frontBtn.backgroundColor = UIColor(white: 1, alpha: 0)
        } else if mImagePos == .back {
            backIV.image = mImage
            backBtn.setTitle(nil, forState: .Normal)
            backBtn.backgroundColor = UIColor(white: 1, alpha: 0)
        } else if mImagePos == .side {
            sideBtn.setTitle(nil, forState: .Normal)
            sideBtn.backgroundColor = UIColor(white: 1, alpha: 0)
            sideIV.image = mImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let screenMaxX = UIScreen.mainScreen().bounds.maxX
        mNavBar = UINavigationBar(frame: CGRectMake(0,0,screenMaxX,54))
        mNavBar?.translucent = true
        mNavBar?.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        mNavBar?.shadowImage = UIImage()
        mNavBar?.backgroundColor = UIColor(red: 0/255, green: 128/255, blue: 128/255, alpha: 1)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        
        let navTitleAttribute: NSDictionary = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName)
        mNavBar?.titleTextAttributes = navTitleAttribute as? [String : AnyObject]
        
        self.view.addSubview(mNavBar!)
        mNavBar?.pushNavigationItem(onMakeNavitem(), animated: true)
        
        frontIV.image = frontImage
        backIV.image = backImage
        sideIV.image = sideImage
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func onMakeNavitem()->UINavigationItem{
        let backBtn = UIBarButtonItem(title: "ㄑBack", style: .Plain,
                                      target: self, action: #selector(AddBookPhotoViewController.onCancel))
        backBtn.tintColor = UIColor.whiteColor()
                let doneBtn = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(AddBookPhotoViewController.onDone))
                doneBtn.tintColor = UIColor.whiteColor()
        let mNavItem = UINavigationItem()
        mNavItem.title = "SIGN IN"
        mNavItem.setLeftBarButtonItem(backBtn, animated: true)
        mNavItem.setRightBarButtonItem(doneBtn, animated: true)
        return mNavItem
    }
    
    @objc private func onDone() {
        
        if frontIV.image == nil {
            let alertController = UIAlertController(title: "Warning",
                                                    message: "You need to upload a front photo for the book you want to sell.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        if backIV.image == nil {
            let alertController = UIAlertController(title: "Warning",
                                                    message: "You need to upload a back photo for the book you want to sell.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        if sideIV.image == nil {
            let alertController = UIAlertController(title: "Warning",
                                                    message: "You need to upload a side photo for the book you want to sell.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        print("delegate is \(delegate)")
        if ((delegate) != nil) {
            let fImage = frontIV.image!
            let bImage = backIV.image!
            let sImage = sideIV.image!
            delegate?.changeImage(self, frontimage: fImage, backimage: bImage, sideimage: sImage)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @objc private func onCancel() {
        self.navigationController?.popViewControllerAnimated(true)
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
        // 将图片写入文件
        imageData.writeToFile(fullPath, atomically: false)
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
