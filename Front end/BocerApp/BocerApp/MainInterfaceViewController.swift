//
//  MainInterfaceViewController.swift
//  BocerApp
//
//  Created by Dempsy on 7/5/16.
//  Copyright © 2016 Dempsy. All rights reserved.
//

import UIKit

class MainInterfaceViewController: UIViewController, UIGestureRecognizerDelegate{

    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.navigationController?.navigationBar.addSubview(searchBar)
        searchBar.tintColor = .clearColor()
        searchBar.backgroundColor = .clearColor()
        searchBar.barTintColor = .clearColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        if (self.navigationController != nil)
        {self.navigationController!.interactivePopGestureRecognizer!.enabled = false}
    }
    
    @IBAction func searchBtnFired(sender: UIButton) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func leftBtnFired(sender: UIButton) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.toggleLeftDrawer(sender, animated: false)
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
