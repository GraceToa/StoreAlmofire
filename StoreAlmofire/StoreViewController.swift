//
//  StoreViewController.swift
//  StoreAlmofire
//
//  Created by GraceToa on 08/07/2019.
//  Copyright © 2019 GraceToa. All rights reserved.
//

import UIKit
import Alamofire

class StoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableStore: UITableView!
    @IBOutlet weak var price: UILabel!
    
    var itemProducts = [Product]()
    let codigos = [String]()
    var url_img = "http://127.0.0.1/~gracetoa/rest/public/img/productos/"
    var total = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableStore.dataSource = self
        tableStore.delegate = self
        tableStore.reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        totalPriceProduct()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Singleton.shared.getCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableStore.dequeueReusableCell(withIdentifier: "cellStore", for: indexPath) as! StoreTableViewCell
        let p = Singleton.shared.getItemAt(position: indexPath.row)!
        cell.productS.text = p.producto
        cell.priceS.text = "\(p.precio_compra)\("$")"
        
        let imgUrl = url_img + "\(p.codigo)"
        Alamofire.request(imgUrl).responseData { (response) in
            if response.error == nil {
                if let data = response.data {
                    cell.imageS.image = UIImage(data: data)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "delete") { (action, indexpath) in
            let product: Product
            product = Singleton.shared.getItemAt(position: indexPath.row)!
            Singleton.shared.removeProduct(product)
            self.updateTotal(p: product)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return [delete]
    }
    
    // MARK: - Navigation
    
    func updateTotal(p: Product)  {
        total -= Double(p.precio_compra)!
        price.text = "\("TOTAL:")\(" ")\(String(total))\("$")"

    }
 
    @IBAction func doOrder(_ sender: UIButton) {
    }
    
    
    
    func totalPriceProduct()  {
        for price in Singleton.shared.itemsProduct {
            total += Double(price.precio_compra)!
        }
        price.text = "\("TOTAL:")\(" ")\(String(total))\("$")"
    }
    
    
    
  

}
