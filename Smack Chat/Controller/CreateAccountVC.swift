//
//  CreateAccountVC.swift
//  Smack Chat
//
//  Created by Burhanuddin Shakir on 24/01/18.
//  Copyright © 2018 Burhanuddin Shakir. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {
    
    @IBOutlet weak var nameTxt: UITextField!
    
    
    @IBOutlet weak var emailTxt: UITextField!
    
    
    @IBOutlet weak var pwdTxt: UITextField!
    
    @IBOutlet weak var userProfileImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func closePressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
    
    
    @IBAction func createAccountPressed(_ sender: Any) {
        
        guard let email = emailTxt.text, emailTxt.text != "" else {return}
        guard let pwd = pwdTxt.text, pwdTxt.text != "" else {return}
        
        AuthService.instance.registerUser(email: email, password: pwd) { (success) in
            if success{
                AuthService.instance.loginUser(email: email, password: pwd, completion: { (success) in
                    if success {
                        print("Logged in user", AuthService.instance.authToken)
                    }
                })
            }
        }
        
    }
    
    @IBAction func chooseAvatarPressed(_ sender: Any) {
        
    }
    
    
    @IBAction func generateBGPressed(_ sender: Any) {
    }
    
    
}
