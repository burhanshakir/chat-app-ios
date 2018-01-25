//
//  CreateAccountVC.swift
//  Smack Chat
//
//  Created by Burhanuddin Shakir on 24/01/18.
//  Copyright © 2018 Burhanuddin Shakir. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func closePressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
}
