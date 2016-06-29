//
//  MessageVerificationViewController.swift
//  BocerApp
//
//  Created by Dempsy on 6/23/16.
//  Copyright © 2016 Dempsy. All rights reserved.
//

import UIKit

class MessageVerificationViewController: UIViewController {

    private var base = baseClass()
    private var email: String = ""
    private var verificationCode: String = ""
    private var mNavBar: UINavigationBar?
    @IBOutlet private weak var verificationCodeTF: UITextField!
    @IBOutlet private weak var resendBtn: UIButton!
    @IBOutlet private weak var finishBtn: UIButton!
    
    private var countdownTimer: NSTimer?
    
    private var remainingSeconds: Int = 0 {
        willSet {
            resendBtn.setTitle("\(newValue)s", forState: .Disabled)
            
            if newValue <= 0 {
                resendBtn.setTitle("Resend", forState: .Normal)
                isCounting = false
            }
        }
    }
    
    private var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector:#selector(MessageVerificationViewController.updateTime(_:)), userInfo: nil, repeats: true)
                remainingSeconds = 60
                resendBtn.backgroundColor = UIColor.grayColor()
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
                resendBtn.backgroundColor = UIColor.redColor()
            }
            resendBtn.enabled = !newValue
        }
    }
    
    private func beginCounting() {
        isCounting = true
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
        mNavBar?.backgroundColor = finishBtn.backgroundColor
        
        let navTitleAttribute: NSDictionary = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName)
        mNavBar?.titleTextAttributes = navTitleAttribute as? [String : AnyObject]
        
        self.view.addSubview(mNavBar!)
        mNavBar?.pushNavigationItem(onMakeNavitem(), animated: true)
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        resendBtn.layer.cornerRadius = 10
        finishBtn.layer.cornerRadius = 10
        beginCounting()
    }
    
    @objc private func onCancel(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func onMakeNavitem()->UINavigationItem{
        let navItem = UINavigationItem()
        let backBtn = UIBarButtonItem(title: "ㄑBack", style: .Plain,
                                      target: self, action: #selector(MessageVerificationViewController.onCancel))
        backBtn.tintColor = UIColor.whiteColor()
        navItem.title = "CODE VERIFICATION"
        navItem.setLeftBarButtonItem(backBtn, animated: true)
        return navItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func updateTime(timer: NSTimer) {
        remainingSeconds -= 1
    }
    
    //从数据库获取电话号码
    internal func setEmail(mEmail:String) {
        email = mEmail
    }
    
    //从数据库获取验证码
    internal func setVerificationCode(code: String) {
        verificationCode = code
    }

    @IBAction private func resendClicked(sender: UIButton) {
        beginCounting()
        //TODO: 重新给手机号发送验证码
    }
    
    @IBAction private func finishClicked(sender: UIButton) {
        //TODO: 检测验证码是否正确
        
        
        let faSign = base.cacheGetString("father for Message Verification")
        if faSign == "SignUp" {
            let sb = UIStoryboard(name: "Main", bundle: nil);
            let vc = sb.instantiateViewControllerWithIdentifier("MoreInfoViewController") as UIViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
