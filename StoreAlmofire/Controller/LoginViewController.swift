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
        
        if userTF.text == "" || passwordTF.text == "" {
            let alert = UIAlertController(title: "Error Login", message: "The fields are empty!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else {
            
            let url = "http://127.0.0.1/~gracetoa/rest/index.php/login/login_iOS"
            let fields: Parameters = [
                "email": userTF.text!,
                "passw": passwordTF.text!
            ]
            
            Alamofire.request(url,method: .post, parameters: fields).responseJSON{(response)in
                if let result = response.result.value {
                    let jsonData = result as! NSDictionary
                    
                    let resp = jsonData["error"] as! Int
                    
                    if (resp == 0) {
                        self.idUser = jsonData["id_user"] as! String
                        UserDefaults.standard.set(self.idUser, forKey: "sesion")
                        self.performSegue(withIdentifier: "ShowLogin", sender: self)
                        self.cleanLogin()
                    }else {
                        let alert = UIAlertController(title: "Error Login", message: "The username or password is incorrect!", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func register(_ sender: UIButton) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func cleanLogin(){
        userTF.text = ""
        passwordTF.text = ""
    }
    
}
