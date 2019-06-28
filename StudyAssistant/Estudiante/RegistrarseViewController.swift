//
//  RegistrarseViewController.swift
//  StudyAssistant
//
//  Created by Kurosaki Ryuugo on 6/27/19.
//  Copyright © 2019 Team cibertec. All rights reserved.
//

import UIKit
import SwiftyJSON
class RegistrarseViewController: UIViewController {

    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtApellido: UITextField!
    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtClave: UITextField!
    let userDefaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    @IBAction func Registrar(_ sender: Any) {
        let objEst = Estudiante(id: nil, usuario: self.txtUsuario.text!, clave: self.txtClave.text!, nombre: self.txtNombre.text!, apellido: self.txtApellido.text!, iddep: nil, idprov: nil, iddis: nil)
        let url = ""
    }

}
