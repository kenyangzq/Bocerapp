//
//  BookCollectionTableViewController.swift
//  BocerApp
//
//  Created by Dempsy on 7/12/16.
//  Copyright © 2016 Dempsy. All rights reserved.
//

import UIKit

class BookCollectionTableViewController: UITableViewController, NSURLConnectionDataDelegate{

    private var mNavBar: UINavigationBar!
    private var listBooks = NSMutableArray()
    private var dataChunk = NSMutableData()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //设置导航栏
        let screenMaxX = UIScreen.mainScreen().bounds.maxX
        mNavBar = UINavigationBar(frame: CGRectMake(0,0,screenMaxX,54))
        mNavBar?.translucent = true
        mNavBar?.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        mNavBar?.shadowImage = UIImage()
        mNavBar?.backgroundColor = usefulConstants().defaultColor
        
        //设置状态栏颜色
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        let navTitleAttribute: NSDictionary = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName)
        mNavBar?.titleTextAttributes = navTitleAttribute as? [String : AnyObject]
        
        self.view.addSubview(mNavBar!)
        mNavBar?.pushNavigationItem(onMakeNavitem(), animated: true)
        
        retrieveBookCollection()
    }
    
    //创建一个导航项
    private func onMakeNavitem()->UINavigationItem{
        let backBtn = UIBarButtonItem(title: "ㄑBack", style: .Plain,
                                      target: self, action: #selector(BookCollectionTableViewController.onCancel))
        backBtn.tintColor = UIColor.whiteColor()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(BookCollectionTableViewController.onDone))
        doneBtn.tintColor = UIColor.whiteColor()
        let mNavItem = UINavigationItem()
        mNavItem.title = "BOOK COLLECTION"
        mNavItem.setLeftBarButtonItem(backBtn, animated: true)
        mNavItem.setRightBarButtonItem(doneBtn, animated: true)
        return mNavItem
    }
    
    @objc private func onDone() {
        let alertController = UIAlertController(title: nil, message: nil,
                                                preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelHandler)
        let sellAction = UIAlertAction(title: "Sell Another Book", style: .Default, handler: sellHandler)
        alertController.addAction(cancelAction)
        alertController.addAction(sellAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @objc private func onCancel() {
        self.navigationController?.popViewControllerAnimated(true)
    }

    private func cancelHandler(alert: UIAlertAction!) {
        self.presentedViewController?.dismissViewControllerAnimated(false, completion: nil)
    }
    
    private func sellHandler(alert: UIAlertAction!) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listBooks.count
    }

    //为表视图单元格提供数据，该方法是必须实现的方法
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier : String = "bookItem"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! BookCollectionTableViewCell
        let row = indexPath.row
        let rowDict : NSDictionary = listBooks.objectAtIndex(row) as! NSDictionary
        let url : String = rowDict.objectForKey("video_img") as! String
        let dataImg : NSData = NSData(contentsOfURL: NSURL(string : url)!)!
        cell.bookPhotoIV.image = UIImage(data: dataImg)
        cell.bookCaptionLabel.text = rowDict.objectForKey("video_title") as? String
        cell.authorLabel.text = rowDict.objectForKey("video_subTitle") as? String
        return cell
        
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        if fromIndexPath != toIndexPath{
            let object: AnyObject = listBooks.objectAtIndex(fromIndexPath.row)
            listBooks.removeObjectAtIndex(fromIndexPath.row)
            if toIndexPath.row > self.listBooks.count{
                self.listBooks.addObject(object)
            }else{
                self.listBooks.insertObject(object, atIndex: toIndexPath.row)
            }
        }
    }
    

    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

    private func retrieveBookCollection() {
        let email = UserInfo().getEmail()
        let dataString = NSString.localizedStringWithFormat("{\"username\":\"%@\"}",email!)
        let sent = NSData(data: dataString.dataUsingEncoding(NSASCIIStringEncoding)!)
        let dataLength = NSString.localizedStringWithFormat("%ld", sent.length)
        let path = usefulConstants().domainAddress + "/retrieveBookBasicInfo"
        let url = NSURL(string: path)
        print("login request address: \(path)\n")
        let request = NSMutableURLRequest()
        request.URL = url
        request.HTTPMethod = "POST"
        request.setValue(dataLength as String, forHTTPHeaderField: "Content-Length")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = sent
        
        let conn = NSURLConnection(request: request, delegate: self, startImmediately: true)
        if (conn == nil) {
            let alertController = UIAlertController(title: "Warning",
                                                    message: "Connection Failure.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }

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
        if targetAction == "retrievebookbasicinforesult" {
            if content == "success" {
                //获取用户其他信息
                print("retrieve book collection info success\n")
                let bodydata = backmsg.objectForKey("body") as! NSDictionary
                print("body data is \(bodydata)")
                //TODO: 整理body里面的信息
            }
            else if content == "system error" {
                let alertController = UIAlertController(title: "Warning",
                                                        message: "System error when retriving book collection info", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
                print("System error when retriving book collection info.")
            } else {
                let alertController = UIAlertController(title: "Warning",
                                                        message: "Connection Failure.", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(okAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
                print("connection fails when retriving book collection info")
            }
        }
        else {
            let alertController = UIAlertController(title: "Warning",
                                                    message: "Server Issues.", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(okAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            
            print("unexpected server issues\n")
        }
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        NSLog("%@", error)
        let alertController = UIAlertController(title: "Warning",
                                                message: "Connection Failure.", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        NSLog("connection failed")
        
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
