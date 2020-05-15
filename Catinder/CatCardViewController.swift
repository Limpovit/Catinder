//
//  CatCardViewController.swift
//  NekoShelter
//
//  Created by HexaHack on 12.05.2020.
//  Copyright © 2020 HexaHack. All rights reserved.
//

import UIKit

class CatCardViewController: UIViewController {
    
    @IBOutlet weak var cardViews: UIView!
    @IBOutlet weak var card: CardView!
    @IBOutlet weak var card2: CardView!
    @IBOutlet weak var card3: CardView!
    
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var rateImage: UIImageView!
    
    var divisor: CGFloat!
    let getURL = "https://api.thecatapi.com/v1/images/search?limit=10"
    var cats: [Cats]?
    var catsImages = [UIImage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
//        card.layer.cornerRadius = 20
        
        divisor = (view.frame.width / 2) / 0.61
        
        
        getCatsArray { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cats):
                    self?.cats = cats
                    self?.loadCatsImage(cats: cats!, completion: { (catsImages) in
                        self!.catsImages = catsImages
                        self!.card.catImageView.image = catsImages[0]
                            self!.card2.catImageView.image = catsImages[1]
                        self!.card3.catImageView.image = catsImages[2]
                    })
                case .failure(let error):
                    print(error)
                }
            }
        }
        
    }
     
    @IBAction func testPan(_ sender: UIPanGestureRecognizer) {
        let card = sender.view! as! CardView
        let point = sender.translation(in: cardViews)
        let xFromCenter = card.center.x - cardViews.center.x
        let scale = min(80/abs(xFromCenter), 1)
        card.center = CGPoint(x: cardViews.center.x + point.x, y: cardViews.center.y + point.y)
        
        card.transform = CGAffineTransform(rotationAngle: xFromCenter/divisor).scaledBy(x: scale, y: scale)
        
        if xFromCenter > 0 {
            card.emojiImageView.image = UIImage(named: "like")
        } else {
            card.emojiImageView.image = UIImage(named: "unlike")
        }
        card.emojiImageView.alpha = abs(xFromCenter) / cardViews.center.x
        
        if sender.state == UIGestureRecognizer.State.ended {
            
            if card.center.x < 75 {
                UIView.animate(withDuration: 0.3, delay: 0.1, animations: {
                     card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
                     card.alpha = 0
                }, completion: { (finished: Bool) in
                    self.resetCard(card)
                } )
                
                return
            } else if card.center.x > cardViews.frame.width - 75 {
                UIView.animate(withDuration: 0.3, delay: 0.1, animations: {
                     card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                     card.alpha = 0
                }, completion: { (finished: Bool) in
                    self.resetCard(card)
                } )
                
                return
            } else {
                returnCard(card)
            }
            
            
        }
        
    }

    func returnCard(_ card: CardView){
        UIView.animate(withDuration: 0.2) {
            card.center = self.cardViews.center
            card.emojiImageView.alpha = 0
            card.alpha = 1
            card.transform = CGAffineTransform.identity
        }
    }
    
    func resetCard(_ card: CardView) {
         self.cardViews.sendSubviewToBack(card)
         card.center = self.cardViews.center
         card.emojiImageView.alpha = 0
         card.transform = CGAffineTransform.identity
         card.alpha = 1
        
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
    
    func loadCatsImage(cats: [Cats], completion: @escaping ([UIImage]) -> ()) {
        var catsImages = [UIImage]()
        DispatchQueue.concurrentPerform(iterations: cats.count) { (index) in
            let catURL = URL(string: cats[index].url)!
                if let data = try? Data(contentsOf: catURL) {
                    let image = UIImage(data: data)
                    catsImages.append(image!)
                    print("image \(index) downlodaded")
                    }
                }
                 completion(catsImages)
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

