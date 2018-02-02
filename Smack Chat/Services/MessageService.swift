//
//  MessageService.swift
//  Smack Chat
//
//  Created by Burhanuddin Shakir on 30/01/18.
//  Copyright © 2018 Burhanuddin Shakir. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService
{
    static let instance = MessageService()
    
    var channels = [Channel]()
    
    func findAllChannels(completion: @escaping CompletionHandler)
    {
        Alamofire.request("\(URL_GET_CHANNELS)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            
            if response.result.error == nil{
                
                guard let data = response.data else {return}
                
                if let json = JSON(data:data).array{
                    for item in json
                    {
                        
                        let name = item["name"].stringValue
                        let desc = item["description"].stringValue
                        let id = item["_id"].stringValue
                        
                        let channel = Channel(channelTitle: name, channelDescription: desc, id: id)
                        self.channels.append(channel)
                        
                    }
                    completion(true)
                }
            
            }
            else{
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
        
    }
}
