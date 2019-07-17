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
    
    // MARK: - UITableView methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Singleton.shared.getCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let url_img = "http://127.0.0.1/~gracetoa/rest/public/img/productos/"
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
    
    // MARK: - Private methods
    
    @IBAction func doOrder(_ sender: UIButton) {
       let url_order = "http://127.0.0.1/~gracetoa/rest/index.php/orders/create_order"
       let user_id = UserDefaults.standard.string(forKey: "sesion")!
       let products = Singleton.shared.itemsProduct

        if products.isEmpty == false {
            var codigos = [String]()
            //for save product.codigo in db
            for p in products {
                codigos.append(p.codigo)
            }
            
            let fields: Parameters = [
                "id": user_id,
                "items":  codigos
            ]
            
            Alamofire.request(url_order,method: .post, parameters: fields).responseJSON{(response)in
                print(response)
                
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    let error = jsonData["error"] as! Int
                    let id_order = jsonData["orden_id"] as! Int
                    
                    if (error == 0) {
                        Singleton.shared.removeAll()
                        self.total = 0.0
                        self.price.text = String(self.total)
                        self.tableStore.reloadData()
                        
                        let alert = UIAlertController(title: "Success", message: "Order Updated Successfully", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "\("Your Order:")\(" ")\(id_order)\(" ")\(" has been processed")", style: .default, handler: { action in
                            switch action.style{
                            case .default:
                                print("default")
                                
                            case .cancel:
                                print("cancel")
                                
                            case .destructive:
                                print("destructive")
                                
                            @unknown default:
                                print("unknown")
                            }}))
                        self.present(alert, animated: true, completion: nil)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            
                            alert.dismiss(animated: true, completion: nil)
                        }
                    }
                    
                }
            }
        }else{
            let alert = UIAlertController(title: "Alert", message: "Cannot process your order, Your cart is empty!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func totalPriceProduct()  {
        total = 0.0
        for price in Singleton.shared.itemsProduct {
            total += Double(price.precio_compra)!
        }
        price.text = "\("TOTAL:")\(" ")\(String(total))\("$")"
    }
    
    func updateTotal(p: Product)  {
        total -= Double(p.precio_compra)!
        price.text = "\("TOTAL:")\(" ")\(String(total))\("$")"
        
    }
    
}
