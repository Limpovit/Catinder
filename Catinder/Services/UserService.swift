//
//  UserService.swift
//  Catinder
//
//  Created by HexaHack on 18.05.2020.
//  Copyright © 2020 HexaHack. All rights reserved.
//

import Foundation

protocol UserServiceProtocol {
    var users: [User]? {get set}
    func getUser(key: Int) -> (User)
    func getUsersList() -> ([User])
    func saveUser() -> ()
    var defaults: UserDefaults {get set}
    var user: User! {get set}
}

enum Keys: String {
    case user
}

class UserService: UserServiceProtocol {
    var defaults = UserDefaults.standard
    
    var users: [User]?
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
    func getUser(key: Int) -> (User) {
        return user
    }
    
    func getUsersList() -> ([User]) {
        return users!
    }
    
    func saveUser() {
       
    }
    
    
}
