//
//  CameraOverlayViewController.swift
//  MusicMind
//
//  Created by Angel Contreras on 3/17/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit

class CameraOverlayViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let emojiImagesArray: [UIImage] = [#imageLiteral(resourceName: "happyFace"), #imageLiteral(resourceName: "sunglassesFace"), #imageLiteral(resourceName: "nerdFace"),#imageLiteral(resourceName: "speaker"), #imageLiteral(resourceName: "mic")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self

    }
}

