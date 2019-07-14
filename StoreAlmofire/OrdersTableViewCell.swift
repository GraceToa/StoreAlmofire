//
//  OrdersTableViewCell.swift
//  StoreAlmofire
//
//  Created by GraceToa on 14/07/2019.
//  Copyright © 2019 GraceToa. All rights reserved.
//

import UIKit

class OrdersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageO: UIImageView!
    @IBOutlet weak var product: UITextView!
    @IBOutlet weak var descriptionO: UITextView!
    @IBOutlet weak var price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
