//
//  VideoPickerViewController.swift
//  MusicMind
//
//  Created by Angel Contreras on 3/18/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import Photos

class VideoPickerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    var videoAsset: AVAsset?
    
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
        
        // handle video selection
        self.videoAsset = AVAsset(url: info[UIImagePickerControllerMediaURL] as! URL)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func applyVideoEffectsTo(composition: AVMutableVideoComposition, size: CGSize){
        
    }
    
    func videoOutput(){
        // early exit if there is no video file selected
        guard let videoAsset = self.videoAsset else  {
            let alert = UIAlertView(title: "Error", message: "Please choose a video", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            return
        }
        
        // create avmutablecomposition object. This object will hold the AVMutableCompositionTack instance
        let mixComposition = AVMutableComposition()
        
        //video track
        let videoTrack = mixComposition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        do{
            try videoTrack.insertTimeRange((CMTimeRangeMake(kCMTimeZero, videoAsset.duration)), of: (videoAsset.tracks(withMediaType: AVMediaTypeVideo).first)!, at: kCMTimeZero)
        } catch {
            print("error")
        }
        
        // create AVMutableVideoCompositionInstructions
        let mainInstructions = AVMutableVideoCompositionInstruction()
        mainInstructions.timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
        
        // create an AVMutableVideoCompostionLayerInstruction for the video track and fix the orientation
        let videoLayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
        let videoAssetTrack: AVAssetTrack = videoAsset.tracks(withMediaType: AVMediaTypeVideo).first!
        var videoAssetOrientation = UIImageOrientation.up
        var isVideoAssetPortrait = false
        let videoTransform =  videoAssetTrack.preferredTransform
        
        if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
            videoAssetOrientation = .right;
            isVideoAssetPortrait = true;
        }
        if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
            videoAssetOrientation =  .left;
            isVideoAssetPortrait = true;
        }
        if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
            videoAssetOrientation =  .up;
        }
        if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
            videoAssetOrientation = .down;
        }
        
        // add instructions
        mainInstructions.layerInstructions = [videoLayerInstruction]
        
        let mainCompositionInst = AVMutableVideoComposition()
        
        var naturalSize = CGSize()
        if (isVideoAssetPortrait){
            naturalSize = CGSize(width: videoAssetTrack.naturalSize.height, height: videoAssetTrack.naturalSize.width)
        } else {
            naturalSize = videoAssetTrack.naturalSize
        }
        
        var renderwidth: CGFloat!
        var renderHeight: CGFloat!
        renderwidth = naturalSize.width
        renderHeight = naturalSize.height
        mainCompositionInst.renderSize = CGSize(width: renderwidth, height: renderHeight)
        mainCompositionInst.instructions = [mainInstructions]
        mainCompositionInst.frameDuration = CMTimeMake(1, 30)
        
        self.applyVideoEffectsTo(composition: mainCompositionInst, size: naturalSize)
        
        // get path
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let url: URL?
        let documentsDirectory = paths.first
        let stringFormat = String(format: "%@%d%@", "MusicMindVideo-", arc4random() % 1000, ".mov")
        let myPathDocs = documentsDirectory?.appending(stringFormat)
        
        url = URL(fileURLWithPath: myPathDocs!)

        // create exporter
        let exporter = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)
        exporter?.outputURL = url
        exporter?.outputFileType = AVFileTypeQuickTimeMovie
        exporter?.shouldOptimizeForNetworkUse = true
        exporter?.videoComposition = mainCompositionInst
        exporter?.exportAsynchronously {
            DispatchQueue.main.async {
                self.exportDidFinish(exporter)
            }
        }
        
    }
    
    func exportDidFinish(_ session: AVAssetExportSession?){
        if session?.status == AVAssetExportSessionStatus.completed {
            let outputURL = session?.outputURL
            // must check for authorization status
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                    // saving the movie file to the photo library
                    PHPhotoLibrary.shared().performChanges({ 
                        let options = PHAssetResourceCreationOptions()
                        options.shouldMoveFile = true
                        let creationRequest = PHAssetCreationRequest.forAsset()
                        creationRequest.addResource(with: .video, fileURL: outputURL!, options: options)
                    }, completionHandler: { (success, error) in
                        DispatchQueue.main.async {
                            if !success {
                                let alertController = UIAlertController(title: "Video Failed", message: "Video Saving Failed", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                alertController.addAction(okAction)
                                self.present(alertController, animated: true, completion: nil)
                                
                            } else {
                                let alertController = UIAlertController(title: "Video Saved", message: "Saved To Photo Album", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                alertController.addAction(okAction)
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                    })
                }
            })
        }
        
        
    }
}
