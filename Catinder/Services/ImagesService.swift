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
    func loadBreedImageData (id: String, complition: @escaping (Data) -> ())
    func removeImages() -> ()
    var catImagesCount : Int {get}
}

class ImagesService: ImagesServiceProtocol {

    
    
    var catsImagesData = [Data]()
    
    let apiService: APIServiceProtocol
    let userService: UserServiceProtocol
    public var catImagesCount : Int {
        get { return catsImagesData.count
        }
    }
    
    init(apiService: APIServiceProtocol, userService: UserService) {
        self.apiService = apiService
        self.userService = userService
    }
    func removeImages() {
        if catsImagesData.isEmpty {
            catsImagesData.removeAll()
            
        }
    }
    
    func getNextImageData() -> (Data){
        if catImagesCount < 3 {
            loadImagesData {
                print("loaded next kitties")
            }
        }
        return catsImagesData.removeFirst()
    }
    
    func loadImagesData(complition: @escaping () -> ()) {
        print(userService.user.userQuery)
        apiService.getData(query: userService.user.userQuery, completion: { [weak self] (cats: [Cats]) in
            
            DispatchQueue.concurrentPerform(iterations: cats.count) { (index) in
                let catURL = URL(string: cats[index].url)!
                if let data = try? Data(contentsOf: catURL) {
                    self?.catsImagesData.append(data)
                }
            }
            complition()
        })
    }
    
    func loadBreedImageData (id: String, complition: @escaping (Data) -> ())  {
        var breedImageData = Data()
        apiService.getData(query: "images/search?breed_id=\(id)", completion:  { (cats: [Cats]) in
            
            let catURL = URL(string: cats[0].url)!
            if let data = try? Data(contentsOf: catURL) {
                breedImageData = data
            }
            complition(breedImageData)
        })
    }
}


