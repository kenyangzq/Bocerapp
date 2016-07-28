//
//  AddBookViewController.swift
//  BocerApp
//
//  Created by Dempsy on 7/13/16.
//  Copyright © 2016 Dempsy. All rights reserved.
//

import UIKit

class AddBookViewController: UIViewController, UITextFieldDelegate, ChangeBookImagesDelegate {

    @IBOutlet private weak var captionTF: MinoruTextField!
    @IBOutlet private weak var editionTF: MinoruTextField!
    @IBOutlet private weak var authorTF: MinoruTextField!
    @IBOutlet private weak var isbnTF: MinoruTextField!
    @IBOutlet private weak var priceTF: MinoruTextField!
    @IBOutlet private weak var frontIV: UIImageView!
    @IBOutlet private weak var backIV: UIImageView!
    @IBOutlet private weak var sideIV: UIImageView!

//    @IBOutlet private weak var descrpitionTF: MinoruTextField!
    @IBOutlet private weak var addPhtoBtn: UIButton!
    private var mNavBar: UINavigationBar?

    @IBAction func viewClick(sender: AnyObject) {
        resignKeyboards()
    }
    
    @IBAction func addBtnFired(sender: UIButton) {
        
        let sb = UIStoryboard(name: "MainInterface", bundle: nil);
        let vc = sb.instantiateViewControllerWithIdentifier("AddBookPhotoViewController") as! AddBookPhotoViewController
        vc.delegate = self
        vc.frontImage = frontIV.image
        vc.backImage = backIV.image
        vc.sideImage = sideIV.image
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
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
        
        //customize text field
        captionTF.delegate = self
        editionTF.delegate = self
        authorTF.delegate = self
        isbnTF.delegate = self
        priceTF.delegate = self
//        descrpitionTF.delegate = self
    
        captionTF.placeholderColor = .darkGrayColor()
        editionTF.placeholderColor = .darkGrayColor()
        authorTF.placeholderColor = .darkGrayColor()
        isbnTF.placeholderColor = .darkGrayColor()
        priceTF.placeholderColor = .darkGrayColor()
//        descrpitionTF.placeholderColor = .darkGrayColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func onMakeNavitem()->UINavigationItem{
        let backBtn = UIBarButtonItem(title: "ㄑBack", style: .Plain,
                                      target: self, action: #selector(AddBookViewController.onCancel))
        backBtn.tintColor = UIColor.whiteColor()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(AddBookViewController.onDone))
        doneBtn.tintColor = UIColor.whiteColor()
        let mNavItem = UINavigationItem()
        mNavItem.title = "ADD BOOK"
        mNavItem.setLeftBarButtonItem(backBtn, animated: true)
        mNavItem.setRightBarButtonItem(doneBtn, animated: true)
        return mNavItem
    }
    
    @objc private func onDone() {

        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @objc private func onCancel() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    private func resignKeyboards() {
        captionTF.resignFirstResponder()
        isbnTF.resignFirstResponder()
        authorTF.resignFirstResponder()
        priceTF.resignFirstResponder()
        editionTF.resignFirstResponder()
        captionTF.animateViewsForTextDisplay()
        authorTF.animateViewsForTextDisplay()
        isbnTF.animateViewsForTextDisplay()
        priceTF.animateViewsForTextDisplay()
        editionTF.animateViewsForTextDisplay()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        resignFirstResponder()
        switch textField {
        case captionTF:
            captionTF.animateViewsForTextDisplay()
            editionTF.becomeFirstResponder()
            break
        case editionTF:
            editionTF.animateViewsForTextDisplay()
            authorTF.becomeFirstResponder()
            break
        case authorTF:
            authorTF.animateViewsForTextDisplay()
            isbnTF.becomeFirstResponder()
            break
        case isbnTF:
            isbnTF.animateViewsForTextDisplay()
            priceTF.becomeFirstResponder()
            break
        case priceTF:
            priceTF.animateViewsForTextDisplay()
            priceTF.resignFirstResponder()
            break
        default:
            break
        }
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //键盘滑动
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddBookViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddBookViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    
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
            if (priceTF.isFirstResponder() == false) {
                viewDisplacement = 0
            } else {
                let keyboardinfo = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]
                let keyboardheight:CGFloat = (keyboardinfo?.CGRectValue.size.height)!
                viewDisplacement = height - 400 - keyboardheight
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
    
    private func addBook() {
        
    }
    
    func changeImage(controller: AddBookPhotoViewController, frontimage:UIImage, backimage:UIImage, sideimage: UIImage) {
        print("change photos")
        frontIV.image = frontimage
        backIV.image = backimage
        sideIV.image = sideimage
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
