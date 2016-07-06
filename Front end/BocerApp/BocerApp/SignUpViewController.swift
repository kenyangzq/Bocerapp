//
//  SignUpViewController.swift
//  BocerApp
//
//  Created by Dempsy on 6/22/16.
//  Copyright © 2016 Dempsy. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate, NSURLConnectionDataDelegate, FBSDKLoginButtonDelegate {

    
    private var mNavBar: UINavigationBar?
    private var checkEmail = checkEmailForm()
    private var dataChunk = NSMutableData()
    @IBOutlet private weak var emailTF: YoshikoTextField!
    @IBOutlet private weak var resetPasswordTF: YoshikoTextField!
    @IBOutlet private weak var nextStepBtn: UIButton!
    @IBOutlet private weak var firstNameTF: YoshikoTextField!
    @IBOutlet private weak var lastNameTF: YoshikoTextField!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    private var email: String?
    private var firstName: String?
    private var lastName: String?
    private var newPassword: String?
    private var imageString: String?
    private let personalInfo = UserInfo()
    private var base = baseClass()
    private var userInfo = UserInfo()
    private var viewDisplacement: CGFloat = 0
    
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
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        nextStepBtn.layer.cornerRadius = usefulConstants().buttonCornerRadius
        
        //delegate  & customize textfield
        emailTF.delegate = self
        emailTF.activeBorderColor = .darkGrayColor()
        emailTF.activeBackgroundColor = .lightTextColor()
        resetPasswordTF.delegate = self
        resetPasswordTF.activeBorderColor = .darkGrayColor()
        resetPasswordTF.activeBackgroundColor = .lightTextColor()
        firstNameTF.delegate = self
        firstNameTF.activeBorderColor = .darkGrayColor()
        firstNameTF.activeBackgroundColor = .lightTextColor()
        lastNameTF.delegate = self
        lastNameTF.activeBorderColor = .darkGrayColor()
        lastNameTF.activeBackgroundColor = .lightTextColor()
        
        //facebook stuff
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
        }
        else
        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.frame = CGRect(x: self.view.center.x - 125, y: self.view.frame.size.height - 85, width: 250, height: 50)
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }
    }
    
    //键盘->屏幕滑动
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignUpViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignUpViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //设置导航栏左侧按键的action
    @objc private func onCancel(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        resignFirstResponder()
        switch textField {
        case firstNameTF:
            lastNameTF.becomeFirstResponder()
            break
        case lastNameTF:
            emailTF.becomeFirstResponder()
            break
        case emailTF:
            resetPasswordTF.becomeFirstResponder()
            break
        default:
            nextBtnPerformed()
            break
        }
        return true
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
    
    //检查合格性
    private func checkValidation(first: String?, last: String?, email: String?, password: String?) -> Bool {
        if (first == nil || first == "") {
            let alertController = UIAlertController(title: "Warning",
                                                    message: "First name cannot be empty.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        
        if (last == nil || last == "") {
            let alertController = UIAlertController(title: "Warning",
                                                    message: "Last name cannot be empty.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        
        if (email == nil || email == "") {
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
        
        if (checkEmail.check(email) == false) {
            let alertController = UIAlertController(title: "Warning",
                                                    message: "Incorrect Email address form", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        }
        
        return checkPwValidation(password!)
    }
    
    private func nextBtnPerformed() {
        email = emailTF.text
        newPassword = resetPasswordTF.text!.md5()
        firstName = firstNameTF.text
        lastName = lastNameTF.text
        print("email is \(email)\n newPassword is \(newPassword) \n firstname is \(firstName)\n is lastName is \(lastName)")
        if (checkValidation(firstName, last: lastName, email: email, password: newPassword)) {
            
            personalInfo.setEmail(email!)
            personalInfo.setPassword(newPassword!)
            
            //TODO: 将电话号码和新密码传入后端
            let dataString = NSString.localizedStringWithFormat("{\"username\":\"%@\",\"firstname\":\"%@\",\"lastname\":\"%@\",\"password\":\"%@\"}",email!,firstName!,lastName!,newPassword!)
            let sent = NSData(data: dataString.dataUsingEncoding(NSASCIIStringEncoding)!)
            let dataLength = NSString.localizedStringWithFormat("%ld", sent.length)
            let path = usefulConstants().domainAddress + "/addUser"
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
                
                print("cannot connect to the server \n")
            }
            //TODO:

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
        indicator.alpha = 0
        indicator.stopAnimating()
        let backmsg: AnyObject! = try! NSJSONSerialization.JSONObjectWithData(dataChunk, options: NSJSONReadingOptions(rawValue: 0))
        let targetAction = backmsg.objectForKey("Target Action") as! String
        let content = backmsg.objectForKey("content") as! String
        //普通注册
        //Bugfix - Dempsy July.2nd
        if targetAction == "signupresult" {
            print("back message is: \(content)")
            if content == "success" {
                //获取用户其他信息
                print("Sign up success\n")
                requestUserBasicInfo()
                
            }
            else if content == "wrong" {
                let alertController = UIAlertController(title: "Warning",
                                                        message: "Wrong email and password combination.", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
                print("wrong email and password combination\n")
            } else if content == "already exist"{
                let alertController = UIAlertController(title: "Warning",
                                                        message: "Account already exists", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
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
                //TODO: 进入facebook login ---有待商榷
                
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
                userInfo.setName(firstName!, mLast: lastName!)
                userInfo.setImageString(imageString!)
                
                let sb = UIStoryboard(name: "MainInterface", bundle: nil);
                let vc = sb.instantiateViewControllerWithIdentifier("MainInterfaceViewController") as UIViewController
                self.navigationController?.presentViewController(vc, animated: true, completion: nil)
//                self.navigationController?.pushViewController(vc, animated: true)

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
    
    @IBAction private func viewClick(sender: AnyObject) {
        firstNameTF.resignFirstResponder()
        lastNameTF.resignFirstResponder()
        emailTF.resignFirstResponder()
        resetPasswordTF.resignFirstResponder()
        
    }
    
    @IBAction private func nextBtnClicked(sender: UIButton) {
        nextBtnPerformed()
    }
    
    func mNumber()-> String {
        return email!
    }
    
    func mPassword() -> String {
        return newPassword!
    }
    
    //facebook login request
    private func facebookVerifyWithUserName(userName: String) {
        let dataString = NSString.localizedStringWithFormat("{\"username\":\"%@\"}",userName)
        let sent = NSData(data: dataString.dataUsingEncoding(NSASCIIStringEncoding)!)
        let dataLength = NSString.localizedStringWithFormat("%ld", sent.length)
        let path = usefulConstants().domainAddress + "/checkFacebook"
        let url = NSURL(fileURLWithPath: path)
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
    
    //Facebook Delegate Methods
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In\n")
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        
        if ((error) != nil)
        {
            // Process error
            print("error: \(error)\n")
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
                if (FBSDKAccessToken.currentAccessToken() != nil) {
                    //let mParameters = NSMutableDictionary()
                    //mParameters.setValue("id,email,last_name,first_name", forKey: "fields")
                    let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
                    graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
                        
                        if ((error) != nil)
                        {
                            // Process error
                            print("Error: \(error)\n")
                        }
                        else
                        {
                            print("fetched user: \(result)\n")
                            self.firstName = result.valueForKey("first_name") as? String
                            print("First Name is: \(self.firstName)\n")
                            self.lastName = result.valueForKey("last_name") as? String
                            print("Last Name is: \(self.lastName)\n")
                            self.email = result.valueForKey("email") as? String
                            print("Email is: \(self.email)\n")
                            self.facebookVerifyWithUserName(self.email!)
                        }
                    })
                }
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out\n")
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
