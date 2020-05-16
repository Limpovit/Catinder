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
    
    
    
    var catsImages = [UIImage]()
    var tabBar: MyTabBarController?
    let apiService = APIService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setGradient([ #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1).cgColor,  #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1).cgColor])
        firstLoad()
        tabBar = tabBarController as? MyTabBarController
        
        
        
    }
    
    
    
    
    func firstLoad(){
        apiService.getData(query: "images/search?limit=5", completion: { [weak self] (cats: [Cats]) in
            
            self?.loadCatsImage(cats: cats)
            DispatchQueue.main.async {
                guard let self = self else {return}
                for  card in self.cardViews.subviews as! [CardView] {
                
                    card.catImageView.image = self.catsImages.removeFirst()
            }
        }
    })
    }
    
    
    @IBAction func testPan(_ sender: UIPanGestureRecognizer) {
        
        let card = sender.view! as! CardView
        let point = sender.translation(in: cardViews)
        let xFromCenter = card.center.x - cardViews.center.x
        let scale = min(80/abs(xFromCenter), 1)
        let divisor = (self.view.frame.width / 2) / 0.61
        card.center = CGPoint(x: cardViews.center.x + point.x, y: cardViews.center.y + point.y)
        
        card.transform = CGAffineTransform(rotationAngle: xFromCenter/divisor).scaledBy(x: scale, y: scale)
        
        if xFromCenter > 0 {
            card.emojiImageView.image = UIImage(named: "like")
        } else {
            card.emojiImageView.image = UIImage(named: "unlike")
        }
        card.emojiImageView.alpha = abs(xFromCenter) / cardViews.center.x
        
        if sender.state == UIGestureRecognizer.State.ended {
            
            if card.center.x < 75 && catsImages.count > 1 {
                UIView.animate(withDuration: 0.3, delay: 0.1, animations: {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
                    card.alpha = 0
                }, completion: { (finished: Bool) in
                    self.resetCard(card)
                } )
                return
                
            } else if card.center.x > cardViews.frame.width - 75  && catsImages.count > 1{
                UIView.animate(withDuration: 0.3, delay: 0.1, animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    card.alpha = 0
                }, completion: { (finished: Bool) in                   
                    self.tabBar?.addToFavourites(image: card.catImageView.image!)
                    self.resetCard(card)
                } )
                return
                
            } else {
                returnCard(card)
            }
        }
        
    }
    
    func loadNextImages() {
        apiService.getData(query: "images/search?limit=10", completion: { [weak self] (cats: [Cats])  in
            DispatchQueue.global().async {
                    self?.loadCatsImage(cats: cats)
                
                }
            })
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
        card.catImageView.image = self.catsImages.removeFirst()
        if catsImages.count < 8 {
            loadNextImages()
        }
        
        card.center = self.cardViews.center
        card.emojiImageView.alpha = 0
        card.transform = CGAffineTransform.identity
        card.alpha = 1
        
    }    

    
    func loadCatsImage(cats: [Cats]) {
        
        DispatchQueue.concurrentPerform(iterations: cats.count) { (index) in
            let catURL = URL(string: cats[index].url)!
            if let data = try? Data(contentsOf: catURL) {
                guard let image = UIImage(data: data) else {return}
                catsImages.append(image)
                print("image \(index) downlodaded")
            }
        }
        }
        
    }


extension UIView {
    func setGradient(_ colors: [CGColor], rounded: Bool = false) {
        
        let gradientLayer = CAGradientLayer()
        if rounded {
            gradientLayer.cornerRadius = 20
        }
        gradientLayer.frame = self.bounds
        gradientLayer.type = .axial
        gradientLayer.colors = colors
        self.layer.insertSublayer(gradientLayer, at: 0)
        
    }
}
