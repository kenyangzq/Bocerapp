//
//  ResetPasswordViewController.swift
//  BocerApp
//
//  Created by Dempsy on 6/23/16.
//  Copyright © 2016 Dempsy. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate,NSURLConnectionDataDelegate {

    private var mNavBar: UINavigationBar?
    private var checkEmail = checkEmailForm()
    @IBOutlet private weak var emailTF: HoshiTextField!
    @IBOutlet private weak var resetPasswordTF: HoshiTextField!
    @IBOutlet private weak var resendBtn: UIButton!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    private var email: String?
    private var newPassword: String?
    private var firstName: String?
    private var lastName: String?
    private var imageString: String?
    private var base = baseClass()
    private var userInfo = UserInfo()
    private var countdownTimer: NSTimer?
    private var dataChunk = NSMutableData()
    
    @objc private func updateTime(timer: NSTimer) {
        remainingSeconds -= 1
    }
    
    private var remainingSeconds: Int = 0 {
        willSet {
            resendBtn.setTitle("wait \(newValue)s to resend", forState: .Disabled)
            
            if newValue <= 0 {
                resendBtn.setTitle("Resend", forState: .Normal)
                isCounting = false
            }
        }
    }
    
    private var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector:#selector(ResetPasswordViewController.updateTime(_:)), userInfo: nil, repeats: true)
                remainingSeconds = 60
                resendBtn.backgroundColor = UIColor.grayColor()
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
                resendBtn.backgroundColor = UIColor(red: 102/255, green: 255/255, blue: 204/255, alpha: 1)            }
            resendBtn.enabled = !newValue
        }
    }
    
    private func beginCounting() {
        isCounting = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
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
        
        let navTitleAttribute: NSDictionary = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName)
        mNavBar?.titleTextAttributes = navTitleAttribute as? [String : AnyObject]
        
        self.view.addSubview(mNavBar!)
        mNavBar?.pushNavigationItem(onMakeNavitem(), animated: true)
        
        resendBtn.layer.cornerRadius = usefulConstants().buttonCornerRadius
        resendBtn.backgroundColor = UIColor(red: 102/255, green: 255/255, blue: 204/255, alpha: 1)
        
        //delegate & customize textfield
        emailTF.delegate = self
        emailTF.borderActiveColor = .blueColor()
        emailTF.borderInactiveColor = .grayColor()
        emailTF.placeholderColor = .grayColor()
        resetPasswordTF.delegate = self
        resetPasswordTF.borderInactiveColor = .grayColor()
        resetPasswordTF.borderActiveColor = .redColor()
        resetPasswordTF.placeholderColor = .grayColor()
    }

    @IBAction func viewClick(sender: AnyObject) {
        emailTF.resignFirstResponder()
        resetPasswordTF.resignFirstResponder()
    }
    
    private func resendBtnPerformed() {
        email = emailTF.text
        newPassword = resetPasswordTF.text
        if (checkValidation(email,password: newPassword)) {
            beginCounting()
            let alertController = UIAlertController(title: "Warning",
                                                    message: "A verification link has been sent to your Email.\nYou need to wait 60 seconds to send another one.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            
            //TODO: 将电话号码和新密码传入后端，并向电话号码发送验证码
            let dataString = NSString.localizedStringWithFormat("{\"username\":\"%@\",\"password\":\"%@\"}",email!,newPassword!)
            let sent = NSData(data: dataString.dataUsingEncoding(NSASCIIStringEncoding)!)
            let dataLength = NSString.localizedStringWithFormat("%ld", sent.length)
            let path = usefulConstants().domainAddress + "/forgetPassword"
            let url = NSURL(string: path)
            let request = NSMutableURLRequest()
            request.URL = url
            request.HTTPMethod = "POST"
            request.setValue(dataLength as String, forHTTPHeaderField: "Content-Length")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = sent
            
            let conn = NSURLConnection(request: request, delegate: self, startImmediately: true)
            indicator.alpha = 1
            indicator.startAnimating()
            if (conn == nil) {
                let alertController = UIAlertController(title: "Warning",
                                                        message: "Connection Failure.", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
    private func requestUserBasicInfo() {
        let dataString = NSString.localizedStringWithFormat("{\"username\":\"%@\"}",email!)
        let sent = NSData(data: dataString.dataUsingEncoding(NSASCIIStringEncoding)!)
        let dataLength = NSString.localizedStringWithFormat("%ld", sent.length)
        let path = usefulConstants().domainAddress + "/userbasicinfo"
        let url = NSURL(string: path)
        let request = NSMutableURLRequest()
        request.URL = url
        request.HTTPMethod = "POST"
        request.setValue(dataLength as String, forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = sent
        let conn = NSURLConnection(request: request, delegate: self, startImmediately: true)
        if (conn == nil) {
            let alertController = UIAlertController(title: "Warning",
                                                    message: "Connection Failure.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            
            print("cannot connect to the server\n")
        }
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        dataChunk = NSMutableData()
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        dataChunk.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        let backmsg: AnyObject! = try! NSJSONSerialization.JSONObjectWithData(dataChunk, options: NSJSONReadingOptions(rawValue: 0))
        let targetAction = backmsg.objectForKey("Target Action") as! String
        let content = backmsg.objectForKey("content") as! String
        indicator.stopAnimating()
        indicator.alpha = 0
        //普通登录
        if targetAction == "forgetresult" {
            if content == "success" {
                //获取用户其他信息
                requestUserBasicInfo()
                
                print("login success\n")
            }
            else if content == "not exist" {
                let alertController = UIAlertController(title: "Warning",
                                                        message: "Email does not exists", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
                print("email does not exists")
            } else {
                let alertController = UIAlertController(title: "Warning",
                                                        message: "Connection Failure.", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
                print("connection fails when trying email login")
            }
        }
             //user info
        else if targetAction == "userbasicinfo" {
            if content == "fail" {
                let alertController = UIAlertController(title: "Warning",
                                                        message: "Server Issues.", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
                print("Server downs when trying to get user basic info\n")
            } else {
                firstName = backmsg.objectForKey("firstname") as! String?
                lastName = backmsg.objectForKey("lastname") as! String?
                imageString = backmsg.objectForKey("imagestring") as! String?
                //TODO: 进入主界面
                userInfo.setName(firstName!, mLast: lastName!)
                userInfo.setImageString(imageString!)
                
                let sb = UIStoryboard(name: "MainInterface", bundle: nil);
                let vc = sb.instantiateViewControllerWithIdentifier("MainInterfaceViewController") as UIViewController
                self.navigationController?.pushViewController(vc, animated: true)

                print("fetched user basic info successfully\n")
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

    @IBAction func resendBtnClicked(sender: UIButton) {
        resendBtnPerformed()
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
                                      target: self, action: #selector(ResetPasswordViewController.onCancel))
        backBtn.tintColor = UIColor.whiteColor()
        navigationItem.title = "RESET PASSWORD"
        navigationItem.setLeftBarButtonItem(backBtn, animated: true)
        navigationItem.setHidesBackButton(false, animated: true)
        return navigationItem
    }
    
    private func checkPwValidation(password: String) -> Bool{
        
        //检查密码是否长于6位
        if password.characters.count < 6 {
            let alertController = UIAlertController(title: "Warning",
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
            let alertController = UIAlertController(title: "Warning",
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
            let alertController = UIAlertController(title: "Warning",
                message: "Password cannot have punctuations other than '.', '_' and '-'.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    private func checkValidation(number: String?, password: String?) -> Bool {
        if (number == nil || number == "") {
            let alertController = UIAlertController(title: "Warning",
                                                    message: "Email address cannot be empty.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        
        if (password == nil || password == "") {
            let alertController = UIAlertController(title: "Warning",
                                                    message: "Password cannot be empty.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        
        if (checkEmail.check(number) == false) {
            let alertController = UIAlertController(title: "Warning",
                                                    message: "Incorrect Email address form", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        //TODO: 检查密码是否大于6位
        
        return checkPwValidation(password!)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        resignFirstResponder()
        if textField == emailTF {
            resetPasswordTF.becomeFirstResponder()
        } else {
            resendBtnPerformed()
        }
        return true
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
