//
//  ForoViewController.swift
//  StudyAssistant
//
//  Created by Kurosaki Ryuugo on 6/27/19.
//  Copyright © 2019 Team cibertec. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ForoViewController: UIViewController {

    @IBOutlet weak var foroTable: UITableView!
    var foroData: [Foro] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.foroTable.rowHeight = UITableView.automaticDimension
        self.foroTable.estimatedRowHeight = 50
        self.foroTable.register(UINib(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: "foroCell")
        
        fetchForoData()
    }
    
    func fetchForoData() {
        DispatchQueue.main.async {
            let url = "http://192.168.56.1:8080/SAService/rest/foro/listar_foro_total"
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

    @IBAction func viewMisForos(_ sender: Any) {
        let passview: ForoListViewController = ForoListViewController()
        self.present(passview, animated: true, completion: nil)
    }
}
