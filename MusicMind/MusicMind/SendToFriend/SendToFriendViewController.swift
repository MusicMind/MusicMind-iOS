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
    
    var urlOfVideo: URL?
    private var downloadURLString: String?
    @IBOutlet weak var textFieldForDownloadURL: UITextField!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var urlLabel: UILabel!
    
    @IBAction func activityButtonPressed(_ sender: Any) {
        
        if let urlOfVideo = urlOfVideo {
            let activityController = UIActivityViewController(activityItems: [urlOfVideo], applicationActivities: nil)
            
            present(activityController, animated: true, completion: nil)
        }

    }
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.progressBar.isHidden = true
        
        if let url = urlOfVideo {
            urlLabel.text = url.absoluteString
            print(url.absoluteString)
        }
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
        let uploadTask = storageRef.putFile(urlOfVideo!, metadata: uploadMetadata) { (metadata, error) in
            if error == nil {
                let downloadURL = metadata?.downloadURL()
                
                print(downloadURL!.absoluteString)
                
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
    
    @IBAction func selectFromLibrary(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeMovie as String]
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    
}

extension SendToFriendViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let mediaType: String = info[UIImagePickerControllerMediaType] as? String else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        if mediaType == (kUTTypeMovie as String) {
            if let movieURL = info[UIImagePickerControllerMediaURL] as? URL {
                urlOfVideo = movieURL
                attemptUpload(self)
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
