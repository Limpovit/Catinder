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
        addSubview(contentView)        
        contentView.frame = self.bounds
        contentView.layer.cornerRadius = 20
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
}
