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
        socket.once("channelCreated") { (dataArray, ack) in
            guard let channelName = dataArray[0] as? String else { return }
            guard let channelDesc = dataArray[1] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            
            let newChannel = Channel(channelTitle: channelName, channelDescription: channelDesc, id: channelId)
            
            MessageService.instance.channels.append(newChannel)
            
            completion(true)
        }
    }

}
