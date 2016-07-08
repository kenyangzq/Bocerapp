//
//  UserInfo.swift
//  BocerApp
//
//  Created by Dempsy on 6/27/16.
//  Copyright © 2016 Dempsy. All rights reserved.
//

import Foundation

class UserInfo {
    
    private let base = baseClass()
    private struct nameForm {
        var first: String
        var last: String
    }
    private var name: nameForm
    private var phoneNumber:String
    private var email:String
    private var password:String
    private var imageString: String
    private var paymentInfo = PaymentInfo?()
    private var personalStatus = UserStatus?()
    
    init () {
        name = nameForm(first: "", last: "")
        phoneNumber = ""
        email = ""
        password = ""
        imageString = ""
        paymentInfo = nil
        phoneNumber = ""
        personalStatus = nil
    }
    
    internal func setName(mFirst: String, mLast: String) {
        base.cacheSetString("user first name", value: mFirst)
        base.cacheSetString("user last name", value: mLast)
    }
    
    internal func setEmail(mEmail: String) {
        base.cacheSetString("user email", value: mEmail)
    }
    
    internal func setPhoneNumber(mPhoneNumber: String) {
        base.cacheSetString("user phone number", value: mPhoneNumber)
    }
    
    internal func setPassword(mPassword: String) {
        base.cacheSetString("user protected password", value: mPassword)
    }
    
    internal func setImageString(mImageString: String) {
        base.cacheSetString("user image string", value: mImageString)
    }
    
    internal func getName() -> (mFirst: String?, mLast: String?) {
        name.first = base.cacheGetString("user first name")
        var first: String?
        if name.first == "" {first = nil} else {first = name.first}
        name.last = base.cacheGetString("user last name")
        var last: String?
        if name.last == "" {last = nil} else {last = name.last}
        return (first, last)
    }
    
    internal func getPassword() -> String? {
        password = base.cacheGetString("user protected password")
        if password == "" {return nil}
        return password
    }
    
    internal func getPhoneNumber() -> String? {
        phoneNumber = base.cacheGetString("user phone number")
        if phoneNumber == "" {return nil}
        return phoneNumber
    }

    internal func getEmail() -> String? {
        email = base.cacheGetString("user email")
        if email == "" {return nil}
        return email
    }
    
    internal func getImageString() -> String? {
        imageString = base.cacheGetString("user image string")
        if imageString == "" {return nil}
        return imageString
    }
    
    //TODO: Payment Info和Personal Status的设置
}