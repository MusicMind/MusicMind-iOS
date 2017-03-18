//
//  CameraOverlayViewController + collectionViewHelper.swift
//  MusicMind
//
//  Created by Angel Contreras on 3/17/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit

extension CameraOverlayViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return emojiImagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as? EmojiCollectionViewCell
        
        let emojiImage = emojiImagesArray[indexPath.row]
        cell?.updateWith(image: emojiImage)
        
        return cell ?? EmojiCollectionViewCell()
        
    }
}
