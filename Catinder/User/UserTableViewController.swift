//
//  UserTableViewController.swift
//  Catinder
//
//  Created by HexaHack on 18.05.2020.
//  Copyright © 2020 HexaHack. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    @IBOutlet weak var sexControl: UISegmentedControl!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var searchControl: UISegmentedControl!
    @IBOutlet weak var searchPeak: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var castomizeSearch: UISwitch!
   
    
    
    var categories: [String : Int] = [:]
    var categoriesName: [String] = []
    
    var apiService: APIServiceProtocol!
    var userService: UserServiceProtocol!
    
    var selectedCategory = ""
    var sex = "Male"
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        getServices()
        getCategories()
        saveButton.layer.cornerRadius = 10
        
        setUserFromDefaults()
        userNameField.delegate = self
        configureTapGesture()
        
    }
    
    func getServices(){
        guard let _userService: UserServiceProtocol = ServiceLocator.shared.getService() else {assertionFailure(); return}
        userService = _userService
        
        guard let _apiSercice: APIServiceProtocol = ServiceLocator.shared.getService() else {assertionFailure(); return}
        apiService = _apiSercice
    }
    
    func getCategories(){
        apiService.getData(query: "categories") { (categorie: [Category]) in
            for category in categorie{
                self.categories[category.name] = category.id
                self.categoriesName.append(category.name)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
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
    
    @IBAction func castomize(_ sender: UISwitch) {
        if !castomizeSearch.isOn {
            self.selectedCategory = ""
            
        }
        tableView.reloadData()
        
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
                              sex: self.sex, selectedCategory: self.selectedCategory)
        userService.user = userObject
        print(userObject.userQuery)
    }
    
    func configureTapGesture() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }

    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {

        if !castomizeSearch.isOn && (indexPath.section == 1 ){
            return 0
        }
        if castomizeSearch.isOn && (indexPath.section == 1 ){
            return 200
        }
        if indexPath.section == 0 && indexPath.row == 0 {
            return 150
        }
        return tableView.rowHeight
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

extension UserTableViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return categoriesName.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return categoriesName[row].capitalizingFirstLetter()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
                selectedCategory = String(categories[categoriesName[row]]!)
    }

}
    


extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
