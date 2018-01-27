//
//  UserDataService.swift
//  Smack Chat
//
//  Created by Burhanuddin Shakir on 27/01/18.
//  Copyright © 2018 Burhanuddin Shakir. All rights reserved.
//

import Foundation

class UserDataService{
    
    static let instance = UserDataService()
    
    public private(set) var id = ""
    public private(set) var avatarName = ""
    public private(set) var avatarColor = ""
    public private(set) var name = ""
    public private(set) var email = ""
    
    func setUserData(id : String, avatarName : String, color : String, name : String, email : String) {
        
        self.id = id
        self.avatarName = avatarName
        self.avatarColor = color
        self.name = name
        self.email = email
    }
    
    func setAvatarName(avatarName : String){
        self.avatarName = avatarName
    }
}
