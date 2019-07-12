//
//  TableViewCell.swift
//  StoreAlmofire
//
//  Created by GraceToa on 23/06/2019.
//  Copyright © 2019 GraceToa. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageP: UIImageView!
    @IBOutlet weak var product: UITextView!
    @IBOutlet weak var descriptionP: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
