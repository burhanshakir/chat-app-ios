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
    
    // Variables
    var avatarName = "profileDefault"
    var avatarColor = "[0.5,0.5,0.5,1]"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func closePressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDataService.instance.avatarName != ""
        {
            userProfileImg.image = UIImage(named: UserDataService.instance.avatarName)
            avatarName = UserDataService.instance.avatarName
        }
    }
    
    
    
    @IBAction func createAccountPressed(_ sender: Any) {
        
        guard let name = nameTxt.text, nameTxt.text != "" else {return}
        guard let email = emailTxt.text, emailTxt.text != "" else {return}
        guard let pwd = pwdTxt.text, pwdTxt.text != "" else {return}
        
        AuthService.instance.registerUser(email: email, password: pwd) { (success) in
            if success{
                AuthService.instance.loginUser(email: email, password: pwd, completion: { (success) in
                    if success {
                        AuthService.instance.createUser(email: email, avatarName: self.avatarName, name: name, color: self.avatarColor, completion: { (success) in
                            if success{
                                self.performSegue(withIdentifier: UNWIND, sender:  nil)
                                print(UserDataService.instance.name, UserDataService.instance.avatarName)
                            }
                        })
                    }
                })
            }
        }
        
    }
    
    @IBAction func chooseAvatarPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }
    
    
    @IBAction func generateBGPressed(_ sender: Any) {
    }
    
    
}
