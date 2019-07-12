//
//  LoginViewController.swift
//  StoreAlmofire
//
//  Created by GraceToa on 23/06/2019.
//  Copyright © 2019 GraceToa. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!

    var url = "http://127.0.0.1/~gracetoa/rest/index.php/login/login_iOS"
    var token = ""
    var idUser = ""

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //para mantener abierta la sesion de usuario
        if let sesion = UserDefaults.standard.object(forKey: "sesion") as? String {
            if ( sesion.utf8CString.count > 0){
                self.performSegue(withIdentifier: "ShowLogin", sender: self)
            }
        }
    }
    

    // MARK: - Actions methods

    @IBAction func signIn(_ sender: UIButton) {
        
        let fields: Parameters = [
            "email": userTF.text!,
            "passw": passwordTF.text!
        ]
        
        Alamofire.request(url,method: .post, parameters: fields).responseJSON{(response)in
            print(response)
        
            if let result = response.result.value {
                let jsonData = result as! NSDictionary
                
                let resp = jsonData["error"] as! Int
                print(resp)
                
                self.idUser = jsonData["id_user"] as! String
                print("ID")
                print(self.idUser)

                if (resp == 0) {
                    self.performSegue(withIdentifier: "ShowLogin", sender: self)
                    UserDefaults.standard.set(self.idUser, forKey: "sesion")
                }else {
                    print("ERROR login")
                }
            }
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ShowLogin" {
//
//                let destin = segue.destination as! ProfileViewController
//                destin.user_id = idUser
//
//        }
//    }
    
    @IBAction func register(_ sender: UIButton) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}
