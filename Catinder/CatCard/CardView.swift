//
//  CardView.swift
//  Catinder
//
//  Created by HexaHack on 14.05.2020.
//  Copyright © 2020 HexaHack. All rights reserved.
//

import UIKit

class CardView: UIView {
        
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var emojiImageView: UIImageView!
    @IBOutlet weak var catImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)        
        commonInit()
        
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("CardView" , owner: self, options: nil)
            
        contentView.frame = self.bounds
        contentView.setGradient([ #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1).cgColor,  #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1).cgColor], rounded: true)
        contentView.layer.cornerRadius = 20
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
       
       addSubview(contentView)    
    }

}
