//
//  ForoListViewController.swift
//  StudyAssistant
//
//  Created by Kurosaki Ryuugo on 6/27/19.
//  Copyright © 2019 Team cibertec. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ForoListViewController: UIViewController {

    @IBOutlet weak var foroTable: UITableView!
    var foroData: [Foro] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.foroTable.rowHeight = UITableView.automaticDimension
        self.foroTable.estimatedRowHeight = 50
        self.foroTable.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: "cursoCell")
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        self.view.addGestureRecognizer(longPressRecognizer)
        
        fetchForoData()
    }
    
    func fetchForoData(){
        DispatchQueue.main.async {
            let usuario = UserDefaults.standard.value(forKey: "user_id") as! String
            let url = "http://192.168.56.1:8080/SAService/rest/foro/listar_foro_user?idest="+usuario
            Alamofire.request(url).responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    json.array?.forEach({ (obj) in
                        let foro = Foro(id: obj["id"].intValue, nombre: obj["nombre"].stringValue, descripcion: obj["descripcion"].stringValue, idest: obj["idest"].intValue)
                        self.foroData.append(foro)
                    })
                    let selectedrows = self.foroTable.indexPathsForSelectedRows
                    self.foroTable.reloadData()
                    DispatchQueue.main.async {
                        selectedrows?.forEach({ (selectedrow) in
                            self.foroTable.selectRow(at: selectedrow, animated: false, scrollPosition: .none)
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
        let indexPath = self.foroTable.indexPathForRow(at: touchPoint)
        if indexPath != nil {
            let alert = UIAlertController(title: "Opciones", message: "Elija que quiere hacer", preferredStyle: .alert)
            let delete = UIAlertAction(title: "Borrar", style: .default) { (action: UIAlertAction) in
                if let index = indexPath {
                    var obj: Foro = self.foroData[index.row-1]
                    let alert = UIAlertController(title: "Eliminar", message: nil, preferredStyle: .alert)
                    let borrar = UIAlertAction(title: "Eliminar", style: .default, handler: { (action: UIAlertAction) in
                        let url = "http://192.168.56.1:8080/SAService/rest/foro/delete_foro_user?id="+String(obj.id)+"&idest="+String(obj.idest)
                        Alamofire.request(url, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
                            switch response.result {
                            case .success(let value):
                                print(value)
                                let b = "\(value)"
                                print(b)
                                if b == "1" {
                                    let alert = UIAlertController(title: "Completado", message: "Foro Eliminado", preferredStyle: .alert)
                                    let done = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction) in
                                        let passview: ForoListViewController = ForoListViewController()
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

    @IBAction func returnForos(_ sender: Any) {
        let passview: ForoViewController = ForoViewController()
        self.present(passview, animated: true, completion: nil)
    }
    
    @IBAction func addForo(_ sender: Any) {
        let passview: ViewForoUnitViewController = ViewForoUnitViewController()
        self.present(passview, animated: true, completion: nil)
    }
}
