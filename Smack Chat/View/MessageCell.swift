//
//  MessageCell.swift
//  Smack Chat
//
//  Created by Burhanuddin Shakir on 06/02/18.
//  Copyright © 2018 Burhanuddin Shakir. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    
    @IBOutlet weak var userImage: CircleImage!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(message : Message){
        
        nameLbl.text = message.userName
        messageLbl.text = message.message
        userImage.image = UIImage(named: message.userAvatar)
        
        userImage.backgroundColor = UserDataService.instance.returnUIColor(components: message.userAvatarColor)
    }

    

}
