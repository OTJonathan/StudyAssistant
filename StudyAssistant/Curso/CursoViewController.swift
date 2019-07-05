//
//  CursoViewController.swift
//  StudyAssistant
//
//  Created by Kurosaki Ryuugo on 6/27/19.
//  Copyright © 2019 Team cibertec. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CursoViewController: UIViewController {
    
    @IBOutlet weak var cursoTable: UITableView!
    var cursoData: [Curso] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cursoTable.rowHeight = UITableView.automaticDimension
        self.cursoTable.estimatedRowHeight = 50
        self.cursoTable.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: "cursoCell")
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        self.view.addGestureRecognizer(longPressRecognizer)
        
        fetchCursoData()
    }

    func fetchCursoData() {
        DispatchQueue.main.async {
            let instituto = UserDefaults.standard.value(forKey: "instituto_id") as! String
            let usuario = UserDefaults.standard.value(forKey: "user_id") as! String
            let url = "http://192.168.56.1:8080/SAService/rest/curso/listar_curso?idinst="+instituto+"&idest="+usuario
            Alamofire.request(url).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    json.array?.forEach({ (obj) in
                        let curso = Curso(id: obj["id"].intValue, nombre: obj["nombre"].stringValue, idinst: obj["idinst"].intValue, idest: obj["idest"].intValue)
                        self.cursoData.append(curso)
                    })
                    let selectedrows = self.cursoTable.indexPathsForSelectedRows
                    self.cursoTable.reloadData()
                    DispatchQueue.main.async {
                        selectedrows?.forEach({ (selectedrow) in
                            self.cursoTable.selectRow(at: selectedrow, animated: false, scrollPosition: .none)
                        })
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
    }
    @objc func longPress(gestureRecognizer: UILongPressGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: self.view)
        let indexPath = self.cursoTable.indexPathForRow(at: touchPoint)
        if indexPath != nil {
            let alert = UIAlertController(title: "Opciones", message: "Elija que quiere hacer", preferredStyle: .alert)
            let edit = UIAlertAction(title: "Editar", style: .default) { (action: UIAlertAction) in
                if let index = indexPath {
                    var obj: Curso = self.cursoData[index.row-1]
                    let alert = UIAlertController(title: "Actualizar", message: nil, preferredStyle: .alert)
                    alert.addTextField(configurationHandler: { (textField: UITextField) in
                        textField.text = obj.nombre
                    })
                    let editar = UIAlertAction(title: "Listo", style: .default, handler: { (action: UIAlertAction) in
                        let texto = alert.textFields![0] as UITextField
                        let txt = "\(texto.text!)"
                        obj.nombre = txt
                        let url = "http://192.168.56.1:8080/SAService/rest/curso/update_curso"
                        let params = [
                            "nombre": obj.nombre,
                            "idinst": obj.idinst,
                            "idest": obj.idest
                            ] as [String : Any]
                        Alamofire.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                            switch response.result {
                            case .success(let value):
                                let b = "\(value)"
                                if b == "1" {
                                    let alert = UIAlertController(title: "Completado", message: "Curso Modificado", preferredStyle: .alert)
                                    let done = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                                        let passview: CursoViewController = CursoViewController()
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
                    var obj: Curso = self.cursoData[index.row-1]
                    let alert = UIAlertController(title: "Eliminar", message: nil, preferredStyle: .alert)
                    let borrar = UIAlertAction(title: "Eliminar", style: .default, handler: { (action: UIAlertAction) in
                        let url = "http://192.168.56.1:8080/SAService/rest/curso/delete_curso?id="+String(obj.id)+"&idinst="+String(obj.idinst)+"&idest="+String(obj.idest)
                        print(obj.nombre)
                        print(url)
                        Alamofire.request(url, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                            switch response.result {
                            case .success(let value):
                                print(value)
                                let b = "\(value)"
                                print(b)
                                if b == "1" {
                                    let alert = UIAlertController(title: "Completado", message: "Curso Eliminado", preferredStyle: .alert)
                                    let done = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                                        let passview: CursoViewController = CursoViewController()
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
    
    @IBAction func addCurso(_ sender: Any) {
        let alert = UIAlertController(title: "Añadir", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Ingresar Curso"
        }
        let add = UIAlertAction(title: "Guardar", style: .default) { (action: UIAlertAction) in
            let texto = alert.textFields![0] as UITextField
            let txt = "\(texto.text!)"
            let usuario = UserDefaults.standard.value(forKey: "user_id") as! String
            let instituto = UserDefaults.standard.value(forKey: "instituto_id") as! String
            let url = "http://192.168.56.1:8080/SAService/rest/curso/insert_curso"
            let parameters = [
                "nombre": txt,
                "idinst": instituto,
                "idest": usuario
            ]
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    let b = "\(value)"
                    if b == "1" {
                        let alert = UIAlertController(title: "Completado", message: "Curso Creado", preferredStyle: .alert)
                        let done = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                            let passview: CursoViewController = CursoViewController()
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
    @IBAction func returnInstituto(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "instituto_id")
        let passview: InstitutoViewController = InstitutoViewController()
        self.present(passview, animated: true, completion: nil)
    }
}
extension CursoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.cursoData.count)
        return self.cursoData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cursoTable.dequeueReusableCell(withIdentifier: "cursoCell", for: indexPath) as! ItemTableViewCell
        cell.nombreLabel.text = self.cursoData[indexPath.row].nombre
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(String(cursoData[indexPath.row].id), forKey: "curso_id")
        if UserDefaults.exists(key: "curso_id") {
            let passview: ActividadViewController = ActividadViewController()
            self.present(passview, animated: true, completion: nil)
        }
    }
    
}
