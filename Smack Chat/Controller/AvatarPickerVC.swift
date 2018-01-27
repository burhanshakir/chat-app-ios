//
//  AvatarPickerVC.swift
//  Smack Chat
//
//  Created by Burhanuddin Shakir on 27/01/18.
//  Copyright © 2018 Burhanuddin Shakir. All rights reserved.
//

import UIKit

class AvatarPickerVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var avatarType = AvatarType.dark
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    @IBAction func backPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func segmentControlChange(_ sender: Any) {
        
        if segmentControl.selectedSegmentIndex == 0
        {
            self.avatarType = AvatarType.dark
        }
        else
        {
            self.avatarType = AvatarType.light
        }
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as? AvatarCell
        {
            cell.configureCell(index: indexPath.item, type: avatarType)
            return cell
        }
        
        return AvatarCell()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var numOfColumns: CGFloat = 3
        if UIScreen.main.bounds.width > 320{
            numOfColumns = 4
        }
        
        let spaceBetweenCells : CGFloat = 10
        let padding : CGFloat = 40
        
        let cellDimension = ((collectionView.bounds.width - padding) - (numOfColumns - 1) * spaceBetweenCells) / numOfColumns
        
        return CGSize(width: cellDimension, height: cellDimension)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if avatarType == AvatarType.dark
        {
            UserDataService.instance.setAvatarName(avatarName: "dark\(indexPath.item)")
        }
        else
        {
            UserDataService.instance.setAvatarName(avatarName: "light\(indexPath.item)")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
