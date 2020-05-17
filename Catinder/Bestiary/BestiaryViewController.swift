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
    var apiService = APIService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
}

