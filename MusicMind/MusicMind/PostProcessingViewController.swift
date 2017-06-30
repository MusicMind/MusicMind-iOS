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
    @IBOutlet weak var imageView: UIImageView!

    var videoPlayer: AVPlayer!
    var videoLoaded = false
    var isHidden = false
    var image: UIImage!

    let assets: [UIImage] = [#imageLiteral(resourceName: "guitar")]
    
    var avVideoExporter: AVVideoExporter?
    var stickersAdded: [UIImageView] = []
    
    /// The url in which the Camera Capture save the video or photo it captures.
    /// If empty, image picker shows up.
    var localUrlOfOriginalVideo: URL?
    var localUrlOfOriginalImage: UIImage?
    var useImage: Bool?
    
    override func viewDidLoad() {
        if let v = self.navigationController?.viewControllers {
            if v.count >= 2 && v[v.count - 2].classForCoder != CameraCaptureViewController.classForCoder() {
                self.navigationController!.popViewController(animated: false)
            }
        }
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if let videoAssetURL = localUrlOfOriginalVideo {
            startPlayingVideoWith(videoAssetURL)
            avVideoExporter = AVVideoExporter(url: videoAssetURL)
            videoLoaded =  true
            imageView.isHidden = true
            recordedVideoView.isHidden = false
        } else if let imageURL = localUrlOfOriginalImage {
            imageView.image = imageURL
            imageView.isHidden = false
            recordedVideoView.isHidden = true
        } else if videoLoaded == false {
            videoLoaded = self.startMediaBroswerFrom(viewController: self, using: self)
        }
        
        setupNavigationBar(theme: .light)
    }
    
    override func viewDidAppear(_ animated: Bool) {

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
        
        self.playVideo()
    }
    
    func playVideo(){
        
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: videoPlayer.currentItem)
        // seek back to zero and play
        videoPlayer.seek(to: kCMTimeZero)
        videoPlayer.play()
        NotificationCenter.default.addObserver(self, selector: #selector(self.playVideo), name: .AVPlayerItemDidPlayToEndTime, object: videoPlayer.currentItem)
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
            
        }) { _ in
            self.isHidden = !self.isHidden
        }
    }
    
    @IBAction func exportButtonPressed(_ sender: Any) {
        self.avVideoExporter?.output()
    }
}

