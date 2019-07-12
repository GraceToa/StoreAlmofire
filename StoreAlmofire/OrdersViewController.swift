//
//  OrdersViewController.swift
//  StoreAlmofire
//
//  Created by GraceToa on 06/07/2019.
//  Copyright © 2019 GraceToa. All rights reserved.
//

import UIKit

class OrdersViewController: UIViewController {
    
    let codigos = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()
        getOrderProduct()
    }
    

    // MARK: - Navigation
    func getOrderProduct()  {
        print("ORDERS ")
        
        let itemProducts = Singleton.shared.itemsProduct
        
        for p in itemProducts {
            print(p.codigo)
        }
    }
  

}
