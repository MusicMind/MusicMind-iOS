//
//  StickersViewController.swift
//  MusicMind
//
//  Created by Angel Contreras on 3/17/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class StickersViewController: VideoPickerViewController{

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var recordedVideoView: VideoContainerView!

    var videoPlayer: AVPlayer!
    var stickersAdded: [UIImageView] = []
    var videoLoaded = false
    
    let emojiImagesArray: [UIImage] = [#imageLiteral(resourceName: "cool"), #imageLiteral(resourceName: "happy"), #imageLiteral(resourceName: "nerd"), #imageLiteral(resourceName: "speaker"), #imageLiteral(resourceName: "mic")]
    
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
        // seek back to zero and play
        videoPlayer.seek(to: kCMTimeZero)
        videoPlayer.play()
    }
    
    override func applyVideoEffectsTo(composition: AVMutableVideoComposition, size: CGSize) {
        let rect = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
        let parentLayer = CALayer()
        let videoLayer = CALayer()
        parentLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        videoLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        print(parentLayer.frame)
        
        
        parentLayer.addSublayer(videoLayer)
        stickersAdded.forEach { (imageView) in
            let stickerLayer = CALayer()
            stickerLayer.contents = imageView.image?.cgImage
            stickerLayer.frame = CGRect(origin: imageView.frame.origin, size: CGSize(width: 110, height: 110))
            stickerLayer.masksToBounds = true
            parentLayer.addSublayer(stickerLayer)
        }
        
        composition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
    }
    
    
    @IBAction func exportButtonPressed(_ sender: Any) {
        self.videoOutput()
    }
}


// MARK: - Video Picker View Controller Subclass and Delegate
extension StickersViewController: VideoPickerViewControllerDelegate{
    
    func didFinishPickingVideoWith(url: URL) {
        DispatchQueue.main.async {
            self.startPlayingVideoWith(url)
        }
    }
}
