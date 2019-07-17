//
//  OrdersViewController.swift
//  StoreAlmofire
//
//  Created by GraceToa on 15/07/2019.
//  Copyright © 2019 GraceToa. All rights reserved.
//

import UIKit
import Alamofire

class OrdersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    
    @IBOutlet weak var tableOrders: UITableView!
    
    var orders = [Order]()
    var products = [Product]()
    var user_id = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        user_id = UserDefaults.standard.string(forKey: "sesion")!
   
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getOrders()
    }
    
    // MARK: - UITableView methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableOrders.dequeueReusableCell(withIdentifier: "cellOrders", for: indexPath) as! OrdersTableViewCell
        let orderC = orders[indexPath.row]
        cell.idOrder.text = orderC.id
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowOrderDetail", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowOrderDetail" {
            if let id = self.tableOrders.indexPathForSelectedRow {
                let o = orders[id.row]
                let destin = segue.destination as! OrderViewController
                destin.order = o
            }
        }
    }
    
    // MARK: - Private methods

    func getOrders()  {
        let url = "http://127.0.0.1/~gracetoa/rest/index.php/orders/get_ordersiOS"
        let fields: Parameters = [
            "id": user_id
        ]
        
        Alamofire.request(url,method: .post, parameters: fields).responseJSON{(response)in
            if let result = response.result.value {
                let jsonData = result as! NSDictionary
                let error = jsonData["error"] as! Int
                
                if (error == 0){
                    let orders = jsonData["orders"] as AnyObject
                    self.orders =  self.parseJSON(prod: orders)
                    
                    DispatchQueue.main.async {
                        self.tableOrders.reloadData()
                    }
                }else{
                    print("Not exist orders")
                }
            }else{
                print("Error response")
            }
        }
    }
    
    func parseJSON(prod: AnyObject) -> Array<Order>{
        var listProducts: Array<Product> = []
        var listOrders: Array<Order> = []
        
        if prod is Array<AnyObject> {
            var p:Product = Product()
            var o:Order = Order()
            
            for json in prod  as! Array<AnyObject>{
                
               let date = (json["creado_en"] as AnyObject? as? String ?? "")
                let id = (json["id"] as AnyObject? as? String ?? "")

                let detalle = json["detalle"] as AnyObject
                
                for jsond in detalle as! Array<AnyObject>{
                    p.codigo = (jsond["codigo"] as AnyObject? as? String ?? "")
                    p.producto = (jsond["producto"] as AnyObject? as? String ?? "")
                    p.linea = (jsond["linea"] as AnyObject? as? String ?? "")
                    p.linea_id = (jsond["linea_id"] as AnyObject? as? String ?? "")
                    p.proveedor = (jsond["proveedor"] as AnyObject? as? String ?? "")
                    p.descripcion = (jsond["descripcion"] as AnyObject? as? String ?? "")
                    p.precio_compra = (jsond["precio_compra"] as AnyObject? as? String ?? "")
                    
                    listProducts.append(p)
    
                }
                o.date = date
                o.id = id
                o.productOrder = listProducts
                listOrders.append(o)
                listProducts.removeAll()
            }
        }
        return listOrders
    }
}

struct Order {
    var id = ""
    var date = ""
    var productOrder = [Product]()
    
}
