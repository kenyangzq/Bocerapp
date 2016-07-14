//
//  LeftDrawer.swift
//  BocerApp
//
//  Created by Dempsy on 7/5/16.
//  Copyright © 2016 Dempsy. All rights reserved.
//

import UIKit

class LeftDrawer: UIViewController {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var editInfoBtn: UIButton!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var historyBtn: UIButton!
    @IBOutlet private weak var saleBtn: UIButton!
    @IBOutlet private weak var avatarIV: UIImageView!
    @IBOutlet private weak var buyBtn: UIButton!
    private var firstName: String?
    private var lastName: String?
    private var email: String?
    private var phoneNumber: String?
    private var avatarLocalString: String?
    private let userInfo = UserInfo()
    private var swipeRec = UISwipeGestureRecognizer()
    private let someConstants = usefulConstants()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        avatarIV.layer.cornerRadius = 50
        avatarIV.layer.masksToBounds = true
        // Customize button & label attributions
        self.view.backgroundColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 0)
        editInfoBtn.layer.cornerRadius = 30
        historyBtn.layer.cornerRadius = 30
        saleBtn.layer.cornerRadius = 30
        buyBtn.layer.cornerRadius = 30
        nameLabel.adjustsFontSizeToFitWidth = true
        avatarIV.backgroundColor = .blackColor()
        
        //add swipe gesture recognizer
        swipeRec = UISwipeGestureRecognizer(target: self, action: #selector(LeftDrawer.swipeView(_:)))
        swipeRec.direction = .Left
        self.view.addGestureRecognizer(swipeRec)
        swipeRec.numberOfTouchesRequired = 1
}
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.removeGestureRecognizer(swipeRec)
    }
    
    @objc private func swipeView(sender: UISwipeGestureRecognizer) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.toggleRightDrawer(sender, animated: false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //add swipe gesture recognizer
        swipeRec = UISwipeGestureRecognizer(target: self, action: #selector(LeftDrawer.swipeView(_:)))
        swipeRec.direction = .Left
        self.view.addGestureRecognizer(swipeRec)
        
        //update user info
        //TODO:本地数据库建立？

        avatarLocalString = userInfo.getImageString()
        print("avatar string is \(avatarLocalString)")
        var avatarImage: UIImage? = nil
        if avatarLocalString == nil {
            avatarImage = UIImage(contentsOfFile: someConstants.smallAvatarPath)
        } else {
            avatarImage = UIImage(contentsOfFile: avatarLocalString!)!
        }
        if avatarImage != nil {
            avatarIV.image = avatarImage
            print("avatarImage != nil")
        }
        (firstName, lastName) = userInfo.getName()
        email = userInfo.getEmail()
        phoneNumber = userInfo.getPhoneNumber()

        nameLabel.text = someConstants.defaultFirstName+" "+someConstants.defaultLastName
        if firstName != nil {
            nameLabel.text = firstName!
        }
        if lastName != nil {
            let c = " " as Character
            nameLabel.text?.append(c)
            nameLabel.text?.appendContentsOf(lastName!)
        }
        if nameLabel.text == "" {nameLabel.text = "Name"}
        
        emailLabel.text = someConstants.defaultEmail
        if email != nil {emailLabel.text = email}
        if phoneNumber == nil {phoneNumber = someConstants.defaultPhoneNumber}
        phoneNumber?.adjustPhoneNumber()
        phoneLabel.text = phoneNumber
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addPhotoFired(sender: UIButton) {
        let sb = UIStoryboard(name: "MainInterface", bundle: nil);
        let vc = sb.instantiateViewControllerWithIdentifier("AvatarPresentViewController") as UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func editBtnFired(sender: UIButton) {
        let sb = UIStoryboard(name: "MainInterface", bundle: nil);
        let vc = sb.instantiateViewControllerWithIdentifier("ProfileSettingViewController") as UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
//    @IBAction func historyBtnFired(sender: UIButton) {
//    }
    @IBAction func saleBtnFired(sender: UIButton) {
        
        let sb = UIStoryboard(name: "MainInterface", bundle: nil);
        let vc = sb.instantiateViewControllerWithIdentifier("AddBookViewController") as UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
//    @IBAction func buyBtnFired(sender: UIButton) {
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
