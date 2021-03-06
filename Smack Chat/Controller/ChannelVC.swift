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
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.channelLoaded(_:)), name: NOTIF_CHANNELS_LOADED, object: nil)
        
        SocketService.instance.getChannel { (success) in
            if success{
                self.tableView.reloadData()
            }
        }
        
        SocketService.instance.getChatMessage { (newMessage) in
            if newMessage.channelId != MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedIn{
                MessageService.instance.unreadMsgs.append(newMessage.channelId)
                self.tableView.reloadData()
            }
        }
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
    
    @objc func channelLoaded(_ notif: Notification )
    {
        self.tableView.reloadData()
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
            self.tableView.reloadData()
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
    
    @IBAction func addChannelPressed(_ sender: Any) {
        
        
        if AuthService.instance.isLoggedIn
        {
            let addChannelVC = AddChannelVC()
            addChannelVC.modalPresentationStyle = .custom
            present(addChannelVC, animated: true, completion: nil)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = MessageService.instance.channels[indexPath.row]
        MessageService.instance.selectedChannel = channel
        
        if MessageService.instance.unreadMsgs.count > 0{
            MessageService.instance.unreadMsgs = MessageService.instance.unreadMsgs.filter{$0 != channel.id}
            
        }
        
        let index = IndexPath(row: indexPath.row, section: 0)
        tableView.reloadRows(at: index, with: .none)
        
        tableView.selectRow(at: index, animated: false, scrollPosition: .none)
        
        NotificationCenter.default.post(name: NOTIF_CHANNEL_SELECTED, object: nil)
        self.revealViewController().revealToggle(animated: true)
    }
    
    

}
