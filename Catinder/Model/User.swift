//
//  User.swift
//  Catinder
//
//  Created by HexaHack on 18.05.2020.
//  Copyright © 2020 HexaHack. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding  {
    
    let name: String
    let sex: String
    let userId: String
    var favouritesBreed: Set<String>
    var favouritesCategory: Set<Int>
    
    init(name: String, userId: String, sex: String, favouritesBreed: Set<String>, favouritesCategory: Set<Int>) {
        self.name = name
        self.sex = sex
        self.userId = userId
        self.favouritesBreed = favouritesBreed
        self.favouritesCategory = favouritesCategory
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(sex, forKey: "sex")
        coder.encode(userId, forKey: "userId")
        coder.encode(favouritesBreed, forKey: "favouritesBreed")
        coder.encode(favouritesCategory, forKey: "favouritesCategory")
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String ?? ""
        sex = coder.decodeObject(forKey: "sex") as? String ?? ""
        userId = coder.decodeObject(forKey: "userId") as? String ?? ""
        favouritesBreed = coder.decodeObject(forKey: "favouritesBreed") as? Set<String> ?? Set<String>()
        favouritesCategory = coder.decodeObject(forKey: "favouritesCategory") as? Set<Int> ?? Set<Int>()
    }
    

}
