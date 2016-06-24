//
//  InitialViewController.swift
//  BocerApp
//
//  Created by Dempsy on 6/22/16.
//  Copyright © 2016 Dempsy. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    @IBOutlet weak var SignInBtn: UIButton!
    
    @IBOutlet weak var SignUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //将按键设置为圆角
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        SignInBtn.layer.cornerRadius = 10
        SignUpBtn.layer.cornerRadius = 10
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        viewDidLoad()
        //隐藏导航栏
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    //进入Sign In View Controller
    @IBAction private func SignIn(sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil);
        let vc = sb.instantiateViewControllerWithIdentifier("SignInViewController") as UIViewController
     //   self.presentViewController(vc, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //进入Sign Up View Controller
    @IBAction private func SignUp(sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil);
        let vc = sb.instantiateViewControllerWithIdentifier("SignUpViewController") as UIViewController
        //self.presentViewController(vc, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
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
