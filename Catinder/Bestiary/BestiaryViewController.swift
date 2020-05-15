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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getBreedsArray { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let breeds):
                    self!.breedsArray = breeds!
                    self?.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func getBreedsArray(completion: @escaping (Result<[Breed]?, Error>) -> Void) {
        
        guard let url = URL(string: "https://api.thecatapi.com/v1/breeds") else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                let obj = try JSONDecoder().decode( [Breed].self, from: data!)
                completion(.success(obj))
            } catch let error {
                completion(.failure(error))
            }
        }.resume()
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedBreed = breedsArray[indexPath.row]
//              performSegue(withIdentifier: "test", sender: self)
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
//        selectedBreed = breedsArray[indexPath.row]
//        performSegue(withIdentifier: "test", sender: self)
        print("tap")
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

