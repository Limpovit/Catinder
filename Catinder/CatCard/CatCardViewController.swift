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

    
    
    
    
    var tabBar: MyTabBarController?
    let apiService = APIService()
    var imagesService: ImagesServiceProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagesService = ImagesService(apiService: apiService)
        self.view.setGradient([ #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1).cgColor,  #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1).cgColor])
        firstLoad()
        tabBar = tabBarController as? MyTabBarController
        
        
        
    }
    
    
    
    
    func firstLoad(){
        
        imagesService.loadImagesData {
            DispatchQueue.main.async {
                for  card in self.cardViews.subviews as! [CardView] {
                    guard let image = UIImage(data: self.imagesService.getNextImageData()) else {return}
                    card.catImageView.image = image
                    card.bringSubviewToFront(card.emojiImageView)
                }
            }
        }
    }
    
    
    @IBAction func testPan(_ sender: UIPanGestureRecognizer) {
        let viewCenter = cardViews.center
        let card = sender.view! as! CardView
        let point = sender.translation(in: cardViews)
        let xFromCenter = card.center.x - viewCenter.x
        let scale = min(80/abs(xFromCenter), 1)
        let divisor = (view.frame.width / 2) / 0.61
        print(xFromCenter, point)
        card.center = CGPoint(x: viewCenter.x + point.x, y: viewCenter.y + point.y)
        
        card.transform = CGAffineTransform(rotationAngle: xFromCenter/divisor).scaledBy(x: scale, y: scale)
        let isLike = xFromCenter > 0
        if isLike {
            card.emojiImageView.image = UIImage(named: "like")
        } else {
            card.emojiImageView.image = UIImage(named: "unlike")
        }
        card.emojiImageView.alpha = abs(xFromCenter) / cardViews.center.x
        
        if sender.state == UIGestureRecognizer.State.ended {
            
            if abs(xFromCenter) < 130 || imagesService.catImagesCount < 2 {
                returnCard(card)
                return
            }
            
            UIView.animate(withDuration: 0.3, delay: 0.0, animations: {
                card.center = CGPoint(x: 5 * xFromCenter, y: viewCenter.y * 2)
                card.alpha = 0
            }, completion: { (finished: Bool) in
                if isLike {self.tabBar?.addToFavourites(image: card.catImageView.image!)
                }
                self.resetCard(card)
            } )
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

