//
//  DetailViewController.swift
//  Catinder
//
//  Created by HexaHack on 14.05.2020.
//  Copyright © 2020 HexaHack. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var breedImage: UIImageView!
    @IBOutlet weak var breedName: UILabel!
    @IBOutlet weak var breedDescription: UITextView!
    
  
    var passedBreed: Breed?
     
    
    override func viewDidLoad() {
        super.viewDidLoad()

        breedName.text = passedBreed?.name
        breedDescription.text = passedBreed?.breedDescription

        getCatImage(id: passedBreed!.id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cats):
                    self?.breedImage.load(by: cats![0].url)

                case .failure(let error):
                    print(error)
                }
            }
        }
  }
    
    func getCatImage(id: String, completion: @escaping (Result<[Cats]?, Error>) -> Void) {
        let getURL = "https://api.thecatapi.com/v1/images/search?breed_id=\(id)"
        guard let url = URL(string: getURL) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            do {
                let obj = try JSONDecoder().decode( [Cats].self, from: data!)
                completion(.success(obj))
            }
                
            catch let error {
                completion(.failure(error))
            }
            
        }.resume()
    }


}
extension UIImageView {
    func load(by stringURL: String) {
        let url = URL(string: stringURL)
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = image
                        
                    }
                }
            }
        }
    }
}

