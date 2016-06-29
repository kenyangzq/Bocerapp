//
//  SignUpViewController.swift
//  BocerApp
//
//  Created by Dempsy on 6/22/16.
//  Copyright © 2016 Dempsy. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    
    private var mNavBar: UINavigationBar?
    private var checkEmail = checkEmailForm()
    @IBOutlet private weak var emailTF: UITextField!
    @IBOutlet private weak var resetPasswordTF: UITextField!
    @IBOutlet private weak var nextStepBtn: UIButton!
    private var email: String?
    private var newPassword: String?
    private let personalInfo = UserInfo()
    private var base = baseClass()
    
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
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
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
        let backBtn = UIBarButtonItem(title: "ㄑBack", style: .Plain,
                                      target: self, action: #selector(SignUpViewController.onCancel))
        backBtn.tintColor = UIColor.whiteColor()
        navigationItem.title = "SIGN UP"
        navigationItem.setLeftBarButtonItem(backBtn, animated: true)
        navigationItem.setHidesBackButton(false, animated: true)
        return navigationItem
    }
    
    //检查密码合格性
    private func checkPwValidation(password: String) -> Bool{
        
        //检查密码是否长于6位
        if password.characters.count < 6 {
            let alertController = UIAlertController(title: "Alert",
                                                    message: "Password must contain at least 6 characters.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        
        //检查密码是否包含数字
        var haveDigits = false
        for i in password.characters {
            if (i>="0" && i<="9") {
                haveDigits = true
                break
            }
        }
        if haveDigits == false {
            let alertController = UIAlertController(title: "Alert",
                                                    message: "Password must contain at least 1 digit.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        
        //检查密码是否只包含数字字母
        var punctuations = true
        for i in password.characters {
            if (i>="0" && i<="9") {continue}
            if (i>="a" && i<="z") {continue}
            if (i>="A" && i<="Z") {continue}
            if (i=="." || i=="_" || i=="-") {continue}
            punctuations = false
            break
        }
        if punctuations == false {
            let alertController = UIAlertController(title: "Alert",
                message: "Password cannot have punctuations other than '.', '_' and '-'.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    //检查合格性
    private func checkValidation(number: String?, password: String?) -> Bool {
        if (number == nil || number == "") {
            let alertController = UIAlertController(title: "Alert",
                                                    message: "Email address cannot be empty.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        
        if (password == nil || password == "") {
            let alertController = UIAlertController(title: "Alert",
                                                    message: "Password cannot be empty.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        
        if (checkEmail.check(number) == false) {
            let alertController = UIAlertController(title: "Alert",
                                                    message: "Incorrect Email address form", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        
        return checkPwValidation(password!)
    }
    
    @IBAction private func nextBtnClicked(sender: UIButton) {
        email = emailTF.text
        newPassword = resetPasswordTF.text
        if (checkValidation(email,password: newPassword)) {
            
            personalInfo.setEmail(email!)
            personalInfo.setPassword(newPassword!)
            
            //TODO: 将电话号码和新密码传入后端，并向电话号码发送验证码
            
            

            self.base.cacheSetString("father for Message Verification", value: "SignUp")
            
            //TODO:
            self.base.cacheSetString("User Index", value: "NEED VALUE")
            let sb = UIStoryboard(name: "Main", bundle: nil);
            let vc = sb.instantiateViewControllerWithIdentifier("MessageVerificationViewController") as UIViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func mNumber()-> String {
        return email!
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
