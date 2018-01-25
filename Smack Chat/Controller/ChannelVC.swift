//
//  ChannelVC.swift
//  Smack Chat
//
//  Created by Burhanuddin Shakir on 11/01/18.
//  Copyright © 2018 Burhanuddin Shakir. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {
    
    
    @IBOutlet weak var loginButton: NSLayoutConstraint!
    @IBAction func prepareForUnwind(segue:UIStoryboardSegue){}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
    }
    

}
