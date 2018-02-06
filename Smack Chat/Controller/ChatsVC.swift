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
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var typingLbl: UILabel!
    var isTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.bindToKeyboard()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatsVC.handleTap))
        
        view.addGestureRecognizer(tap)
        
        sendBtn.isHidden = true
        
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
        
//        SocketService.instance.getChatMessage(completion: { (success) in
//            if success{
//                self.tableView.reloadData()
//            }
//
//        })
        
        SocketService.instance.getChatMessage { (newMsg) in
            if newMsg.channelId == MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedIn{
                MessageService.instance.messages.append(newMsg)
                self.tableView.reloadData()
                
                if MessageService.instance.messages.count > 0{
                    let endIndex = IndexPath(row: MessageService.instance.messages.count-1 , section: 0)
                    
                    self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: false)
                }
            }
        }
        
        SocketService.instance.getTypingUsers { (typingUsers) in
            guard let channelId = MessageService.instance.selectedChannel?.id else {return }
            var names = ""
            var numOfTypers = 0
            
            for(typingUser, channel) in typingUsers{
                if typingUser != UserDataService.instance.name && channel == channelId
                {
                    if names == ""{
                        names = typingUser
                    }else{
                        names = "\(names),\(typingUser)"
                    }
                    
                    numOfTypers += 1
                
                }
            }
            
            if numOfTypers > 0 && AuthService.instance.isLoggedIn{
                var verb = "is"
                
                if numOfTypers > 1 {
                    verb = "are"
                }
                
                self.typingLbl.text = "\(names) \(verb) typing a message"
            }else{
                self.typingLbl.text = ""
            }
            
            
        }
    }
    
    @objc func userDataDidChange(_ notif: Notification )
    {
        if AuthService.instance.isLoggedIn{
            
            onLoginGetMessages()
        }
        else{
            channelNameLbl.text = "Please Log In"
            tableView.reloadData()
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
    
    @IBAction func msgBoxEdit(_ sender: Any) {
        
        guard let channelId = MessageService.instance.selectedChannel?.id else {return}
        
        if msgTxtBox.text == ""{
            isTyping = false
            sendBtn.isHidden = true
            
            SocketService.instance.socket.emit("stopType", UserDataService.instance.name, channelId)
        }else{
            if isTyping == false{
                sendBtn.isHidden = false
                
                SocketService.instance.socket.emit("startType", UserDataService.instance.name, channelId)
            }
            isTyping = true
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
                
                if MessageService.instance.messages.count > 0{
                    let endIndex = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
                    
                    self.tableView.scrollToRow(at: endIndex, at: .bottom, animated: false)
                }
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
