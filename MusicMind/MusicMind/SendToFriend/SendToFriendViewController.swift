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
    var remoteDownloadUrlOfVideo: URL? {
        didSet {
            if remoteDownloadUrlOfVideo != nil {
                copyToClipboardButton.isHidden = false
            } else {
                copyToClipboardButton.isHidden = true
            }
        }
    }
    
    
    private var downloadURLString: String?
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var copyToClipboardButton: UIButton!
    
    @IBAction func activityButtonPressed(_ sender: Any) {
        // creating activity
        let uploadActivity = UploadActivity()
        
        // creating activity view controller
        if let localUrlOfVideo = localUrlOfVideo {
            let activityController = UIActivityViewController(activityItems: [localUrlOfVideo], applicationActivities: [uploadActivity])
            
            present(activityController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        attemptUpload()
        
        copyToClipboardButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar(theme: .light)
    }
    
    @IBAction func copyDownloadUrlToClipboard(_ sender: Any) {
        if let urlString = self.downloadURLString {
            UIPasteboard.general.string = urlString
            
//            copyToClipboardButton.titleLabel?.text = "Copied!"
            
            let timer = Timer.init(timeInterval: 1000, repeats: false, block: { _ in
//                self.dismiss(animated: true, completion: nil)
            })
            
//            timer.fire()
            
        }
    }
    
    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func attemptUpload() {
        self.progressBar.isHidden = false
        
        //  Store Current Date
        let currentDateTime = Date()
        let time = String(currentDateTime.timeIntervalSinceReferenceDate)
        
        //  Store Naming Convention
        let storageRef = FIRStorage.storage().reference(withPath: "videos/test"+time+".mov")
        let uploadMetadata = FIRStorageMetadata()
        uploadMetadata.contentType = "video/quicktime"
        
        if let localUrlOfVideo = localUrlOfVideo {
            let uploadTask = storageRef.putFile(localUrlOfVideo, metadata: uploadMetadata) { (metadata, error) in
                if error == nil {
                    let downloadUrl = metadata?.downloadURL()
                    
                    if let downloadUrl = downloadUrl {
                        self.remoteDownloadUrlOfVideo = downloadUrl
                        
                        self.downloadURLString = downloadUrl.absoluteString
                    }
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
}
