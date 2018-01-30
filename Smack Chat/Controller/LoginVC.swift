//
//  LoginVC.swift
//  Smack Chat
//
//  Created by Burhanuddin Shakir on 23/01/18.
//  Copyright © 2018 Burhanuddin Shakir. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var pwdTxt: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpView()
    }

    @IBAction func closePressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func createAccountPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        spinner.isHidden = false
        spinner.startAnimating()
        
        guard let email = userNameTxt.text, userNameTxt.text != "" else {return}
        guard let pwd = pwdTxt.text, pwdTxt.text != "" else {return}
        
        AuthService.instance.loginUser(email: email, password: pwd) { (success) in
            if success{
                
                AuthService.instance.findEmailByUser(completion: { (success) in
                    if success{
                        
                        self.spinner.isHidden = true
                        self.spinner.stopAnimating()
                        
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                        
                        self.dismiss(animated: true, completion: nil)
                    }
                })

            }
        }
        
        
    }
    
    func setUpView()
    {
        spinner.isHidden = true
        
        userNameTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedStringKey.foregroundColor : smackPlaceholderColor])
        
        pwdTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor : smackPlaceholderColor])
    }
    
    

}
