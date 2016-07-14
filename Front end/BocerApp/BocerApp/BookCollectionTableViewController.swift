////
////  BookCollectionTableViewController.swift
////  BocerApp
////
////  Created by Dempsy on 7/12/16.
////  Copyright © 2016 Dempsy. All rights reserved.
////
//
//import UIKit
//
//class BookCollectionTableViewController: UITableViewController {
//
//    private var mNavBar: UINavigationBar!
//    private var listBooks: NSMutableArray!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Uncomment the following line to preserve selection between presentations
//        // self.clearsSelectionOnViewWillAppear = false
//
//        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//        //设置导航栏
//        let screenMaxX = UIScreen.mainScreen().bounds.maxX
//        mNavBar = UINavigationBar(frame: CGRectMake(0,0,screenMaxX,54))
//        mNavBar?.translucent = true
//        mNavBar?.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
//        mNavBar?.shadowImage = UIImage()
//        mNavBar?.backgroundColor = usefulConstants().defaultColor
//        
//        //设置状态栏颜色
//        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
//        
//        let navTitleAttribute: NSDictionary = NSDictionary(object: UIColor.whiteColor(), forKey: NSForegroundColorAttributeName)
//        mNavBar?.titleTextAttributes = navTitleAttribute as? [String : AnyObject]
//        
//        self.view.addSubview(mNavBar!)
//        mNavBar?.pushNavigationItem(onMakeNavitem(), animated: true)
//        
//        let bundle = NSBundle.mainBundle()
//        let plistPath: String! = bundle.pathForResource("books", ofType: "plist")
//        listBooks = NSMutableArray(contentsOfFile:  plistPath)
//        //TODO:
//        let item : NSDictionary = NSDictionary(objects:["http://c.hiphotos.baidu.com/video/pic/item/f703738da977391224eade15fb198618377ae2f2.jpg","新增数据", NSDate().description] , forKeys: ["video_img","video_title","video_subTitle"])
//        listBooks.insertObject(item, atIndex: 0)
//        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
//        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//    }
//    
//    //创建一个导航项
//    private func onMakeNavitem()->UINavigationItem{
//        let backBtn = UIBarButtonItem(title: "ㄑBack", style: .Plain,
//                                      target: self, action: #selector(BookCollectionTableViewController.onCancel))
//        backBtn.tintColor = UIColor.whiteColor()
//        let doneBtn = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(BookCollectionTableViewController.onDone))
//        doneBtn.tintColor = UIColor.whiteColor()
//        let mNavItem = UINavigationItem()
//        mNavItem.title = "SIGN IN"
//        mNavItem.setLeftBarButtonItem(backBtn, animated: true)
//        mNavItem.setRightBarButtonItem(doneBtn, animated: true)
//        return mNavItem
//    }
//    
//    @objc private func onDone() {
//        let alertController = UIAlertController(title: nil, message: nil,
//                                                preferredStyle: .ActionSheet)
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelHandler)
//        let sellAction = UIAlertAction(title: "Sell Another Book", style: .Default, handler: sellHandler)
//        alertController.addAction(cancelAction)
//        alertController.addAction(sellAction)
//        self.presentViewController(alertController, animated: true, completion: nil)
//    }
//    
//    @objc private func onCancel() {
//        self.navigationController?.popViewControllerAnimated(true)
//    }
//
//    private func cancelHandler(alert: UIAlertAction!) {
//        self.presentedViewController?.dismissViewControllerAnimated(false, completion: nil)
//    }
//    
//    private func sellHandler(alert: UIAlertAction!) {
//        
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    // MARK: - Table view data source
//
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return listBooks.count
//    }
//
//    //为表视图单元格提供数据，该方法是必须实现的方法
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cellIdentifier : String = "bookItem"
//        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! BookCollectionTableViewCell
//        let row = indexPath.row
//        let rowDict : NSDictionary = listBooks.objectAtIndex(row) as! NSDictionary
//        let url : String = rowDict.objectForKey("video_img") as! String
//        let dataImg : NSData = NSData(contentsOfURL: NSURL(string : url)!)!
//        cell.bookPhotoIV.image = UIImage(data: dataImg)
//        cell.bookCaptionLabel.text = rowDict.objectForKey("video_title") as? String
//        cell.authorLabel.text = rowDict.objectForKey("video_subTitle") as? String
//        return cell
//        
//    }
//    
//    // Override to support conditional editing of the table view.
//    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
//
//    
//    // Override to support editing the table view.
//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            // Delete the row from the data source
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        } else if editingStyle == .Insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
//    }
//    
//
//    
//    // Override to support rearranging the table view.
//    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
//        if fromIndexPath != toIndexPath{
//            let object: AnyObject = listBooks.objectAtIndex(fromIndexPath.row)
//            listBooks.removeObjectAtIndex(fromIndexPath.row)
//            if toIndexPath.row > self.listBooks.count{
//                self.listBooks.addObject(object)
//            }else{
//                self.listBooks.insertObject(object, atIndex: toIndexPath.row)
//            }
//        }
//    }
//    
//
//    // Override to support conditional rearranging of the table view.
//    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // Return false if you do not want the item to be re-orderable.
//        return true
//    }
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
