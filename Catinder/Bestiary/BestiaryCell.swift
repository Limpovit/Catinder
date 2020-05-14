//
//  BestiaryCell.swift
//  Catinder
//
//  Created by HexaHack on 13.05.2020.
//  Copyright © 2020 HexaHack. All rights reserved.
//

import UIKit

class BestiaryCell: UITableViewCell {

    @IBOutlet weak var breedImage: UIImageView!
    @IBOutlet weak var breedName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
