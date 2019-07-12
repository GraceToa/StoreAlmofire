//
//  StoreTableViewCell.swift
//  StoreAlmofire
//
//  Created by GraceToa on 08/07/2019.
//  Copyright © 2019 GraceToa. All rights reserved.
//

import UIKit

class StoreTableViewCell: UITableViewCell {

    @IBOutlet weak var imageS: UIImageView!
    
    @IBOutlet weak var productS: UILabel!
    
    @IBOutlet weak var priceS: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
