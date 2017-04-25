//
//  AVVideoExporter.swift
//  MusicMind
//
//  Created by Angel Contreras on 4/24/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import Foundation
import AVFoundation
import Photos
import UIKit

class AVVideoExporter{
    
    var videoAsset: AVAsset?
    
    var composition: AVMutableComposition = AVMutableComposition()
    
    var imageViews: [UIImageView] = []
    
    weak var viewController: UIViewController?
    
    convenience init(url: URL){
        let videoAsset = AVAsset(url: url)
        self.init(videoAsset: videoAsset)
    }
    
    init(videoAsset: AVAsset){
        self.videoAsset = videoAsset
    }
    
    func output(){
        guard let videoAsset = self.videoAsset else  {
            let alertController = UIAlertController(title: "Error", message: "Please choose a video", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            self.viewController?.present(alertController, animated: true, completion: nil)
            return
        }
        
        let track = videoAsset.tracks(withMediaType: AVMediaTypeVideo)
        let videoTrack: AVAssetTrack = track[0] as AVAssetTrack
        let timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
        
        let compositionVideoTrack: AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaTypeVideo, preferredTrackID: CMPersistentTrackID())
        
        do {
            try compositionVideoTrack.insertTimeRange(timeRange, of: videoTrack, at: kCMTimeZero)
            compositionVideoTrack.preferredTransform = videoTrack.preferredTransform // new
        } catch {
            print(error)
        }
        
        let compositionAudioTrack: AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaTypeAudio, preferredTrackID: CMPersistentTrackID())
        for audioTrack in videoAsset.tracks(withMediaType: AVMediaTypeAudio){
            do {
                try compositionAudioTrack.insertTimeRange(audioTrack.timeRange, of: audioTrack, at: kCMTimeZero)
            } catch {
                print(error)
            }
        }
        
        let size = videoTrack.naturalSize
        
        let layerComposition = AVMutableVideoComposition()
        layerComposition.frameDuration = CMTimeMake(1, 30)
        layerComposition.renderSize = size
        
        let instructions = AVMutableVideoCompositionInstruction()
        instructions.timeRange = CMTimeRangeMake(kCMTimeZero, composition.duration)
        let videoTrackFromCompostion = composition.tracks(withMediaType: AVMediaTypeVideo)[0] as AVAssetTrack
        
        let layerInstructions = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrackFromCompostion)
        instructions.layerInstructions = [layerInstructions]
        layerComposition.instructions = [instructions]
        
        compositionVideoTrack.preferredTransform = videoTrack.preferredTransform
        
        self.applyLayersToVideo(composition: layerComposition, size: size)
        
        // get path
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let url: URL?
        let documentsDirectory = paths.first
        let stringFormat = String(format: "/%@%d%@", "MusicMindVideo-", arc4random() % 1000, ".mov")
        print(stringFormat)
        let myPathDocs = documentsDirectory?.appending(stringFormat)
        print("My pathDocs: \(myPathDocs!)")
        url = URL(fileURLWithPath: myPathDocs!)
        
        guard let assetExport = AVAssetExportSession(asset: composition, presetName:AVAssetExportPresetHighestQuality) else {return}
        assetExport.videoComposition = layerComposition
        assetExport.outputFileType = AVFileTypeMPEG4
        assetExport.outputURL = url
        assetExport.exportAsynchronously(completionHandler: {
            self.exportDidFinish(assetExport)
        })
        
    }
    
    private func exportDidFinish(_ session: AVAssetExportSession?){
        print(session?.status == AVAssetExportSessionStatus.completed)
        //        if session?.status == AVAssetExportSessionStatus.completed {
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
                            self.viewController?.present(alertController, animated: true, completion: nil)
                            
                        } else {
                            let alertController = UIAlertController(title: "Video Saved", message: "Saved To Photo Album", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(okAction)
                            self.viewController?.present(alertController, animated: true, completion: nil)
                        }
                    }
                })
            }
        })
    }
    
    private func applyLayersToVideo(composition: AVMutableVideoComposition, size: CGSize) {
        let parentLayer = CALayer()
        let videoLayer = CALayer()
        parentLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        videoLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        print(parentLayer.frame)
        
        
        parentLayer.addSublayer(videoLayer)
        imageViews.forEach { (imageView) in
            let stickerLayer = CALayer()
            stickerLayer.contents = imageView.image?.cgImage
            stickerLayer.frame = CGRect(origin: imageView.frame.origin, size: CGSize(width: 110, height: 110))
            stickerLayer.masksToBounds = true
            parentLayer.addSublayer(stickerLayer)
        }
        
        composition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: parentLayer)
    }
    
    private func layerInstructionsAfterFixingOrientationFor(asset: AVAsset,for track: AVMutableCompositionTrack, atTime: CMTime) -> AVMutableVideoCompositionLayerInstruction {
        var layerInstructions = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
        var videoAssetTrack = asset.tracks(withMediaType: AVMediaTypeVideo)[0]
        var videoAssetOrientation = UIImageOrientation.up
        var isVideoAssetPortrait = false
        var videoTransform = videoAssetTrack.preferredTransform
        
        if(videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0)  {
            videoAssetOrientation = .right
            isVideoAssetPortrait = true
        }
        if(videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0){
            videoAssetOrientation =  .left
            isVideoAssetPortrait = true
        }
        if(videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0){
            videoAssetOrientation =  .up
        }
        if(videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
            videoAssetOrientation = .down
        }
        
        var firstAssetScaleToFitRatio = 320.0 / videoAssetTrack.naturalSize.width
        
        if isVideoAssetPortrait {
            firstAssetScaleToFitRatio = 320.0 / videoAssetTrack.naturalSize.height
            var firstAssetScaleFactor = CGAffineTransform(scaleX: firstAssetScaleToFitRatio, y: firstAssetScaleToFitRatio)
            
            layerInstructions.setTransform(videoAssetTrack.preferredTransform.concatenating(firstAssetScaleFactor), at: kCMTimeZero)
        } else {
            var firstAssetScalreFactor = CGAffineTransform(scaleX: firstAssetScaleToFitRatio, y: firstAssetScaleToFitRatio)
            layerInstructions.setTransform(videoAssetTrack.preferredTransform.concatenating(firstAssetScalreFactor), at: <#T##CMTime#>)
        }
        
        return layerInstructions
    }
}
