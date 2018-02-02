//
//  ChannelVC.swift
//  Smack Chat
//
//  Created by Burhanuddin Shakir on 11/01/18.
//  Copyright © 2018 Burhanuddin Shakir. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var profileImg: CircleImage!
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func prepareForUnwind(segue:UIStoryboardSegue){}
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpUserInfo()
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        if AuthService.instance.isLoggedIn
        {
            let profileVC = ProfileVC()
            profileVC.modalPresentationStyle = .custom
            present(profileVC, animated: true, completion: nil)
            
        }
        else
        {
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
        
    }
    
    @objc func userDataDidChange(_ notif: Notification )
    {
        setUpUserInfo()
    }
    
    func setUpUserInfo()
    {
        if AuthService.instance.isLoggedIn
        {
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            profileImg.image = UIImage(named: UserDataService.instance.avatarName)
            profileImg.backgroundColor = UserDataService.instance.returnUIColor(components:UserDataService.instance.avatarColor)
        }
        else
        {
            loginBtn.setTitle("Login", for: .normal)
            profileImg.image = UIImage(named: "menuProfileIcon")
            profileImg.backgroundColor = UIColor.clear
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as? ChannelCell{
            let channel = MessageService.instance.channels[indexPath.row]
            cell.configureCell(channel: channel)
            return cell
        }
        
        else
        {
            return ChannelCell()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }

}
