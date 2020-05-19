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
    
    
    var passedBreed: Breed!
    var imagesService: ImagesServiceProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.setGradient([ #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1).cgColor,  #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1).cgColor])
        guard let _imagesSercice: ImagesServiceProtocol = ServiceLocator.shared.getService() else {assertionFailure(); return}
        
        imagesService = _imagesSercice
        
        
        breedName.text = passedBreed.name
        breedDescription.text = passedBreed.breedDescription
        
        
        imagesService.loadBreedImageData(id: passedBreed.id) { (data) in
            guard let image = UIImage(data: data) else {print ("error")
                return}
            DispatchQueue.main.async {
                
                self.breedImage.image = image
                             
            }
        }
        
    }
    
}
