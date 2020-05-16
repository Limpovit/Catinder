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
    
    
    
   
    var tabBar: MyTabBarController?
    let apiService = APIService()
    var imagesService: ImagesServiceProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagesService = ImagesService(apiService: apiService)
        self.view.setGradient([ #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1).cgColor,  #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1).cgColor])
        firstLoad()
        tabBar = tabBarController as? MyTabBarController
        
        
        
    }
    
    
    
    
    func firstLoad(){
        
        imagesService.loadImagesData {
            DispatchQueue.main.async {
                for  card in self.cardViews.subviews as! [CardView] {
                    guard let image = UIImage(data: self.imagesService.getNextImageData()) else {return}
                    card.catImageView.image = image
            }
        }
        }
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
            
            if card.center.x < 75 && imagesService.catImagesCount > 1 {
                UIView.animate(withDuration: 0.3, delay: 0.1, animations: {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
                    card.alpha = 0
                }, completion: { (finished: Bool) in
                    self.resetCard(card)
                } )
                return
                
            } else if card.center.x > cardViews.frame.width - 75  && imagesService.catImagesCount > 1{
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
        guard let image = UIImage(data: self.imagesService.getNextImageData()) else {return}
        card.catImageView.image = image
        card.center = self.cardViews.center
        card.emojiImageView.alpha = 0
        card.transform = CGAffineTransform.identity
        card.alpha = 1
        
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

