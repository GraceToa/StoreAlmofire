//
//  InitViewController.swift
//  StoreAlmofire
//
//  Created by GraceToa on 23/06/2019.
//  Copyright © 2019 GraceToa. All rights reserved.
//

import UIKit
import Alamofire

class InitViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var shopCar: UIBarButtonItem!
    
    var products = [Product]()
    var res: Any = ()
    var badgeCount = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(leftButtonTouched))
        getProducts()
    }
 
    override func viewDidAppear(_ animated: Bool) {
        self.badgeCount = Singleton.shared.getCount()
        self.setUpBadgeCountAndBarButton()
    }
    
    // MARK: - UITableView methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let url_img = "http://127.0.0.1/~gracetoa/rest/public/img/productos/"
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let product = products[indexPath.row]
        cell.product.text = product.producto
        cell.descriptionP.text = product.descripcion
        
        let imgUrl = url_img + "\(product.codigo)"
        Alamofire.request(imgUrl).responseData { (response) in
            if response.error == nil {
                if let data = response.data {
                    cell.imageP.image = UIImage(data: data)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetail", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            if let id = table.indexPathForSelectedRow {
                let f = products[id.row]
                let destin = segue.destination as! DetailProdViewController
                destin.product = f
            }
        }
    }
    
    
    // MARK: - Private methods
    
    func getProducts()  {
        let url = URL(string: "http://127.0.0.1/~gracetoa/rest/index.php/products/allProductsiOS")
        Alamofire.request(url!).responseJSON{(response) in
            
            if let result = response.result.value {
                let jsonData = result as! NSDictionary

                let anyObj: AnyObject? = jsonData["productos"] as AnyObject
                self.products = self.parseJSON(prod: anyObj!)
                
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            }
        }
    }
    
    func parseJSON(prod: AnyObject) -> Array<Product> {

        var list: Array<Product> = []
        
        if prod is Array<AnyObject> {
            var p:Product = Product()
            
            for json in prod  as! Array<AnyObject>{
                p.codigo = (json["codigo"] as AnyObject? as? String ?? "")
                p.producto = (json["producto"] as AnyObject? as? String ?? "")
                p.linea = (json["linea"] as AnyObject? as? String ?? "")
                p.linea_id = (json["linea_id"] as AnyObject? as? String ?? "")
                p.proveedor = (json["proveedor"] as AnyObject? as? String ?? "")
                p.descripcion = (json["descripcion"] as AnyObject? as? String ?? "")
                p.precio_compra = (json["precio_compra"] as AnyObject? as? String ?? "")
                
                list.append(p)
            }
        }
        return list
    }
    
    func setUpBadgeCountAndBarButton() {
        // badge label
        let label = UILabel(frame: CGRect(x: 10, y: -05, width: 25, height: 25))
        label.layer.borderColor = UIColor.clear.cgColor
        label.layer.borderWidth = 2
        label.layer.cornerRadius = label.bounds.size.height / 2
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.textColor = .white
        label.font = label.font.withSize(12)
        label.backgroundColor = .red
        label.text = "\(self.badgeCount)"
        
        // button
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        rightButton.setBackgroundImage(UIImage(named: "shop_car"), for: .normal)
        rightButton.addTarget(self, action: #selector(rightButtonTouched), for: .touchUpInside)
        rightButton.addSubview(label)
        
        // Bar button item
        let rightBarButtomItem = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem = rightBarButtomItem
    }
    
    // MARK: - Actions methods

    @objc func rightButtonTouched() {
        performSegue(withIdentifier: "ShowOrders", sender: self)
    }
    
    @objc func leftButtonTouched() {
        UserDefaults.standard.removeObject(forKey: "sesion")
        print("SESION USER CLOSED")
        dismiss(animated: true, completion: nil)    }
}

struct Product {
    var codigo: String = ""
    var producto: String = ""
    var linea:String = ""
    var linea_id: String = ""
    var proveedor: String = ""
    var descripcion:String = ""
    var precio_compra: String = ""
}


