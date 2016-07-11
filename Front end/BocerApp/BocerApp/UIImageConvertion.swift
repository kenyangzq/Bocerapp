//
//  UIImageConvertion.swift
//  BocerApp
//
//  Created by Dempsy on 7/9/16.
//  Copyright © 2016 Dempsy. All rights reserved.
//

import Foundation

class UIImageConvertion {
    func imageToString(mImage: UIImage) -> String {
        let imageData = UIImageJPEGRepresentation(mImage,1.0)
        let string = imageData?.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        return string!
    }
    
    func stringToImage(mString: String) -> UIImage {
        let imageData = NSData(base64EncodedString: mString, options: .IgnoreUnknownCharacters)
        let image = UIImage(data: imageData!)
        return image!
    }
}