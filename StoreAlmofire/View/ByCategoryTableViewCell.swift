//
//  ByCategoryTableViewCell.swift
//  StoreAlmofire
//
//  Created by GraceToa on 06/07/2019.
//  Copyright © 2019 GraceToa. All rights reserved.
//

import UIKit

class ByCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productByC: UITextView!
    @IBOutlet weak var lineaByC: UITextView!
    @IBOutlet weak var imageByC: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
