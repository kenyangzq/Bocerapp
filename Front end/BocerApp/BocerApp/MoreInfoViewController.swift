//
//  MoreInfoViewController.swift
//  BocerApp
//
//  Created by Dempsy on 6/27/16.
//  Copyright © 2016 Dempsy. All rights reserved.
//

import UIKit
import Foundation

class MoreInfoViewController: UIViewController, UITableViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    private var mNavBar: UINavigationBar?
    private let base = baseClass()
    @IBOutlet private weak var photoBtn: UIButton!
    @IBOutlet private weak var finishBtn: UIButton!
    @IBOutlet private weak var firstNameTF: UITextField!
    @IBOutlet private weak var lastNameTF: UITextField!
    @IBOutlet private weak var phoneNumberTF: UITextField!
    @IBOutlet private weak var collegeTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
        
        finishBtn.layer.cornerRadius = 10
        photoBtn.layer.borderWidth = 1.0
        photoBtn.layer.borderColor = UIColor.blackColor().CGColor
        photoBtn.layer.cornerRadius = photoBtn.frame.width / 2
        
        //text field delegate
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        phoneNumberTF.delegate = self
        collegeTF.delegate = self
    }
    
    private func resignKeyboards() {
        firstNameTF.resignFirstResponder()
        lastNameTF.resignFirstResponder()
        phoneNumberTF.resignFirstResponder()
        collegeTF.resignFirstResponder()
    }
    
    @IBAction private func viewClick(sender: AnyObject) {
        resignKeyboards()
    }

    
    @IBAction func photoBtnClicked(sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil);
        let vc = sb.instantiateViewControllerWithIdentifier("AvatarPresentViewController") as UIViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func onCancel(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    private func onMakeNavitem()->UINavigationItem{
        let navItem = UINavigationItem()
        let backBtn = UIBarButtonItem(title: "ㄑBack", style: .Plain,
                                      target: self, action: #selector(MoreInfoViewController.onCancel))
        backBtn.tintColor = UIColor.whiteColor()
        navItem.title = "MORE INFORMATION"
        navItem.setLeftBarButtonItem(backBtn, animated: true)
        return navItem
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        animateViewMoving(true, moveValue: 100)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        animateViewMoving(false, moveValue: 100)
    }
    
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:NSTimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case firstNameTF:
            textField.resignFirstResponder()
            lastNameTF.becomeFirstResponder()
            break
        case lastNameTF:
            textField.resignFirstResponder()
            phoneNumberTF.becomeFirstResponder()
            break
        case phoneNumberTF:
            textField.resignFirstResponder()
            collegeTF.becomeFirstResponder()
            break
        default:
            textField.resignFirstResponder()
        }
        return true
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
