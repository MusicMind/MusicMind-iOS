//
//  PostProcessingViewController.swift
//  MusicMind
//
//  Created by Angel Contreras on 3/17/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import Photos
import AVKit

class PostProcessingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var recordedVideoView: VideoContainerView!
    @IBOutlet weak var assetsButton: UIButton!
    @IBOutlet weak var exportButton: UIButton!

    var videoPlayer: AVPlayer!
    var videoLoaded = false
    var isHidden = false
    
    
    /// The url in which the Camera Capture save the video or photo it captures.
    /// If empty, image picker shows up.
    var videoAssetURL: URL?
    
    let assets: [UIImage] = [#imageLiteral(resourceName: "guitar") ]
  
    var avVideoExporter: AVVideoExporter?
    var stickersAdded: [UIImageView] = []
    var localUrlOfOriginalVideo: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if let videoUrl = localUrlOfOriginalVideo {
            startPlayingVideoWith(videoUrl)
        }
        
        setupNavigationBar(theme: .light)
        
        NotificationCenter.default.addObserver(self, selector: #selector(replayVideo), name: .AVPlayerItemDidPlayToEndTime, object: videoPlayer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let videoAssetURL = videoAssetURL{
            startPlayingVideoWith(videoAssetURL)
            avVideoExporter = AVVideoExporter(url: videoAssetURL)
            videoLoaded =  true
        } else if videoLoaded == false {
            videoLoaded = self.startMediaBroswerFrom(viewController: self, using: self)
        }
    }
    
    
    func startMediaBroswerFrom(viewController: UIViewController?, using delegate: Any?) -> Bool{
        
        // some validation
        if ((UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) == false) || (delegate == nil) || (viewController == nil)){
            return false
        }
        
        // get image picker
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .savedPhotosAlbum
        imagePickerController.mediaTypes = [kUTTypeMovie as String]
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = delegate as! (UIImagePickerControllerDelegate & UINavigationControllerDelegate)?
        
        // display image picker
        viewController?.present(imagePickerController, animated: true, completion: nil)
        
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // dismiss image picker
        self.dismiss(animated: true, completion: nil)
        
        let url = info[UIImagePickerControllerMediaURL] as! URL
        
        avVideoExporter = AVVideoExporter(url: url)
        
        self.startPlayingVideoWith(url)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
	
    @IBAction func activityButtonPressed(_ sender: Any) {
        // creating activity
        let uploadActivity = UploadActivity()
        
        // creating activity view controller
        if let localUrlOfOriginalVideo = localUrlOfOriginalVideo {
            let activityController = UIActivityViewController(activityItems: [localUrlOfOriginalVideo], applicationActivities: [uploadActivity])
            
            present(activityController, animated: true, completion: nil)
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
    
    @IBAction func emojiButtonPressed(_ sender: Any) {
        let startingFrame = CGRect(origin: CGPoint(x: 0, y: collectionView.frame.origin.y) , size: collectionView.frame.size)
        let hiddenFrame = CGRect(origin: CGPoint(x: collectionView.frame.width, y: collectionView.frame.origin.y) , size: collectionView.frame.size)
        UIView.animate(withDuration: 0.4, animations: { 
            if self.isHidden {
                self.collectionView.frame = startingFrame
                self.collectionView.alpha = 1.0
            } else {
                self.collectionView.frame = hiddenFrame
                self.collectionView.alpha = 0.0
            }
            
        }) { (_) in
            self.isHidden = !self.isHidden
        }
    }
    
    @IBAction func exportButtonPressed(_ sender: Any) {
        self.avVideoExporter?.output()
    }
}

