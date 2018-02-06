//
//  SocketService.swift
//  Smack Chat
//
//  Created by Burhanuddin Shakir on 06/02/18.
//  Copyright © 2018 Burhanuddin Shakir. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {
    
    static let instance = SocketService()
    
    override init(){
        super.init()
    }
    
    var socket : SocketIOClient = SocketIOClient(socketURL: URL(string: BASE_URL)!)
    
    func establishConnection(){
        socket.connect()
    }
    
    func closeConnection(){
        socket.disconnect()
    }
    
    func addChannel(name: String, description : String, completion : @escaping CompletionHandler){
        
        socket.emit("newChannel", name,description)
        completion(true)
        
    }
    
    func getChannel(completion : @escaping CompletionHandler){
        socket.on("channelCreated") { (dataArray, ack) in
            guard let channelName = dataArray[0] as? String else { return }
            guard let channelDesc = dataArray[1] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            
            let newChannel = Channel(channelTitle: channelName, channelDescription: channelDesc, id: channelId)
            
            MessageService.instance.channels.append(newChannel)
            
            completion(true)
        }
    }
    
    func addMessage(messageBody: String, userId: String, channelId: String, completion: @escaping CompletionHandler)
    {
        let user = UserDataService.instance
        
        socket.emit("newMessage", messageBody,userId,channelId,user.name,user.avatarName, user.avatarColor)
        
        completion(true)
    }
    
    func getChatMessage(completion : @escaping (_ newMsg : Message) -> Void){
        socket.once("messageCreated") { (dataArray, ack) in
            guard let msg = dataArray[0] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            guard let name = dataArray[3] as? String else { return }
            guard let avatar = dataArray[4] as? String else { return }
            guard let color = dataArray[5] as? String else { return }
            guard let id = dataArray[6] as? String else { return }
            guard let time = dataArray[7] as? String else { return }
    
            let newMsg = Message(message: msg, userName: name, channelId: channelId, userAvatar: avatar, userAvatarColor: color, id: id, time: time)
            
            completion(newMsg)

        }
    }
    
    func getTypingUsers(_ completionHandler : @escaping (_ typingUsers : [String : String]) -> Void){
        
        socket.on("userTypingUpdate") { (dataArray, ack) in
            
            guard let typingUser = dataArray[0]  as? [String : String] else { return }
            completionHandler(typingUser)
        }
    }

}
