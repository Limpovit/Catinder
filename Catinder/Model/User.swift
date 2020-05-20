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
    let selectedCategory: String
    var userQuery: String {
        get {
            return "images/search?limit=10&mime_types=jpg,png&category_ids=\(selectedCategory)"
        }
    }
    
    init(name: String, userId: String, sex: String, selectedCategory: String) {
        self.name = name
        self.sex = sex
        self.userId = userId
       
        self.selectedCategory = selectedCategory
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(sex, forKey: "sex")
        coder.encode(userId, forKey: "userId")
        coder.encode(selectedCategory, forKey: "selectedCategory")
        
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String ?? ""
        sex = coder.decodeObject(forKey: "sex") as? String ?? ""
        userId = coder.decodeObject(forKey: "userId") as? String ?? ""
        selectedCategory = coder.decodeObject(forKey: "selectedCategory") as? String ?? ""
    }
}

