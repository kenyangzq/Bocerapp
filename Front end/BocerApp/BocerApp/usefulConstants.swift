//
//  usefulConstants.swift
//  BocerApp
//
//  Created by Dempsy on 7/5/16.
//  Copyright © 2016 Dempsy. All rights reserved.
//

//This is a file that stores useful constants used in different classes/view controllers
//Common constants must be stored in this file

import Foundation

class usefulConstants {
    
    let buttonCornerRadius = 5 as CGFloat
    
    let domainAddress = "http://bocerbook.com"
    
    let fullAvatarPath: String = NSHomeDirectory().stringByAppendingString("/Documents").stringByAppendingString("/fullAvatarImage")
    
    let smallAvatarPath: String = NSHomeDirectory().stringByAppendingString("/Documents").stringByAppendingString("/smallAvatarImage")
    
    //default navigation bar color & button color
    let defaultColor = UIColor(red: 0, green: 128/255, blue: 128/255, alpha: 1)
    
}