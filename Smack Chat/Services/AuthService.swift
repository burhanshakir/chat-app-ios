//
//  AuthService.swift
//  Smack Chat
//
//  Created by Burhanuddin Shakir on 24/01/18.
//  Copyright © 2018 Burhanuddin Shakir. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthService{
    static let instance = AuthService()

    let defaults = UserDefaults.standard

    var isLoggedIn:Bool{
        get{
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        
        set{
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken:String{
        get{
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        
        set{
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail:String{
        get{
            return defaults.value(forKey: USER_EMAIL) as! String
        }
        
        set{
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    
    
    func registerUser(email:String, password:String,completion:@escaping CompletionHandler){
        let lowercaseEmail = email.lowercased()
        
        let body:[String: Any] = [
            "email" : lowercaseEmail,
            "password": password
        ]
        
        Alamofire.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString { (response) in
            
            if response.result.error == nil{
                completion(true)
            }
            else{
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    
    
    func loginUser(email:String, password:String,completion:@escaping CompletionHandler){
        let lowercaseEmail = email.lowercased()
        
        let body:[String: Any] = [
            "email" : lowercaseEmail,
            "password": password
        ]
        
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString { (response) in
            
            if response.result.error == nil{
                
                guard let data = response.data else {return}
                
                let json = JSON(data:data)
                
                self.userEmail = json["user"].stringValue
                self.authToken = json["token"].stringValue
                
                self.isLoggedIn = true
                
                completion(true)
            }
            else{
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func createUser(email:String, avatarName:String,name:String,color:String,completion:@escaping CompletionHandler){
        let lowercaseEmail = email.lowercased()
        
        let body:[String: Any] = [
            "name": name,
            "email" : lowercaseEmail,
            "avatarName": avatarName,
            "avatarColor": color
            
        ]
        
        
        
        Alamofire.request(URL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseString { (response) in
            
            if response.result.error == nil{
                
                guard let data = response.data else {return}
                
                self.setUser(Info: data)
                
                completion(true)
            }
            else{
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func findEmailByUser(completion:@escaping CompletionHandler)
    {
        Alamofire.request("\(URL_FIND_USER)\(userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseString { (response) in
            
            if response.result.error == nil{
                
                guard let data = response.data else {return}
                
                self.setUser(Info: data)
                
                completion(true)
            }
            else{
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func setUser(Info data:Data)
    {
        let json = JSON(data:data)
        
        let id = json["_id"].stringValue
        let color = json["avatarColor"].stringValue
        let avatarName = json["avatarName"].stringValue
        let email = json["email"].stringValue
        let name = json["name"].stringValue
        
        UserDataService.instance.setUserData(id: id, avatarName: avatarName, color: color, name: name, email: email)
    }
}

