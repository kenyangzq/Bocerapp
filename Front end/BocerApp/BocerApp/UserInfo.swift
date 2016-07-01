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
        var first: String?
        var last: String?
    }
    private var name: nameForm?
    private var phoneNumber:String?
    private var email:String?
    private var password:String?
    private var college:String?
    private var paymentInfo = PaymentInfo?()
    private var personalStatus = UserStatus?()
    
    init () {
        name = nil
        phoneNumber = nil
        email = nil
        password = nil
        college = nil
        paymentInfo = nil
        personalStatus = nil
    }
    
    internal func setName(mFirst: String, mLast: String) {
        name?.first = mFirst
        name?.last = mLast
        base.cacheSetString("user first name", value: mFirst)
        base.cacheSetString("user last name", value: mLast)
    }
    
    internal func setEmail(mEmail: String) {
        email = mEmail
        base.cacheSetString("user email", value: mEmail)
    }
    
    internal func setPassword(mPassword: String) {
        let unprotectedPW = mPassword
        password = unprotectedPW.md5()
        base.cacheSetString("user protected password", value: password!)
    }
    
    internal func getName() -> (mFirst: String?, mLast: String?) {
        return (base.cacheGetString("user first name"), base.cacheGetString("user last name"))
    }
    
    internal func getPassword() -> String? {
        return base.cacheGetString("user protected password")
    }

    internal func getEmail() -> String? {
        return base.cacheGetString("user email")
    }
    
    //TODO: Payment Info和Personal Status的设置
}