//
//  APIService.swift
//  Catinder
//
//  Created by HexaHack on 16.05.2020.
//  Copyright © 2020 HexaHack. All rights reserved.
//

import Foundation


protocol  APIServiceProtocol {
    func getData<T: Decodable>(query: String, completion: @escaping (T) -> Void) -> (Void)
}

class APIService: APIServiceProtocol {
    func  getData<T: Decodable>(query: String, completion: @escaping (T) -> Void) -> (Void) {
        
        let getURL = "https://api.thecatapi.com/v1/" + query
        guard let url = URL(string: getURL) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            do {
                let obj = try JSONDecoder().decode( T.self, from: data!) as! T
                completion(obj)
            }
                
            catch let error {
                print(error.localizedDescription)
            }
            
        }.resume()
    }
}

