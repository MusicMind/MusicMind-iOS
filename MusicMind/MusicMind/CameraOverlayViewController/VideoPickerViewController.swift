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
        var videoAssetOrientation_ = UIImageOrientation.up
        var isVideoAssetPortrait_ = false
        let videoTransform =  videoAssetTrack.preferredTransform
        
        if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
            videoAssetOrientation_ = .right;
            isVideoAssetPortrait_ = true;
        }
        if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
            videoAssetOrientation_ =  .left;
            isVideoAssetPortrait_ = true;
        }
        if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
            videoAssetOrientation_ =  .up;
        }
        if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
            videoAssetOrientation_ = .down;
        }
        
        // add instructions
        mainInstructions.layerInstructions = [videoLayerInstruction]
        
        let mainCompositionInst = AVMutableComposition()
    }
}
