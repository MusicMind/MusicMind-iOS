//
//  EmojiCollectionViewCell.swift
//  MusicMind
//
//  Created by Angel Contreras on 3/17/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit

class EmojiCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var emojiImageView: UIImageView!
    
    func updateWith(image: UIImage?){
        emojiImageView.image = image
    }
}
