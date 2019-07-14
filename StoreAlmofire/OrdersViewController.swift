//
//  OrdersViewController.swift
//  StoreAlmofire
//
/*
 <div>Icons made by <a href="https://www.freepik.com/" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/"                 title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/"                 title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>
 */
//  Created by GraceToa on 06/07/2019.
//  Copyright © 2019 GraceToa. All rights reserved.
//

import UIKit
import Alamofire

class OrdersViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var welcomeUser: UILabel!
    @IBOutlet weak var orderN: UILabel!
    @IBOutlet weak var dateCreate: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var tableOrder: UITableView!
       
    var products = [Product]()
    var date = ""
    var idOrder = ""
    var totalP = 0.0
    var url_img = "http://127.0.0.1/~gracetoa/rest/public/img/productos/"
    var url_user = "http://127.0.0.1/~gracetoa/rest/index.php/login/user_ios"
    var user_id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user_id = UserDefaults.standard.string(forKey: "sesion")!
        getUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getOrders()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableOrder.dequeueReusableCell(withIdentifier: "cellOrder", for: indexPath) as! OrdersTableViewCell
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
                    self.products =  self.parseJSON(prod: orders)
                    
                    DispatchQueue.main.async {
                        self.tableOrder.reloadData()
                    }
                }else{
                    print("Not exist orders")
                }
            }else{
                print("Error response")
            }
        }
    }
    
    func parseJSON(prod: AnyObject) -> Array<Product>{
         var list: Array<Product> = []
        if prod is Array<AnyObject> {
            var p:Product = Product()
            
            for json in prod  as! Array<AnyObject>{
                
                date = (json["creado_en"] as AnyObject? as? String ?? "")
                print(date)
                let detalle = json["detalle"] as AnyObject
                
                for jsond in detalle as! Array<AnyObject>{
                    p.codigo = (jsond["codigo"] as AnyObject? as? String ?? "")
                    p.producto = (jsond["producto"] as AnyObject? as? String ?? "")
                    p.linea = (jsond["linea"] as AnyObject? as? String ?? "")
                    p.linea_id = (jsond["linea_id"] as AnyObject? as? String ?? "")
                    p.proveedor = (jsond["proveedor"] as AnyObject? as? String ?? "")
                    p.descripcion = (jsond["descripcion"] as AnyObject? as? String ?? "")
                    p.precio_compra = (jsond["precio_compra"] as AnyObject? as? String ?? "")
    
                    list.append(p)
                    
                    totalP += Double(p.precio_compra)!
                }
                idOrder = (json["id"] as AnyObject? as? String ?? "")
            }
        }
      
        let oN = "\("Order: ")\(idOrder)"
        let d = "\("Create: ")\(date)"
        let t = "\("Total:")\(String(totalP))\("$")"
        orderN.text = oN
        dateCreate.text = d
        total.text = t
        orderN.colorString(text: oN, coloredText: idOrder, color: .blue)
        dateCreate.colorString(text: d, coloredText: date, color: .blue)
        total.colorString(text: t, coloredText: "Total:", color: .black)
        return list
    }
  
    func getUser()  {
        let fields: Parameters = [
            "id": user_id
        ]
        
        Alamofire.request(url_user,method: .post, parameters: fields).responseJSON{(response)in
            print(response)
            
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
