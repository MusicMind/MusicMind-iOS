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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // steps to add emoji to overlay layer
        /*
         1. add image view of emoji with pan gesture to move it around
         2. add all emojis to a collection to loop through
         3a. add videolayer to the parent layer
         3b. add each layer of each emoji in the collection to the parent layer
         4. flat the layers
         */
    }
}
