//
//  AVVideoExporter.swift
//  MusicMind
//
//  Created by Angel Contreras on 4/24/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import Foundation
import AVFoundation

class AVVideoExporter{
    var videoAsset: AVAsset?
    
    convenience init(url: URL){
        let videoAsset = AVAsset(url: url)
        self.init(videoAsset: videoAsset)
    }
    
    init(videoAsset: AVAsset){
        self.videoAsset = videoAsset
    }
    
    
    
}
