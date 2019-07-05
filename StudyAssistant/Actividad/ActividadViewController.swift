//
//  ActividadViewController.swift
//  StudyAssistant
//
//  Created by Kurosaki Ryuugo on 6/27/19.
//  Copyright © 2019 Team cibertec. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ActividadViewController: UIViewController {

    @IBOutlet weak var actividadTable: UITableView!
    var actividadData: [Actividad] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.actividadTable.rowHeight = UITableView.automaticDimension
        self.actividadTable.estimatedRowHeight = 50
        self.actividadTable.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: "actCell")
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        self.view.addGestureRecognizer(longPressRecognizer)
        
        fetchActData()
    }

    func fetchActData() {
        DispatchQueue.main.async {
            let curso = UserDefaults.standard.value(forKey: "curso_id") as! String
            let usuario = UserDefaults.standard.value(forKey: "user_id") as! String
            let url = "http://192.168.56.1:8080/SAService/rest/actividad/listar_actividad?idcur="+curso+"&idest="+usuario
            Alamofire.request(url).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    json.array?.forEach({ (obj) in
                        let act = Actividad(id: obj["id"].intValue, nombre: obj["nombre"].stringValue, descripcion: obj["descripcion"].stringValue, fechafin: obj["fechafin"].stringValue, idcur: obj["idcur"].intValue, idest: obj["idest"].intValue)
                        self.actividadData.append(act)
                    })
                    let selectedrows = self.actividadTable.indexPathsForSelectedRows
                    self.actividadTable.reloadData()
                    DispatchQueue.main.async {
                        selectedrows?.forEach({ (selectedrow) in
                            self.actividadTable.selectRow(at: selectedrow, animated: false, scrollPosition: .none)
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
        let indexPath = self.actividadTable.indexPathForRow(at: touchPoint)
        if indexPath != nil {
            let alert = UIAlertController(title: "Opciones", message: "Elija que quiere hacer", preferredStyle: .alert)
            let delete = UIAlertAction(title: "Borrar", style: .default) { (action: UIAlertAction) in
                if let index = indexPath {
                    var obj: Actividad = self.actividadData[index.row-1]
                    let alert = UIAlertController(title: "Eliminar", message: nil, preferredStyle: .alert)
                    let borrar = UIAlertAction(title: "Eliminar", style: .default, handler: { (action: UIAlertAction) in
                        let url = "http://192.168.56.1:8080/SAService/rest/actividad/delete_actividad?id="+String(obj.id)+"&idcur="+String(obj.idcur)+"&idest="+String(obj.idest)
                        Alamofire.request(url, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                            switch response.result {
                            case .success(let value):
                                print(value)
                                let b = "\(value)"
                                print(b)
                                if b == "1" {
                                    let alert = UIAlertController(title: "Completado", message: "Actividad Eliminada", preferredStyle: .alert)
                                    let done = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                                        let passview: ActividadViewController = ActividadViewController()
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
            alert.addAction(delete)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func addActividad(_ sender: Any) {
        let passview: ActAddViewController = ActAddViewController()
        self.present(passview, animated: true, completion: nil)
    }
    @IBAction func returnCurso(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "curso_id")
        let passview: CursoViewController = CursoViewController()
        self.present(passview, animated: true, completion: nil)
    }
}
extension ActividadViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.actividadData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = actividadTable.dequeueReusableCell(withIdentifier: "actCell", for: indexPath) as! ItemTableViewCell
        cell.nombreLabel.text = self.actividadData[indexPath.row].nombre
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(String(actividadData[indexPath.row].id), forKey: "act_id")
        if UserDefaults.exists(key: "act_id") {
            let passview: ActUnitViewController = ActUnitViewController()
            self.present(passview, animated: true, completion: nil)
        }
    }
    
}
