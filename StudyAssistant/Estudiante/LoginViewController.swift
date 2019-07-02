//
//  LoginViewController.swift
//  StudyAssistant
//
//  Created by Kurosaki Ryuugo on 6/27/19.
//  Copyright © 2019 Team cibertec. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {

    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtClave: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func ingresar(_ sender: Any) {
        let usuario = self.txtUsuario.text!
        let clave = self.txtClave.text!
        var json = JSON()
        DispatchQueue.main.async {
            let url = "http://192.168.56.1:8080/SAService/rest/estudiante/buscar_estudiante?usuario="+usuario+"&clave="+clave
            Alamofire.request(url).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    json = JSON(value)
                    print(value)
                    UserDefaults.standard.set(json["id"].stringValue, forKey: "user_id")
                    if UserDefaults.exists(key: "user_id") {
                        print("ENtre")
                        let passview: InstitutoViewController = InstitutoViewController()
                        self.present(passview, animated: false, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "Error", message: "No se Encontro Usuario", preferredStyle: .alert)
                        let cancel_a = UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction) -> Void in})
                        alert.addAction(cancel_a)
                        self.present(alert, animated: true, completion: nil)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
    }
    
    @IBAction func registrar(_ sender: Any) {
        let passview: RegistrarseViewController = RegistrarseViewController()
        self.present(passview, animated: false, completion: nil)
    }
    
}
extension UserDefaults {
    static func exists(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
}
