//
//  UserTableViewController.swift
//  Catinder
//
//  Created by HexaHack on 18.05.2020.
//  Copyright © 2020 HexaHack. All rights reserved.
//

import UIKit

protocol isAbleToReceiveData {
    func passCategoriesId(ids: Set<Int>)
    func passBreedsId(ids: Set<String>)
}

class UserTableViewController: UITableViewController, isAbleToReceiveData {
    @IBOutlet weak var sexControl: UISegmentedControl!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    var userService: UserServiceProtocol!
    var favouritesCategory = Set<Int>()
    var favouritesBreeds = Set<String>()
    
    var sex = "Male"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let _userService: UserServiceProtocol = ServiceLocator.shared.getService() else {assertionFailure(); return}
        userService = _userService
        saveButton.layer.cornerRadius = 10
        
        setUserFromDefaults()
        userNameField.delegate = self
        configureTapGesture()
    }
    
    func setUserFromDefaults(){
        sex = userService.user.sex
        userNameField.text = userService.user.name
        nameLable.text = userNameField.text
        if sex == "Female" {
            sexControl.selectedSegmentIndex = 1
            userImageView.image = UIImage(named: "Female")
        }
    }
    
    func passCategoriesId(ids: Set<Int>) {
        favouritesCategory = ids
    }
    
    func passBreedsId(ids: Set<String>) {
        favouritesBreeds = ids
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favouritesCategory" {
            let vc =  segue.destination as? CategoryTableViewController
            vc?.delegate = self
            vc?.favourites = userService.user.favouritesCategory
        }
        if segue.identifier == "favouritesBreeds" {
            let vc =  segue.destination as? BreedsTableViewController
            vc?.delegate = self
            vc?.favourites = userService.user.favouritesBreed
        }
        
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
        
        let userObject = User(name: userNameField.text!,
                              userId: userNameField.text!,
                              sex: self.sex,
                              favouritesBreed: self.favouritesBreeds,
                              favouritesCategory: self.favouritesCategory)
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
