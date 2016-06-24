//
//  SignInViewController.swift
//  BocerApp
//
//  Created by Dempsy on 6/22/16.
//  Copyright © 2016 Dempsy. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    private var mNavBar: UINavigationBar?
    @IBOutlet private weak var mNavItem: UINavigationItem!
    @IBOutlet private weak var phoneNumberTF: UITextField!
    @IBOutlet private weak var passwordTF: UITextField!
    @IBOutlet private weak var signInBtn: UIButton!
    @IBOutlet private weak var resetPasswordBtn: UIButton!

    private var phoneNumber: String?
    private var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //设置导航栏
        let screenMaxX = UIScreen.mainScreen().bounds.maxX
        mNavBar = UINavigationBar(frame: CGRectMake(0,0,screenMaxX,54))
        mNavBar?.translucent = true
        mNavBar?.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        mNavBar?.shadowImage = UIImage()
        mNavBar?.backgroundColor = signInBtn.backgroundColor
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        let navTitleAttribute: NSDictionary = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName)
        mNavBar?.titleTextAttributes = navTitleAttribute as? [String : AnyObject]
        
        self.view.addSubview(mNavBar!)
        mNavBar?.pushNavigationItem(onMakeNavitem(), animated: true)
        
        //设置按键圆角
        signInBtn.layer.cornerRadius = 10
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //设置导航栏左侧按键的action
    @objc private func onCancel(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //创建一个导航项
    private func onMakeNavitem()->UINavigationItem{
        let backBtn = UIBarButtonItem(title: "Back", style: .Plain,
                                      target: self, action: #selector(SignInViewController.onCancel))
        backBtn.tintColor = UIColor.whiteColor()
        mNavItem.title = "SIGN IN"
        mNavItem.setLeftBarButtonItem(backBtn, animated: true)
        return mNavItem
    }
    
    //检测phone number和password的正确性
    private func checkValidation(number: String?, password: String?) -> Bool {
        if (number == nil || number == "") {
            let alertController = UIAlertController(title: "Alert",
                                                    message: "Phone Number cannot be empty", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        
        if (password == nil || password == "") {
            let alertController = UIAlertController(title: "Alert",
                                                    message: "Password cannot be empty", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        
        var mNumFlag = true
        for c in (number?.characters)! {
            if ((c < "0") || (c > "9")) {
                mNumFlag = false
            }
        }
        if (mNumFlag == false) {
            let alertController = UIAlertController(title: "Alert",
                                                    message: "Incorrect phone number form", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        
        return true
        
    }
    
    //设置Sign In Button的动作
    @IBAction private func signInBtnClicked(sender: UIButton) {
        phoneNumber = phoneNumberTF.text
        password = passwordTF.text
        if (checkValidation(phoneNumber, password: password)) {
            //TODO: 询问用户名和密码匹不匹配
            
        }
    }
    
    @IBAction func resetPassword(sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil);
        let vc = sb.instantiateViewControllerWithIdentifier("ResetPasswordViewController") as UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func mNumber() -> String {
        return phoneNumber!
    }
    
    func mPassword() -> String {
        return password!
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
