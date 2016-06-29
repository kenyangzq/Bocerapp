//
//  ResetPasswordViewController.swift
//  BocerApp
//
//  Created by Dempsy on 6/23/16.
//  Copyright © 2016 Dempsy. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    private var mNavBar: UINavigationBar?
    
    @IBOutlet private weak var phoneNumberTF: UITextField!
    @IBOutlet private weak var resetPasswordTF: UITextField!
    @IBOutlet private weak var nextStepBtn: UIButton!
    private var phoneNumber: String?
    private var newPassword: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //设置导航栏
        let screenMaxX = UIScreen.mainScreen().bounds.maxX
        mNavBar = UINavigationBar(frame: CGRectMake(0,0,screenMaxX,54))
        mNavBar?.translucent = true
        mNavBar?.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        mNavBar?.shadowImage = UIImage()
        mNavBar?.backgroundColor = nextStepBtn.backgroundColor
        
        let navTitleAttribute: NSDictionary = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName)
        mNavBar?.titleTextAttributes = navTitleAttribute as? [String : AnyObject]
        
        self.view.addSubview(mNavBar!)
        mNavBar?.pushNavigationItem(onMakeNavitem(), animated: true)
        
        nextStepBtn.layer.cornerRadius = 10
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
        let navigationItem = UINavigationItem()
        let backBtn = UIBarButtonItem(title: "Back", style: .Plain,
                                      target: self, action: #selector(ResetPasswordViewController.onCancel))
        backBtn.tintColor = UIColor.whiteColor()
        navigationItem.title = "RESET PASSWORD"
        navigationItem.setLeftBarButtonItem(backBtn, animated: true)
        navigationItem.setHidesBackButton(false, animated: true)
        return navigationItem
    }
    
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
        //TODO: 检查密码是否大于6位
        
        return true
    }

    @IBAction private func nextBtnClicked(sender: UIButton) {
        phoneNumber = phoneNumberTF.text
        newPassword = resetPasswordTF.text
        if (checkValidation(phoneNumber,password: newPassword)) {
            //TODO: 将电话号码和新密码传入后端，并向电话号码发送验证码
            
            
            
            let sb = UIStoryboard(name: "Main", bundle: nil);
            let vc = sb.instantiateViewControllerWithIdentifier("MessageVerificationViewController") as UIViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
  
    func mNumber()-> String {
        return phoneNumber!
    }
    
    func mPassword() -> String {
        return newPassword!
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
