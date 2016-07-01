//
//  SignUpViewController.swift
//  BocerApp
//
//  Created by Dempsy on 6/22/16.
//  Copyright © 2016 Dempsy. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate, NSURLConnectionDataDelegate {

    
    private var mNavBar: UINavigationBar?
    private var checkEmail = checkEmailForm()
    private var dataChunk = NSMutableData()
    @IBOutlet private weak var emailTF: UITextField!
    @IBOutlet private weak var resetPasswordTF: UITextField!
    @IBOutlet private weak var nextStepBtn: UIButton!
    @IBOutlet private weak var firstNameTF: UITextField!
    @IBOutlet private weak var lastNameTF: UITextField!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    private var email: String?
    private var firstName: String?
    private var lastName: String?
    private var newPassword: String?
    private var imageString: String?
    private let personalInfo = UserInfo()
    private var base = baseClass()
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
        mNavBar?.backgroundColor = nextStepBtn.backgroundColor
        
        let navTitleAttribute: NSDictionary = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName)
        mNavBar?.titleTextAttributes = navTitleAttribute as? [String : AnyObject]
        
        self.view.addSubview(mNavBar!)
        mNavBar?.pushNavigationItem(onMakeNavitem(), animated: true)
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        nextStepBtn.layer.cornerRadius = 10
        
        //delegate textfield
        emailTF.delegate = self
        resetPasswordTF.delegate = self
        firstNameTF.delegate = self
        lastNameTF.delegate = self
    }
    
    //键盘->屏幕滑动
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignUpViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SignUpViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
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
                viewDisplacement = height - 400 - keyboardheight
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
        newPassword = resetPasswordTF.text
        firstName = firstNameTF.text
        lastName = lastNameTF.text
        if (checkValidation(firstName, last: lastName, email: email, password: newPassword)) {
            
            personalInfo.setEmail(email!)
            personalInfo.setPassword(newPassword!)
            
            //TODO: 将电话号码和新密码传入后端
            let dataString = NSString.localizedStringWithFormat("{\"username\":\"%@\",\"firstName\":\"%@\",\"lastName\":\"%@\",\"password\":\"%@\"}",email!,firstName!,lastName!,newPassword!)
            let sent = NSData(data: dataString.dataUsingEncoding(NSASCIIStringEncoding)!)
            let dataLength = NSString.localizedStringWithFormat("%ld", sent.length)
            let url = NSURL(fileURLWithPath: "http://www.bocerapp.com/addUser")
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
        indicator.alpha = 0
        indicator.stopAnimating()
        let backmsg: AnyObject! = try! NSJSONSerialization.JSONObjectWithData(dataChunk, options: NSJSONReadingOptions(rawValue: 0))
        let targetAction = backmsg.objectForKey("Target Action") as! String
        let content = backmsg.objectForKey("content") as! String
        //普通登录
        if targetAction == "signinresult" {
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
    
    @IBAction func viewClick(sender: AnyObject) {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
