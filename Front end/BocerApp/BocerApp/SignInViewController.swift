//
//  SignInViewController.swift
//  BocerApp
//
//  Created by Dempsy on 6/22/16.
//  Copyright © 2016 Dempsy. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate, NSURLConnectionDataDelegate{

    private var mNavBar: UINavigationBar?
    private let base = baseClass()
    private let userInfo = UserInfo()
    private let checkEmail = checkEmailForm()
    private let signInRequest = serverConn()
    private var firstName: String? = nil
    private var lastName: String? = nil
    private var imageString: String? = nil
    private var dataChunk = NSMutableData()
    @IBOutlet private weak var mNavItem: UINavigationItem!
    @IBOutlet private weak var emailTF: UITextField!
    @IBOutlet private weak var passwordTF: UITextField!
    @IBOutlet private weak var signInBtn: UIButton!
    @IBOutlet private weak var resetPasswordBtn: UIButton!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
 
    private var email: String?
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
        
        //delgate text field
        emailTF.delegate = self
        passwordTF.delegate = self
    }
    
    @IBAction func viewClicked(sender: AnyObject) {
        emailTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        resignFirstResponder()
        if textField == emailTF {
            passwordTF.becomeFirstResponder()
        } else {
            signInPerformed()
        }
        return true
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
        let backBtn = UIBarButtonItem(title: "ㄑBack", style: .Plain,
                                      target: self, action: #selector(SignInViewController.onCancel))
        backBtn.tintColor = UIColor.whiteColor()
        mNavItem.title = "SIGN IN"
        mNavItem.setLeftBarButtonItem(backBtn, animated: true)
        return mNavItem
    }
    
    //检测phone number和password的正确性
    private func checkValidation(number: String?, password: String?) -> Bool {
        if (number == nil || number == "") {
            let alertController = UIAlertController(title: "Warning",
                                                    message: "Email address cannot be empty", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        
        if (password == nil || password == "") {
            let alertController = UIAlertController(title: "Warning",
                                                    message: "Password cannot be empty", preferredStyle: .Alert)
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
        
        return true
        
    }
    
    private func signInPerformed() {
        email = emailTF.text
        password = passwordTF.text?.md5()
        if (checkValidation(email, password: password)) {
            //TODO: 询问用户名和密码匹不匹配
            let dataString = NSString.localizedStringWithFormat("{\"username\":\"%@\",\"password\":\"%@\"}",email!,password!)
            let sent = NSData(data: dataString.dataUsingEncoding(NSASCIIStringEncoding)!)
            let dataLength = NSString.localizedStringWithFormat("%ld", sent.length)
            let url = NSURL(fileURLWithPath: "http://www.bocerapp.com/login")
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
            
            //TODO:

        }
    }
    
    private func requestUserBasicInfo() {
        let dataString = NSString.localizedStringWithFormat("{\"username\":\"%@\"}",email!)
        let sent = NSData(data: dataString.dataUsingEncoding(NSASCIIStringEncoding)!)
        let dataLength = NSString.localizedStringWithFormat("%ld", sent.length)
        let url = NSURL(fileURLWithPath: "http://www.bocerapp.com/userbasicinfo")
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
        if targetAction == "loginresult" {
            if content == "success" {
                //获取用户其他信息
                requestUserBasicInfo()
                
                print("login success\n")
            }
            else if content == "wrong" {
                let alertController = UIAlertController(title: "Warning",
                                                        message: "Wrong email and password combination.", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
                print("wrong email and password combination\n")
            } else {
                let alertController = UIAlertController(title: "Warning",
                                                        message: "Connection Failure.", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
                print("connection fails when trying email login")
            }
        }
        //facebook登录
        else if targetAction == "facebookresult" {
            if content == "success" {
                //获取用户其他信息
                requestUserBasicInfo()
                
                print("facebook login success\n")
            }
            else if content == "not exist" {
                //TODO: 进入facebook login
                
                print("facebook account not exists")
            } else {
                let alertController = UIAlertController(title: "Warning",
                                                        message: "Connection Failure.", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
                print("connection fails when trying facebook login")
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

    //设置Sign In Button的动作
    @IBAction private func signInBtnClicked(sender: UIButton) {
        signInPerformed()
    }
    
    @IBAction private func resetPassword(sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil);
        let vc = sb.instantiateViewControllerWithIdentifier("ResetPasswordViewController") as UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func mNumber() -> String {
        return email!
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
