//
//  BookInfo.swift
//  BocerApp
//
//  Created by Dempsy on 7/14/16.
//  Copyright © 2016 Dempsy. All rights reserved.
//

import Foundation

class BookInfo:NSObject, NSURLConnectionDataDelegate {
    
    private var username: String = ""
    private var bookID: String = ""
    private var ISBN: String? = nil
    private var author: String? = nil
    private var edition: String? = nil
    private var className: String? = nil
    private var price: String? = nil
    private var imagenum: String? = nil
    private var dataChunk = NSMutableData()
    
    init(mUsername: String, mBookID: String) {
        super.init()
        username = mUsername
        bookID = mBookID
        retrieveBookInfo()
    }
    
    internal func getUsername() -> String {
        return username
    }
    
    internal func getISBN() -> String? {
        return ISBN
    }
    
    internal func getAuthor() -> String? {
        return author
    }
    
    internal func getEdition() -> String? {
        return edition
    }
    
    internal func getClassname() -> String? {
        return className
    }
    
    internal func getPrice() -> String? {
        return price
    }
    
    private func retrieveBookInfo() {
        let dataString = NSString.localizedStringWithFormat("{\"username\":\"%@\"}",bookID)
        let sent = NSData(data: dataString.dataUsingEncoding(NSASCIIStringEncoding)!)
        let dataLength = NSString.localizedStringWithFormat("%ld", sent.length)
        let path = usefulConstants().domainAddress + "/login"
        let url = NSURL(string: path)
        print("login request address: \(path)\n")
        let request = NSMutableURLRequest()
        request.URL = url
        request.HTTPMethod = "POST"
        request.setValue(dataLength as String, forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = sent
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        dataChunk = NSMutableData()
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        dataChunk.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        let backmsg: AnyObject! = try! NSJSONSerialization.JSONObjectWithData(dataChunk, options: NSJSONReadingOptions(rawValue: 0))
        print("back msg is \(backmsg)")
        let targetAction = backmsg.objectForKey("Target Action") as! String?
        let content = backmsg.objectForKey("content") as! String?
        print("back message is \(backmsg)")
        //普通登录
        if targetAction == "loginresult" {
            if content == "success" {
                //获取用户其他信息
                let bodydata = backmsg.objectForKey("body") as! NSDictionary
                print("body data is \(bodydata)")
                ISBN = bodydata["ISBN"] as! NSString as String
                author = bodydata["author"] as! NSString as String
                edition = bodydata["edition"] as! NSString as String
                className = bodydata["className"] as! NSString as String
                price = bodydata["price"] as! NSString as String
                imagenum = bodydata["imagenum"] as! NSString as String
                print("retrieve book info success\n")
            }
            else {
                
                print("connection fails when retriving book info")
            }
        } else {
            print("unexpected server issues when retriving book info")
        }
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        print("connection failure when retriving book info")
    }

    
}
