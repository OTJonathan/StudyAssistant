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
        
//        fetchInstiuttoData()
    }
    
//    func fetchInstiuttoData() {
//        DispatchQueue.main.async {
//            //let usuario = UserDefaults.standard.value(forKey: "user_id") as! String
//            let url = "http://192.168.56.1:8080/SAService/rest/instituto/listar_instituto?idest=1"//="+usuario
//            print(url)
//            Alamofire.request(url).responseJSON(completionHandler: { (response) in
//                switch response.result {
//                case .success(let value):
//                    let json = JSON(value)
//                    json.array?.forEach({ (obj) in
//                        let instituto = Instituto(id: obj["id"].intValue, nombre: obj["nombre"].stringValue, idest: obj["idest"].intValue)
//                        self.institutoData.append(instituto)
//                    })
//                    self.institutoTable.reloadData()
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            })
//        }
//    }
    
}

extension InstitutoViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5//self.institutoData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = institutoTable.dequeueReusableCell(withIdentifier: "institutoCell", for: indexPath) as! ItemTableViewCell
//        cell.nameLabel.text = self.institutoData[indexPath.row].nombre
        return  cell
    }
    
}
