//
//  TestViewController.swift
//  StoreAlmofire
//
//  Created by GraceToa on 05/07/2019.
//  Copyright © 2019 GraceToa. All rights reserved.
//

import UIKit
import Alamofire

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableC: UITableView!
    
    var categories = [Category]()
    var url_categories = "http://127.0.0.1/~gracetoa/rest/index.php/lineas"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCategories()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableC.dequeueReusableCell(withIdentifier: "cel", for: indexPath) as! CategoryTableViewCell
        let c = categories[indexPath.row]
        
        cell.nameCateg.text = c.name
   
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowByCategory", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowByCategory" {
            if let id = tableC.indexPathForSelectedRow {
                let f = categories[id.row]
                let destin = segue.destination as! ByCategoryViewController
                destin.category = f
            }
        }
    }
    
    
    func getCategories()  {
        Alamofire.request(url_categories).responseJSON{(response) in
            
                        print(response)
            
            if let result = response.result.value {
                let jsonData = result as! NSDictionary
                
                let anyObj: AnyObject? = jsonData["lineas"] as AnyObject
                
                self.parseJSON2(prod: anyObj!)
                
                for c in self.categories {
                    print(c.name)
                }
                
                DispatchQueue.main.async {
                    self.tableC.reloadData()
                }
            }
        }
    }
    
    
    func parseJSON2(prod: AnyObject)  {
        if prod is Array<AnyObject> {
            var c:Category = Category()
            for json in prod  as! Array<AnyObject>{
                let linea = (json["linea"] as AnyObject? as? String ?? "")
                let id = (json["id"] as AnyObject? as? String ?? "")

                c.name = linea
                c.id = id
                categories.append(c)
            }
        }
    }


}


struct Category {
    var name: String = ""
    var id: String = ""
}
