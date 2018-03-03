//
//  ViewControllerTableViewCell.swift
//  FIRDBExample
//
//  Created by Dalton Ng on 13/2/18.
//  Copyright © 2018 AppsLab. All rights reserved.
//

import UIKit

class ViewControllerTableViewCell: UITableViewCell {

    //labels connected
    //@IBOutlet weak var title: UILabel!
    @IBOutlet weak var title: UITextView!
    //@IBOutlet weak var author: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    //@IBOutlet weak var timeStamp: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
