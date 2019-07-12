//
//  ByCategoryViewController.swift
//  StoreAlmofire
//
//  Created by GraceToa on 04/07/2019.
//  Copyright © 2019 GraceToa. All rights reserved.
//

import UIKit
import Alamofire

class ByCategoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var tableByCateg: UITableView!

    var product: Product!
    var category: Category!
    var products = [Product]()
    var idCategory = ""
    var url_categ = "http://127.0.0.1/~gracetoa/rest/index.php/products/by_typeProduct/"
    var url_img = "http://127.0.0.1/~gracetoa/rest/public/img/productos/"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableByCateg.delegate = self
        tableByCateg.dataSource = self
        idCategory = category.id
        getProductByCategory()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return  products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableByCateg.dequeueReusableCell(withIdentifier: "cellByCat", for: indexPath) as! ByCategoryTableViewCell
        let p = products[indexPath.row]
        cell.productByC.text = p.producto
        cell.lineaByC.text = p.proveedor
        let imgUrl = url_img + "\(p.codigo)"
        Alamofire.request(imgUrl).responseData { (response) in
            if response.error == nil {
                if let data = response.data {
                    cell.imageByC.image = UIImage(data: data)
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowDetailFromByCategory", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetailFromByCategory" {
            if let id = tableByCateg.indexPathForSelectedRow {
                let f = products[id.row]
                let destin = segue.destination as! DetailProdViewController
                destin.product = f
            }
        }
    }

    
    // MARK: - Navigation

    func getProductByCategory()  {
        let url = url_categ + "\(idCategory)"
       
        Alamofire.request(url).responseJSON{(response) in
            
            if let result = response.result.value {
            let jsonData = result as! NSDictionary

            let anyObj: AnyObject? = jsonData["productos"] as AnyObject
            let initViewC = InitViewController()
            self.products = initViewC.parseJSON(prod: anyObj!)

            DispatchQueue.main.async {
                self.tableByCateg.reloadData()
                }
                print("BY PRO")
                for p in self.products {
                    print(p.producto)
                }

            }
        }
    
    }

}
