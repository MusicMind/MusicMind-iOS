//
//  SendToFriendViewController.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 3/17/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices

final class SendToFriendViewController: UIViewController {
    
    var localUrlOfVideo: URL?
    var remoteDownloadUrlOfVideo: URL?
    private var downloadURLString: String?
    @IBOutlet weak var textFieldForDownloadURL: UITextField!
    @IBOutlet weak var progressBar: UIProgressView!
    
    @IBAction func activityButtonPressed(_ sender: Any) {
        
        if let localUrlOfVideo = localUrlOfVideo {
            let activityController = UIActivityViewController(activityItems: [localUrlOfVideo], applicationActivities: nil)
            
            present(activityController, animated: true, completion: nil)
        }
//        if let remoteDownloadUrlOfVideo = remoteDownloadUrlOfVideo {
//            let activityController = UIActivityViewController(activityItems: [remoteDownloadUrlOfVideo], applicationActivities: nil)
//            
//            present(activityController, animated: true, completion: nil)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar(theme: .light)
    }
    
    @IBAction func copyDownloadUrlToClipboard(_ sender: Any) {
        if let urlString = self.downloadURLString {
            UIPasteboard.general.string = urlString
        }
    }
    
    @IBAction func attemptUpload(_ sender: Any) {
        self.progressBar.isHidden = false
        
        //  Store Current Date
        let currentDateTime = Date()
        let time = String(currentDateTime.timeIntervalSinceReferenceDate)
        
        //  Store Naming Convention
        let storageRef = FIRStorage.storage().reference(withPath: "videos/test"+time+".mov")
        let uploadMetadata = FIRStorageMetadata()
        uploadMetadata.contentType = "video/quicktime"
        
        //  Store URL
        let uploadTask = storageRef.putFile(localUrlOfVideo!, metadata: uploadMetadata) { (metadata, error) in
            if error == nil {
                let downloadURL = metadata?.downloadURL()
                
                print(downloadURL!.absoluteString)
                
                self.remoteDownloadUrlOfVideo = downloadURL
                
                self.textFieldForDownloadURL.text = downloadURL!.absoluteString
                
                self.downloadURLString = downloadURL!.absoluteString
                
            } else {
                print("There was an error: \(error!.localizedDescription)")
            }
        }
        
        uploadTask.observe(.progress) { [weak self] (snapshot) in
            guard let strongSelf = self else { return }
            
            guard let progress = snapshot.progress else { return }
            
            strongSelf.progressBar.progress = Float(progress.fractionCompleted)
            
        }
    }
}
