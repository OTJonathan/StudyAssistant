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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func ingresar(_ sender: Any) {
        
        let passview: InstitutoViewController = InstitutoViewController()
        self.present(passview, animated: true, completion: nil)
    }
    
}
