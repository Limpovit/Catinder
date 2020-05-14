//
//  CatCardViewController.swift
//  NekoShelter
//
//  Created by HexaHack on 12.05.2020.
//  Copyright © 2020 HexaHack. All rights reserved.
//

import UIKit

class CatCardViewController: UIViewController {
    
    @IBOutlet weak var card: CardView!
    @IBOutlet weak var card2: CardView!
    @IBOutlet weak var card3: CardView!
    
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var rateImage: UIImageView!
    
    var divisor: CGFloat!
    let getURL = "https://api.thecatapi.com/v1/images/search?limit"
    var cats: [Cats]?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
//        card.layer.cornerRadius = 20
        
        divisor = (view.frame.width / 2) / 0.61
        
        
        getCatsArray { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cats):
                    self?.cats = cats
                    self?.loadCatsImage(cats: cats!)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
     
    @IBAction func testPan(_ sender: UIPanGestureRecognizer) {
        let card = sender.view! as! CardView
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        let scale = min(80/abs(xFromCenter), 1)
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        card.transform = CGAffineTransform(rotationAngle: xFromCenter/divisor).scaledBy(x: scale, y: scale)
        
        if xFromCenter > 0 {
            card.emojiImageView.image = UIImage(named: "like")
        } else {
            card.emojiImageView.image = UIImage(named: "unlike")
        }
        card.emojiImageView.alpha = abs(xFromCenter) / view.center.x
        
        if sender.state == UIGestureRecognizer.State.ended {
            if card.center.x < 75 {
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
                   // card.alpha = 0
                    card.removeFromSuperview()
                    
                }
                return
            } else if card.center.x > view.frame.width - 75 {
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    //card.alpha = 0
                     card.removeFromSuperview()
                }
                return
            }
           
        }
    }
    
    @IBAction func reset(_ sender: UIButton) {
        
    }

    
    func resetCard(view: CardView){
        UIView.animate(withDuration: 0.2) {
            view.center = self.view.center
            view.emojiImageView.alpha = 0
            view.alpha = 1
            view.transform = CGAffineTransform.identity
            
        }
    }
    
    func getCatsArray(completion: @escaping (Result<[Cats]?, Error>) -> Void) {
        
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
    
    
    
    //    let imageCache = NSCache<NSString, UIImage>()
    
    func loadCatsImage(cats: [Cats]) {
        
        let catURL = URL(string: cats[0].url)!
        if let data = try? Data(contentsOf: catURL) {
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.card.catImageView.image = image
            
            }
        }
    }
}

extension UIImageView {
    func load(by url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = image
                        
                    }
                }
            }
        }
    }
}

