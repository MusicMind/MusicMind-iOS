//
//  CameraOverlayViewController.swift
//  MusicMind
//
//  Created by Angel Contreras on 3/17/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class CameraOverlayViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationBarDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var recordedVideoView: VideoContainerView!

    var videoPlayer: AVPlayer!
    var videoAsset: AVAsset?
    
    let emojiImagesArray: [UIImage] = [#imageLiteral(resourceName: "happyFace"), #imageLiteral(resourceName: "sunglassesFace"), #imageLiteral(resourceName: "nerdFace"),#imageLiteral(resourceName: "speaker"), #imageLiteral(resourceName: "mic")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    func startPlayingVideoWith(_ url: URL){
        print(url)
        print(FileManager.default.fileExists(atPath: url.path))
        let playerItem = AVPlayerItem(url: url)
        
        videoPlayer = AVPlayer(playerItem: playerItem)
        
        let videoLayer = AVPlayerLayer(player: videoPlayer)
        videoLayer.frame = recordedVideoView.bounds
        recordedVideoView.layer.addSublayer(videoLayer)
        recordedVideoView.playerLayer = videoLayer
        
        videoPlayer.play()
        print(url)
    }
    
}

