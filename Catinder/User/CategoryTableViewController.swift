//
//  CategoryTableViewController.swift
//  Catinder
//
//  Created by HexaHack on 17.05.2020.
//  Copyright © 2020 HexaHack. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    
    var delegate: isAbleToReceiveData?
    
    var categories: [String : Int] = [:]
    var categoriesName: [String] = []
    var apiService: APIServiceProtocol!
    var favourites = Set<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(favourites)
        guard let _apiSercice: APIServiceProtocol = ServiceLocator.shared.getService() else {assertionFailure(); return}
        apiService = _apiSercice
        apiService.getData(query: "categories") { (categories: [Category]) in
            for category in categories {
                self.categories[category.name] = category.id
                self.categoriesName.append(category.name)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate!.passCategoriesId(ids: favourites)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "category", for: indexPath)
        
        if favourites.contains(categories[categoriesName[indexPath.row]]!) {
            cell.accessoryType = .checkmark
        }
        cell.textLabel?.text = "\(categoriesName[indexPath.row].capitalizingFirstLetter())"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath){
            guard let id = categories[categoriesName[indexPath.row]] else {return}
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
                self.favourites.insert(id)
                print("\(id)")
            } else {
                cell.accessoryType = .none
                self.favourites.remove(id)
            }
        }
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
