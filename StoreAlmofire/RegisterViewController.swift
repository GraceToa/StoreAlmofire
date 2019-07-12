//
//  RegisterViewController.swift
//  StoreAlmofire
//
//  Created by GraceToa on 24/06/2019.
//  Copyright © 2019 GraceToa. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var lastnameTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    var image: UIImage?
    var imagePicker: UIImagePickerController = UIImagePickerController()
    var url_register = "http://127.0.0.1/~gracetoa/rest/index.php/login/createUser"

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    // MARK: - Actions Method

    @IBAction func register(_ sender: UIButton) {
        
        let fields: Parameters = [
            "email":  emailTF.text!,
            "passw": passwordTF.text!,
            "name": nameTF.text!,
            "lastname": lastnameTF.text!,
            "address": addressTF.text!,
            "country": countryTF.text!
        ]
        
        let imageEnd = image?.jpegData(compressionQuality: 0.75)
        let nameImage = UUID().uuidString

        Alamofire.upload(multipartFormData: { (multipartFormData) in

            multipartFormData.append(imageEnd!, withName: "image", fileName: "\(nameImage).jpeg", mimeType: "image/jpeg")

            for (key, val) in fields {
                multipartFormData.append((val as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }

        }, to: url_register) { (resultado) in

            switch resultado {

            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    print(response)
                    if let result = response.result.value {
                        let jsonData = result as! NSDictionary
                        
                       let resp = jsonData["error"] as! Int
                        
                        if (resp == 1) {
                            self.cleanTextFields()
                            let message = jsonData["message"] as! String
                            let alert = UIAlertController(title: "SIGN UP", message: message, preferredStyle: .actionSheet)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }else {
                            print("ERROR login")
                        }
                    }
                })
            case .failure(let error):
                print("Error load image", error)
            }

        }
    }
    
    
    @IBAction func exit(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func cleanTextFields() {
        nameTF.text = ""
        lastnameTF.text = ""
        emailTF.text = ""
        passwordTF.text = ""
        countryTF.text = ""
        addressTF.text = ""
        imageV.image = UIImage(named: "placeholder")
    }
    
}

extension RegisterViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK:- UIImagePickerControllerDelegate methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageTake = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        image = imageTake!
        imageV.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK:- Add Picture
    
    @IBAction func galery(sender: AnyObject) {
        
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)) {
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            
            present(imagePicker, animated: true, completion: nil)
        } else {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion:nil)
        }
    }
    
}

extension UIImageView {
    func makeRounded() {
        let radius = self.frame.size.height/2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
