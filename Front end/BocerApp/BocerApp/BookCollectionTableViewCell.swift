//
//  BookCollectionTableViewCell.swift
//  BocerApp
//
//  Created by Dempsy on 7/12/16.
//  Copyright © 2016 Dempsy. All rights reserved.
//

import UIKit

class BookCollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var bookPhotoIV: UIImageView!
    @IBOutlet weak var bookCaptionLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
