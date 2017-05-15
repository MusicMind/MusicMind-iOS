//
//  VideoContainerView.swift
//  MusicMind
//
//  Created by Angel Contreras on 3/18/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit

class VideoContainerView: UIView{
    var playerLayer: CALayer?
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        playerLayer?.frame = self.bounds
    }
}
