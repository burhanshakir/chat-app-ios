//
//  AvatarCell.swift
//  Smack Chat
//
//  Created by Burhanuddin Shakir on 27/01/18.
//  Copyright © 2018 Burhanuddin Shakir. All rights reserved.
//

import UIKit

enum AvatarType
{
    case dark
    case light
}

class AvatarCell: UICollectionViewCell {

    @IBOutlet weak var avatarImg: UIImageView!
    override func awakeFromNib()
    {
        super.awakeFromNib()
        updateViews()
        
    }
    
    func configureCell(index : Int, type : AvatarType)
    {
        if type == AvatarType.dark
        {
            avatarImg.image = UIImage(named: "dark\(index)")
            self.layer.backgroundColor = UIColor.lightGray.cgColor
        }
        else
        {
            avatarImg.image = UIImage(named: "light\(index)")
            self.layer.backgroundColor = UIColor.gray.cgColor
        }
        
    }
    
    func updateViews()
    {
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
    }
}
