//
//  ActAddViewController.swift
//  StudyAssistant
//
//  Created by Kurosaki Ryuugo on 7/5/19.
//  Copyright © 2019 Team cibertec. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ActAddViewController: UIViewController {

    @IBOutlet weak var nombretxt: UITextField!
    @IBOutlet weak var descriptxt: UITextView!
    @IBOutlet weak var fechaDate: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func saveActividad(_ sender: Any) {
        let nombre = self.nombretxt.text!
        let descript = self.descriptxt.text!
        let fecha = self.fechaDate.date
        if nombre.count==0 {
            let alert_r = UIAlertController(title: "Error", message: "Inserte Al menos el Nombre", preferredStyle: .alert)
            let cancel_r = UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction) -> Void in})
            alert_r.addAction(cancel_r)
            present(alert_r, animated: true, completion: nil)
        } else {
            let usuario = UserDefaults.standard.object(forKey: "user_id") as! String
            let curso = UserDefaults.standard.object(forKey: "curso_id") as! String
            DispatchQueue.main.async {
                let url = "http://192.168.56.1:8080/SAService/rest/actividad/insert_actividad"
                let params = [
                    "nombre": nombre,
                    "descripcion": descript,
                    "fechafin": fecha,
                    "idcur": curso,
                    "idest": usuario
                    ] as [String : Any]
                Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(let value):
                        print(value)
                        let b = "\(value)"
                        if b == "1" {
                            let alert_t = UIAlertController(title: "Completado", message: "Actividad Creada", preferredStyle: .alert)
                            let done_a = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction) in
                                let passview: ActividadViewController = ActividadViewController()
                                self.present(passview, animated: true, completion: nil)
                            }
                            alert_t.addAction(done_a)
                            self.present(alert_t, animated: true, completion: nil)
                        } else {
                            let alert_f = UIAlertController(title: "Error", message: "Actividad No Creada", preferredStyle: .alert)
                            let cancel_a = UIAlertAction(title: "OK", style: .default, handler: {(action: UIAlertAction) -> Void in})
                            alert_f.addAction(cancel_a)
                            self.present(alert_f, animated: true, completion: nil)
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                })
            }
        }
    }
    @IBAction func returnActividad(_ sender: Any) {
        let passView: ActividadViewController = ActividadViewController()
        self.present(passView, animated: true, completion: nil)
    }
}
