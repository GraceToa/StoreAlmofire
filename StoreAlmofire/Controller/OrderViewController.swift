//
//  OrdersViewController.swift
//  StoreAlmofire
//
//  Created by GraceToa on 06/07/2019.
//  Copyright © 2019 GraceToa. All rights reserved.
//

import UIKit
import Alamofire

class OrderViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var welcomeUser: UILabel!
    @IBOutlet weak var orderN: UILabel!
    @IBOutlet weak var dateCreate: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var tableOrder: UITableView!
    
    var order:Order = Order()
    var products = [Product]()
    var user_id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user_id = UserDefaults.standard.string(forKey: "sesion")!
        
        let oN = "\("Order: ")\(order.id)"
        let d = "\("Create: ")\(order.date)"
        orderN.text = oN
        dateCreate.text = d
        orderN.colorString(text: oN, coloredText: order.id, color: .blue)
        dateCreate.colorString(text: d, coloredText: order.date, color: .blue)
        products = order.productOrder
        let totalP = calcTotal(products: products)
        let t = "\("Total:")\(String(totalP))\("$")"
        total.text = t
        total.colorString(text: t, coloredText: "Total:", color: .black)

        getUser()
    }
  
    // MARK: - UITableView methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let url_img = "http://127.0.0.1/~gracetoa/rest/public/img/productos/"
        let cell = tableOrder.dequeueReusableCell(withIdentifier: "cellOrder", for: indexPath) as! OrderTableViewCell
        let p = products[indexPath.row]
        cell.product.text = p.producto
        cell.descriptionO.text = p.descripcion
        cell.price.text = "\(p.precio_compra)\("$")"
        let imgUrl = url_img + "\(p.codigo)"
        Alamofire.request(imgUrl).responseData { (response) in
            if response.error == nil {
                if let data = response.data {
                    cell.imageO.image = UIImage(data: data)
                }
            }
        }
        return cell
    }
    
    // MARK: - Method private

    func getUser()  {
        let url_user = "http://127.0.0.1/~gracetoa/rest/index.php/login/user_ios"

        let fields: Parameters = [
            "id": user_id
        ]
        
        Alamofire.request(url_user,method: .post, parameters: fields).responseJSON{(response)in
            
            if let result = response.result.value {
                let jsonData = result as! NSDictionary
                let error = jsonData["error"] as! Int
                
                if (error == 0) {
                    //swift type array of dictionary
                    if let anyObj = jsonData["user"] as? [[String:Any]] {
                        if let user = anyObj.first {
                            self.welcomeUser.text = "\("Hello ")\(user["name"] as? String ?? "user")\("!, these are your orders:")"
                        }
                    }
                }
            }else {
                print("Error response")
            }
        }
    }
    
    func calcTotal(products: Array<Product>) -> Double {
        var t = 0.0
        for p in products {
            t += Double(p.precio_compra)!
        }
        return t
    }

}

extension UILabel {
    
    func colorString(text: String?, coloredText: String?, color: UIColor? ) {
        
        let attributedString = NSMutableAttributedString(string: text!)
        let range = (text! as NSString).range(of: coloredText!)
        attributedString.setAttributes([NSAttributedString.Key.foregroundColor: color!],
                                       range: range)
        self.attributedText = attributedString
    }
}

