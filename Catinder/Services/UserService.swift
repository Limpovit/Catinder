//
//  UserService.swift
//  Catinder
//
//  Created by HexaHack on 18.05.2020.
//  Copyright © 2020 HexaHack. All rights reserved.
//

import Foundation

protocol UserServiceProtocol {
  
    var defaults: UserDefaults {get set}
    var user: User! {get set}   
    
}

class UserService: UserServiceProtocol {
    
    
    var defaults = UserDefaults.standard
    

    var user: User! {
               get {
                   guard let savedData = UserDefaults.standard.object(forKey: "user") as? Data, let decodedUser = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedData) as? User else {return nil}
                   return decodedUser
               }
               set {
                   let key = "user"
                   if let user = newValue {
                       if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: user, requiringSecureCoding: false) {
                           defaults.set(savedData, forKey: key)

                }
            }
        }
    }
    
    
}
