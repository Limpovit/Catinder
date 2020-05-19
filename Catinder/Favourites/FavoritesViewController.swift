//
//  FavoritesViewController.swift
//  NekoShelter
//
//  Created by HexaHack on 12.05.2020.
//  Copyright © 2020 HexaHack. All rights reserved.
//

import UIKit

class FavoritesViewController: UICollectionViewController {
    @IBOutlet weak var backgroundView: UIView!
    
    var favouriteImages: [UIImage]!
    
    var tabBar: MyTabBarController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar = tabBarController as! MyTabBarController
        backgroundView.setGradient([ #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1).cgColor,  #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1).cgColor])
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       favouriteImages = tabBar?.getFavouritesImages()
        collectionView.reloadData()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favouriteImages.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? FavouritesCollectionViewCell {
            
            itemCell.imageView.image = favouriteImages[indexPath.row]
            
            return itemCell
        }
        return UICollectionViewCell()
    }

}
