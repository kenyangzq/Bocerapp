//
//  adjustPhoneNumber.swift
//  BocerApp
//
//  Created by Dempsy on 7/11/16.
//  Copyright © 2016 Dempsy. All rights reserved.
//

import Foundation

extension String {
    mutating func adjustPhoneNumber() {
        var count = 0
//        var flag = true
        for characters in self.characters {
//            if (characters < "0" || characters > "9") {
//                flag = false
//                break
//            }
            count += 1
        }
        if (count == 10) {
            var newNumber = self
            newNumber.insert("(", atIndex: newNumber.startIndex)
            newNumber.insert(")", atIndex: newNumber.startIndex.advancedBy(4))
            newNumber.insert(" ", atIndex: newNumber.startIndex.advancedBy(5))
            newNumber.insert(" ", atIndex: newNumber.startIndex.advancedBy(9))
            newNumber.insert("-", atIndex: newNumber.startIndex.advancedBy(10))
            newNumber.insert(" ", atIndex: newNumber.startIndex.advancedBy(11))
            self = newNumber
        }
    }
}