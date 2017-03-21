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

class CameraOverlayViewController: VideoPickerViewController{

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var recordedVideoView: VideoContainerView!

    var videoPlayer: AVPlayer!
    
    var videoLoaded = false
    
    let emojiImagesArray: [UIImage] = [#imageLiteral(resourceName: "happyFace"), #imageLiteral(resourceName: "sunglassesFace"), #imageLiteral(resourceName: "nerdFace"),#imageLiteral(resourceName: "speaker"), #imageLiteral(resourceName: "mic")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(replayVideo), name: .AVPlayerItemDidPlayToEndTime, object: videoPlayer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if videoLoaded == false {
            videoLoaded = self.startMediaBroswerFrom(viewController: self, using: self)
        }
    }
    func startPlayingVideoWith(_ url: URL){
        let playerItem = AVPlayerItem(url: url)
        
        videoPlayer = AVPlayer(playerItem: playerItem)
        videoPlayer.actionAtItemEnd = .none
        let videoLayer = AVPlayerLayer(player: videoPlayer)
        videoLayer.frame = recordedVideoView.bounds
        recordedVideoView.layer.addSublayer(videoLayer)
        recordedVideoView.playerLayer = videoLayer
        
        videoPlayer.play()
    }
    
    func replayVideo(){
        videoPlayer.seek(to: kCMTimeZero)
        videoPlayer.play()
    }
    
}


// // MARK: - Video Picker View Controller Subclass and Delegate
extension CameraOverlayViewController: VideoPickerViewControllerDelegate{
    
    func didFinishPickingVideoWith(url: URL) {
        DispatchQueue.main.async {
            self.startPlayingVideoWith(url)
        }
    }
}
