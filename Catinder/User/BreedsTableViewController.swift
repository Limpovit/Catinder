//
//  BreedsTableViewController.swift
//  Catinder
//
//  Created by HexaHack on 17.05.2020.
//  Copyright © 2020 HexaHack. All rights reserved.
//

import UIKit

class BreedsTableViewController: UITableViewController {

        var delegate: isAbleToReceiveData?
         
         var breeds: [String : String] = [:]
         var breedName: [String] = []
         var apiService: APIServiceProtocol!
         var favourites = Set<String>()
         
         override func viewDidLoad() {
             super.viewDidLoad()
             print(favourites)
             guard let _apiSercice: APIServiceProtocol = ServiceLocator.shared.getService() else {assertionFailure(); return}
             apiService = _apiSercice
             apiService.getData(query: "breeds") { (breeds: [Breed]) in
                 for breed in breeds {
                     self.breeds[breed.name] = breed.id
                     self.breedName.append(breed.name)
                 }
                 DispatchQueue.main.async {
                     self.tableView.reloadData()
                 }
             }
         }
         
         override func viewDidDisappear(_ animated: Bool) {
             delegate!.passBreedsId(ids: favourites)
         }
         
         // MARK: - Table view data source
         
         override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
             // #warning Incomplete implementation, return the number of rows
             return breeds.count
         }
         
         override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
             let cell = tableView.dequeueReusableCell(withIdentifier: "favouritesBreeds", for: indexPath)
            if favourites.contains(breeds[breedName[indexPath.row]]!) {
                        cell.accessoryType = .checkmark
                print("\(indexPath.row)")
            } else {
                cell.accessoryType = .none
            }
             cell.textLabel?.text = "\(breedName[indexPath.row].capitalizingFirstLetter())"
             return cell
         }
         
         override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
             if let cell = tableView.cellForRow(at: indexPath){
                 guard let id = breeds[breedName[indexPath.row]] else {return}
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
