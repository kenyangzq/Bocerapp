//
//  LeftDrawer.swift
//  BocerApp
//
//  Created by Dempsy on 7/5/16.
//  Copyright © 2016 Dempsy. All rights reserved.
//

import UIKit

class LeftDrawer: UIViewController {

    @IBOutlet private weak var addPhotoBtn: UIButton!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var editInfoBtn: UIButton!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var historyBtn: UIButton!
    @IBOutlet private weak var saleBtn: UIButton!
    @IBOutlet private weak var buyBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 0.5)
        addPhotoBtn.layer.cornerRadius = 70
        addPhotoBtn.layer.borderColor = UIColor.whiteColor().CGColor
        editInfoBtn.layer.cornerRadius = 20
        historyBtn.layer.cornerRadius = 28
        saleBtn.layer.cornerRadius = 28
        buyBtn.layer.cornerRadius = 28
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
