//
//  CatCardViewController.swift
//  NekoShelter
//
//  Created by HexaHack on 12.05.2020.
//  Copyright © 2020 HexaHack. All rights reserved.
//

import UIKit

class CatCardViewController: UIViewController {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var catName: UILabel!
    @IBOutlet weak var catBreed: UILabel!
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var rateImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        if xFromCenter > 0 {
            rateImage.image = UIImage(named: "like")
        } else {
            rateImage.image = UIImage(named: "unlike")
        }
        rateImage.alpha = abs(xFromCenter) / view.center.x
        
        if sender.state == UIGestureRecognizer.State.ended {
            
            if card.center.x < 75 {
                UIView.animate(withDuration: 0.3) {
                       card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
                    card.alpha = 0
                   }
                return
            } else if card.center.x > view.frame.width - 75 {
                UIView.animate(withDuration: 0.3) {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    card.alpha = 0
                }
                return
            }
            
        resetCard()
        }
    }
    
    @IBAction func reset(_ sender: UIButton) {
        resetCard()
    }
    
    func resetCard(){
        UIView.animate(withDuration: 0.2) {
            self.cardView.center = self.view.center
            self.rateImage.alpha = 0
            self.cardView.alpha = 1
        }
    }
    
}
