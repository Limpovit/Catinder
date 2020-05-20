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
    @IBOutlet weak var navItem: UINavigationItem!
    
    @IBOutlet weak var breedDescription: UITextView!
    
    
    var passedBreed: Breed!
    var imagesService: ImagesServiceProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navItem.title = passedBreed.name
        self.view.setGradient([ #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1).cgColor,  #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1).cgColor])
        guard let _imagesSercice: ImagesServiceProtocol = ServiceLocator.shared.getService() else {assertionFailure(); return}
        
        imagesService = _imagesSercice
        

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
