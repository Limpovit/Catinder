//
//  ImagesService.swift
//  Catinder
//
//  Created by HexaHack on 16.05.2020.
//  Copyright © 2020 HexaHack. All rights reserved.
//

import Foundation


protocol ImagesServiceProtocol {
    func getNextImageData() -> (Data)
    func loadImagesData(complition: @escaping () -> ()) -> ()
    var catImagesCount : Int {get}
}

class ImagesService: ImagesServiceProtocol {
    
    var catsImagesData = [Data]()
    let apiService: APIServiceProtocol
    public var catImagesCount : Int {
        get { return catsImagesData.count
        }
    }
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    
    func getNextImageData() -> (Data){
        if catImagesCount < 8 {
            loadImagesData {
                print("loaded next kitties")
            }
        }
        return catsImagesData.removeFirst()
    }
    
    func loadImagesData(complition: @escaping () -> ()) {
        
        apiService.getData(query: "images/search?limit=10", completion: { [weak self] (cats: [Cats]) in
            
            DispatchQueue.concurrentPerform(iterations: cats.count) { (index) in
                let catURL = URL(string: cats[index].url)!
                if let data = try? Data(contentsOf: catURL) {
                    self?.catsImagesData.append(data)
                }
            }
            complition()
        })
    }
}

