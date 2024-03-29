//
//  RegistrarseViewController.swift
//  StudyAssistant
//
//  Created by Kurosaki Ryuugo on 6/27/19.
//  Copyright © 2019 Team cibertec. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class RegistrarseViewController: UIViewController {

    @IBOutlet weak var returnLogin: UIBarButtonItem!
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtApellido: UITextField!
    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtClave: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func Registrar(_ sender: Any) {
        if self.txtNombre.text!.count==0 || self.txtApellido.text!.count==0 || self.txtUsuario.text!.count==0 || self.txtClave.text!.count==0 {
            let alert_r = UIAlertController(title: "Error", message: "Inserte todos los Campos", preferredStyle: .alert)
            let cancel_r = UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction) -> Void in})
            alert_r.addAction(cancel_r)
            present(alert_r, animated: true, completion: nil)
        } else {
            let objEst = Estudiante(id: nil, usuario: self.txtUsuario.text!, clave: self.txtClave.text!, nombre: self.txtNombre.text!, apellido: self.txtApellido.text!, iddep: nil, idprov: nil, iddis: nil)
            DispatchQueue.main.async {
                let url = "http://192.168.56.1:8080/SAService/rest/estudiante/insert_estudiante"
                let parameters = [
                    "usuario": objEst.usuario,
                    "clave": objEst.clave,
                    "nombre": objEst.nombre,
                    "apellido": objEst.apellido
                ]
                Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                    switch response.result {
                    case .success(let value):
                        print(value)
                        let b = "\(value)"
                        if b == "1" {
                            let alert_t = UIAlertController(title: "Completado", message: "Usuario Creado", preferredStyle: .alert)
                            let done_a = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
                                let passview: LoginViewController = LoginViewController()
                                self.present(passview, animated: true, completion: nil)
                            }
                            alert_t.addAction(done_a)
                            self.present(alert_t, animated: true, completion: nil)
                        } else {
                            let alert_f = UIAlertController(title: "Error", message: "Usuario ya Existente", preferredStyle: .alert)
                            let cancel_a = UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction) -> Void in})
                            alert_f.addAction(cancel_a)
                            self.present(alert_f, animated: true, completion: nil)
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    
    @IBAction func volverLogin(_ sender: Any) {
        let passview: LoginViewController = LoginViewController()
        self.present(passview, animated: false, completion: nil)
    }
    
}
