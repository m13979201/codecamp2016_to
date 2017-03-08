//
//  configViewController.swift
//  Anzai
//
//  Created by MIGGI on 2017/03/05.
//  Copyright © 2017年 Ryo Migita. All rights reserved.
//

import UIKit

class configViewController: UIViewController {

    
    @IBAction func addEvent(_ sender: Any) {
        performSegue(withIdentifier: "callAddEvent", sender: self)
    
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    



}
