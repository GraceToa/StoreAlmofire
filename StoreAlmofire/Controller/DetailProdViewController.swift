//
//  DetailProdViewController.swift
//  StoreAlmofire
//
//  Created by GraceToa on 02/07/2019.
//  Copyright © 2019 GraceToa. All rights reserved.
//

import UIKit
import Alamofire

class DetailProdViewController: UIViewController {
    
    @IBOutlet weak var imageP: UIImageView!
    @IBOutlet weak var productL: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var linea: UILabel!
    @IBOutlet weak var proveedor: UILabel!
    @IBOutlet weak var descriptionP: UILabel!
    
    var product: Product!
    var codigoP = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        productL.text = product.producto
        price.text = "\(product.precio_compra)\("$")"
        linea.text = product.linea
        proveedor.text = product.proveedor
        descriptionP.text = product.descripcion
        descriptionP.numberOfLines = 0
        codigoP = product.codigo
        getImage(codigo: codigoP)
        
    }
    
    // MARK: - Private method
    
    func getImage(codigo: String) {
        let url_img = "http://127.0.0.1/~gracetoa/rest/public/img/productos/"
        let imgUrl = url_img + "\(codigo)"
        Alamofire.request(imgUrl).responseData { (response) in
            if response.error == nil {
                if let data = response.data {
                    self.imageP.image = UIImage(data: data)
                }
            }
        }
    }

    // MARK: - Actions method

    @IBAction func addCar(_ sender: UIButton) {
        
        Singleton.shared.append(product)
        let alert = UIAlertController(title: "Add Product", message: "Do you want add it?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    

}
