//
//  BestiatyViewController.swift
//  NekoShelter
//
//  Created by HexaHack on 12.05.2020.
//  Copyright © 2020 HexaHack. All rights reserved.
//

import UIKit

class BestiaryViewController: UITableViewController {
    
    
    var breedsArray = [Breed]()
    var selectedBreed: Breed?
    var apiService: APIServiceProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = .lightGray
        tableView.backgroundView = UIView()
        self.tableView.backgroundView?.setGradient([ #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1).cgColor,  #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1).cgColor])
        guard let _apiSercice: APIServiceProtocol = ServiceLocator.shared.getService() else {assertionFailure(); return}
        
        apiService = _apiSercice
        
        apiService.getData(query: "breeds") { (breedsArray: [Breed]) in
            self.breedsArray = breedsArray
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedBreed = breedsArray[indexPath.row]
        return indexPath
    }
       
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "test" {
            let vc = segue.destination as? DetailViewController
            vc?.passedBreed = selectedBreed
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return breedsArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "BestiaryCell", for: indexPath) as? BestiaryCell {
            
            cell.breedName.text = breedsArray[indexPath.row].name
            return  cell
        }
        return BestiaryCell()
    }
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
}

