//
//  UserTableViewController.swift
//  Catinder
//
//  Created by HexaHack on 18.05.2020.
//  Copyright © 2020 HexaHack. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameField: UITextField!
    
    var userService: UserServiceProtocol!
    
    var sex = "Male"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameField.delegate = self
        configureTapGesture()
        
        guard let _userService: UserServiceProtocol = ServiceLocator.shared.getService() else {assertionFailure(); return}
            
            userService = _userService
        
        nameLable.text = userService.user.name
        
    }
    @IBAction func chooseSex(_ sender: UISegmentedControl) {
        
        sex = sender.titleForSegment(at: sender.selectedSegmentIndex)!
        switch sex {
        case "Male":
            userImageView.image = UIImage(named: "Male")
        case "Female":
            userImageView.image = UIImage(named: "Female")
        default:
            return
        }
    }
    
    @IBAction func saveUser(_ sender: UIButton) {
        var userObject = User(name: userNameField.text!, userId: userNameField.text!, sex: self.sex, favouritesBreed: [""], favouritesCategory: [0]) 
        
        userService.user = userObject
        
    }
    
    func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc func handleTap() {
       
        view.endEditing(true)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
}

extension UserTableViewController: UITextFieldDelegate {
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameLable.text = userNameField.text
        userNameField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        nameLable.text = userNameField.text
    }
  
}
