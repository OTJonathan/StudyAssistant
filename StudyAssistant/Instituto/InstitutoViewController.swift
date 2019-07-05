//
//  InstitutoViewController.swift
//  StudyAssistant
//
//  Created by Kurosaki Ryuugo on 6/27/19.
//  Copyright © 2019 Team cibertec. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class InstitutoViewController: UIViewController {
    
    @IBOutlet weak var institutoTable: UITableView!
    var institutoData: [Instituto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.institutoTable.rowHeight = UITableView.automaticDimension
        self.institutoTable.estimatedRowHeight = 50
        self.institutoTable.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: "institutoCell")
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        self.view.addGestureRecognizer(longPressRecognizer)
        
        fetchInstiuttoData()
    }
    
    func fetchInstiuttoData() {
        DispatchQueue.main.async {
            let usuario = UserDefaults.standard.value(forKey: "user_id") as! String
            let url = "http://192.168.56.1:8080/SAService/rest/instituto/listar_instituto?idest="+usuario
            Alamofire.request(url).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    json.array?.forEach({ (obj) in
                        let instituto = Instituto(id: obj["id"].intValue, nombre: obj["nombre"].stringValue, idest: obj["idest"].intValue)
                        self.institutoData.append(instituto)
                    })
                    self.institutoTable.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
    }
    
    @objc func longPress(gestureRecognizer: UILongPressGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: self.view)
        let indexPath = self.institutoTable.indexPathForRow(at: touchPoint)
        
        if indexPath != nil {
            let alert = UIAlertController(title: "Opciones", message: "Elija que quiere hacer", preferredStyle: .alert)
            let edit = UIAlertAction(title: "Editar", style: .default) { (action: UIAlertAction) in
                if let index = indexPath {
                    print(self.institutoData[index.row-1].nombre)
                    var obj: Instituto = self.institutoData[index.row-1]
                    let alert = UIAlertController(title: "Actualizar", message: nil, preferredStyle: .alert)
                    alert.addTextField(configurationHandler: { (textField: UITextField) in
                        textField.text = obj.nombre
                    })
                    let editar = UIAlertAction(title: "Listo", style: .default, handler: { (action: UIAlertAction) in
                        let texto = alert.textFields![0] as UITextField
                        let txt = "\(texto.text!)"
                        obj.nombre = txt
                        let url = "http://192.168.56.1:8080/SAService/rest/instituto/update_instituto"
                        let params = [
                            "id": obj.id,
                            "nombre": obj.nombre,
                            "idest": obj.idest
                            ] as [String : Any]
                        Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                            switch response.result {
                            case .success(let value):
                                let b = "\(value)"
                                print(b)
                                if b == "1" {
                                    let alert = UIAlertController(title: "Completado", message: "Instituto Modificado", preferredStyle: .alert)
                                    let done = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                                        let passview: InstitutoViewController = InstitutoViewController()
                                        self.present(passview, animated: true, completion: nil)
                                    })
                                    alert.addAction(done)
                                    self.present(alert, animated: true, completion: nil)
                                } else {
                                    let alert = UIAlertController(title: "Error", message: "No se pudo Modificar", preferredStyle: .alert)
                                    let cancel = UIAlertAction(title: "OK", style: .default, handler: nil)
                                    alert.addAction(cancel)
                                    self.present(alert, animated: true, completion: nil)
                                }
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        })
                        
                    })
                    alert.addAction(editar)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            let delete = UIAlertAction(title: "Borrar", style: .default) { (action: UIAlertAction) in
                if let index = indexPath {
                    var obj: Instituto = self.institutoData[index.row-1]
                    let alert = UIAlertController(title: "Eliminar", message: nil, preferredStyle: .alert)
                    let borrar = UIAlertAction(title: "Eliminar", style: .default, handler: { (action: UIAlertAction) in
                        let url = "http://192.168.56.1:8080/SAService/rest/instituto/delete_instituto?id="+String(obj.id)+"&idest="+String(obj.idest)
                        print(url)
                        Alamofire.request(url, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                            switch response.result {
                            case .success(let value):
                                print(value)
                                let b = "\(value)"
                                print(b)
                                if b == "1" {
                                    let alert = UIAlertController(title: "Completado", message: "Instituto Eliminado", preferredStyle: .alert)
                                    let done = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                                        let passview: InstitutoViewController = InstitutoViewController()
                                        self.present(passview, animated: true, completion: nil)
                                    })
                                    alert.addAction(done)
                                    self.present(alert, animated: true, completion: nil)
                                } else {
                                    let alert = UIAlertController(title: "Error", message: "No se pudo Eliminar", preferredStyle: .alert)
                                    let cancel = UIAlertAction(title: "OK", style: .default, handler: nil)
                                    alert.addAction(cancel)
                                    self.present(alert, animated: true, completion: nil)
                                }
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        })
                    })
                    let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
                    alert.addAction(borrar)
                    alert.addAction(cancel)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
            alert.addAction(edit)
            alert.addAction(delete)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func addInstituto(_ sender: Any) {
        let alert = UIAlertController(title: "Añadir", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Ingresar Instituto"
        }
        let add = UIAlertAction(title: "Guardar", style: .default) { (action: UIAlertAction) in
            let texto = alert.textFields![0] as UITextField
            let txt = "\(texto.text!)"
            let usuario = UserDefaults.standard.value(forKey: "user_id") as! String
            let url = "http://192.168.56.1:8080/SAService/rest/instituto/insert_instituto"
            let parameters = [
                "nombre": txt,
                "idest": usuario
            ]
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    let b = "\(value)"
                    if b == "1" {
                        let alert = UIAlertController(title: "Completado", message: "Instituto Creado", preferredStyle: .alert)
                        let done = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                            let passview: InstitutoViewController = InstitutoViewController()
                            self.present(passview, animated: true, completion: nil)
                        })
                        alert.addAction(done)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "Error", message: "No se pudo Agregar", preferredStyle: .alert)
                        let cancel = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(cancel)
                        self.present(alert, animated: true, completion: nil)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(add)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension InstitutoViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.institutoData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = institutoTable.dequeueReusableCell(withIdentifier: "institutoCell", for: indexPath) as! ItemTableViewCell
        cell.nombreLabel.text = self.institutoData[indexPath.row].nombre
        return  cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(String(institutoData[indexPath.row].id), forKey: "instituto_id")
        if UserDefaults.exists(key: "instituto_id") {
            let passview: CursoViewController = CursoViewController()
            self.present(passview, animated: true, completion: nil)
        }
    }
    
}
