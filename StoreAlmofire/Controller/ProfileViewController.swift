//
//  ProfileViewController.swift
//  StoreAlmofire
//
//  Created by GraceToa on 24/06/2019.
//  Copyright © 2019 GraceToa. All rights reserved.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var imageU: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var lastnameTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    
    var user_id = ""
    var resp = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserFromBD()
    }
    
    // MARK: - Private method
    
    func getUserFromBD() {
        user_id = UserDefaults.standard.string(forKey: "sesion")!
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
                            self.nameTF.text = user["name"] as? String
                            self.lastnameTF.text = user["lastname"] as? String
                            self.addressTF.text = user["address"] as? String
                            self.countryTF.text = user["country"] as? String
                            self.emailTF.text = user["email"] as? String
                            
                            let imgUrl = user["image"] as? String
                            Alamofire.request(imgUrl!).responseData { (response) in
                                if response.error == nil {
                                    if let data = response.data {
                                        self.imageU.image = UIImage(data: data)
//                                        self.imageU.makeRounded()
                                    }
                                }
                            }
                        }
                    }
                }else {
                    print("ERROR profile")
                }
            }
        }
    }
 
    // MARK: - Actions

    @IBAction func edit(_ sender: UIButton) {
        let url_edit = "http://127.0.0.1/~gracetoa/rest/index.php/login/edit_user"

        let fields: Parameters = [
            "email": emailTF.text!,
            "name": nameTF.text!,
            "lastname": lastnameTF.text!,
            "address": addressTF.text!,
            "country": countryTF.text!,
            "id": user_id
        ]

        Alamofire.request(url_edit, method: .post, parameters: fields)
            .responseJSON { response in
                if let result = response.value {
                    let jsonData = result as! NSDictionary
                    self.resp = (jsonData.value(forKey: "message") as! String?)!

                    if self.resp == "OK UPDATE"{
                        self.dismiss(animated: true, completion: nil)
                    }else {
                        print("ERROR")
                    }
                }
        }
    }
    
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}


