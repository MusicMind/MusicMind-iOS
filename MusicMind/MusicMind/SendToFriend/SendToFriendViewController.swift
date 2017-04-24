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
    private var uploadTask: FIRStorageUploadTask?
    private var downloadURLString: String?
    @IBOutlet private weak var progressBar: UIProgressView!
    @IBOutlet private weak var copyToClipboardButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    private var remoteDownloadUrlOfVideo: URL? {
        didSet {
            if remoteDownloadUrlOfVideo != nil {
                copyToClipboardButton.isHidden = false
            } else {
                copyToClipboardButton.isHidden = true
            }
        }
    }
    
    
    // MARK: - IB Actions
    
    @IBAction func copyDownloadUrlToClipboard(_ sender: UIButton) {
        if let urlString = self.downloadURLString {
            UIPasteboard.general.string = urlString
            
            sender.titleLabel?.setTextWhileKeepingAttributes(string: "Copied!")
            
//            copyToClipboardButton.titleLabel?.text = "Copied!"
            
//            let timer = Timer.init(timeInterval: 1000, repeats: false, block: { _ in
//                self.dismiss(animated: true, completion: nil)
//            })
//            
//            timer.fire()
            
        }
    }
    
    @IBAction func done(_ sender: Any) {
        if let uploadTask = uploadTask {
            uploadTask.cancel()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        attemptUpload()
        
        copyToClipboardButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar(theme: .light)
    }
    
    
    // MARK: - Upload handling
    
    func attemptUpload() {
        self.progressBar.isHidden = false
        
        //  Store Current Date
        let currentDateTime = Date()
        let time = String(currentDateTime.timeIntervalSinceReferenceDate)
        
        //  Store Naming Convention
        let storageRef = FIRStorage.storage().reference(withPath: "videos/beta"+time+".mov")
        let uploadMetadata = FIRStorageMetadata()
        uploadMetadata.contentType = "video/quicktime"
        
        if let localUrlOfVideo = localUrlOfVideo {
            uploadTask = storageRef.putFile(localUrlOfVideo, metadata: uploadMetadata) { (metadata, error) in
                if error == nil {
                    let downloadUrl = metadata?.downloadURL()
                    
                    if let downloadUrl = downloadUrl {
                        self.remoteDownloadUrlOfVideo = downloadUrl
                        
                        self.downloadURLString = downloadUrl.absoluteString
                        
                        self.statusLabel.setTextWhileKeepingAttributes(string: "Upload complete!")
                    }
                } else {
                    print("There was an error: \(error!.localizedDescription)")
                }
            }
            
            uploadTask?.observe(.progress) { [weak self] (snapshot) in
                guard let strongSelf = self else { return }
                
                guard let progress = snapshot.progress else { return }
                
                strongSelf.progressBar.progress = Float(progress.fractionCompleted)
                
            }
        }
    }
}
