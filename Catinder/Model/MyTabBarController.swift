//
//  MyTabBarController.swift
//  Catinder
//
//  Created by HexaHack on 16.05.2020.
//  Copyright © 2020 HexaHack. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController {
    
    var favouritesImagesArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    func addToFavourites(image: UIImage) {
        favouritesImagesArray.append(image)
    }
    
 func getFavouritesImages() -> [UIImage] {
        return favouritesImagesArray
    }
    
}
