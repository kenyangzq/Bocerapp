//
//  baseClass.swift
//  BocerApp
//
//  Created by Dempsy on 6/27/16.
//  Copyright © 2016 Dempsy. All rights reserved.
//

import Foundation

class baseClass{
    
    func cacheSetString(key: String,value: String){
        let userInfo = NSUserDefaults()
        userInfo.setValue(value, forKey: key)
    }
    
    func cacheGetString(key: String) -> String{
        let userInfo = NSUserDefaults()
        let tmpSign = userInfo.stringForKey(key)
        return tmpSign!
    }
}