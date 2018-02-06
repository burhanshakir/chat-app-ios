//
//  ChatsVC.swift
//  Smack Chat
//
//  Created by Burhanuddin Shakir on 11/01/18.
//  Copyright © 2018 Burhanuddin Shakir. All rights reserved.
//

import UIKit

class ChatsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var msgTxtBox: UITextField!
    @IBOutlet weak var burgerBtn: UIButton!
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.bindToKeyboard()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatsVC.handleTap))
        
        view.addGestureRecognizer(tap)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        
        burgerBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatsVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatsVC.channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        if AuthService.instance.isLoggedIn
        {
            AuthService.instance.findEmailByUser(completion: { (success) in
                if success{
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                }
            })
        }
    }
    
    @objc func userDataDidChange(_ notif: Notification )
    {
        if AuthService.instance.isLoggedIn{
            
            onLoginGetMessages()
        }
        else{
            channelNameLbl.text = "Please Log In"
        }
    }
    
    @objc func handleTap(){
        view.endEditing(true)
    }
    
    @objc func channelSelected(_ notif: Notification )
    {
        updateWithChannel()
    }
    
    func updateWithChannel(){
        let name = MessageService.instance.selectedChannel?.channelTitle ?? ""
        channelNameLbl.text = name
        getMessages()
    }
    
    
    @IBAction func sendMsgPress(_ sender: Any) {
        
        if AuthService.instance.isLoggedIn{
            guard let id = MessageService.instance.selectedChannel?.id else { return }
            guard let message = msgTxtBox.text else { return }
            
            SocketService.instance.addMessage(messageBody: message, userId: UserDataService.instance.id, channelId: id, completion: { (success) in
                if success{
                    self.msgTxtBox.text = ""
                    self.msgTxtBox.resignFirstResponder()
                }
            })
        }
        
    }
    
    
    func onLoginGetMessages(){
        MessageService.instance.findAllChannels { (success) in
            if success{
                
                if MessageService.instance.channels.count > 0{
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    
                    self.updateWithChannel()
                }
                else{
                    self.channelNameLbl.text = "No Channels"
                }
            }
        }
    }
    
    func getMessages(){
        
        guard let id = MessageService.instance.selectedChannel?.id else { return }
        MessageService.instance.findAllMessagesForChannel(channelId: id, completion: { (success) in
            
            if success{
                self.tableView.reloadData()
            }
        })
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell{
            let message = MessageService.instance.messages[indexPath.row]
            cell.configureCell(message: message)
            return cell
        }else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    


}
