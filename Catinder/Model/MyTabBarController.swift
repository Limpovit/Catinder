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
    var userQuery = "/images/search"
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    func  changeUserQuery(to query: String) -> () {
        userQuery = query
    }
    
    func addToFavourites(image: UIImage) {
        favouritesImagesArray.append(image)
    }
    
  func getFavouritesImages() -> [UIImage] {
        return favouritesImagesArray
    }
    func getUserQuery() -> String{
        return userQuery
    }
    
}
