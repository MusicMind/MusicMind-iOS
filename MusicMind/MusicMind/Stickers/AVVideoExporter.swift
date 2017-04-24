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
    
    var composition: AVMutableComposition = AVMutableComposition()
    
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
            self.present(alertController, animated: true, completion: nil)
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
    
}
