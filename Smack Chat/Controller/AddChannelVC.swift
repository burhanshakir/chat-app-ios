//
//  AddChannelVC.swift
//  Smack Chat
//
//  Created by Burhanuddin Shakir on 02/02/18.
//  Copyright © 2018 Burhanuddin Shakir. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var nameTxt: UITextField!
    
    @IBOutlet weak var descTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createPressed(_ sender: Any) {
        
        guard let channelName = nameTxt.text, nameTxt.text != "" else {return}
        guard let desc = descTxt.text else {return}
        
        SocketService.instance.addChannel(name: channelName, description: desc) { (success) in
            
                self.dismiss(animated: true, completion: nil)
        }
    }
    
    func setUpView()
    {
        nameTxt.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedStringKey.foregroundColor : smackPlaceholderColor])
        
        descTxt.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSAttributedStringKey.foregroundColor : smackPlaceholderColor])
        
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(ProfileVC.closeTap(_:)))
        
        bgView.addGestureRecognizer(closeTouch)
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer)
    {
        dismiss(animated: true, completion: nil)
    }
    
    
}
