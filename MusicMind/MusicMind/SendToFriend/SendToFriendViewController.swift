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

class SendToFriendViewController: UIViewController {
    
    var urlOfVideo: URL?

    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var urlLabel: UILabel!
    
    func attemptUpload(_ sender: Any) {
        self.progressBar.isHidden = false
        
        let storageRef = FIRStorage.storage().reference(withPath: "videos/test1.mov")
        
        let uploadMetadata = FIRStorageMetadata()
        
        uploadMetadata.contentType = "video/quicktime"
        
        let uploadTask = storageRef.putFile(urlOfVideo!, metadata: uploadMetadata) { (metadata, error) in
            if error == nil {
                print("Upload successful. Metadata: \(metadata)")
                
                let downloadURL = metadata?.downloadURL()
                
                print(downloadURL?.absoluteString)
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
    
    @IBAction func goBackToCamera(_ sender: Any) {
        // Show the camera view controller
        let cameraViewController = UIStoryboard(name: "Camera", bundle: nil).instantiateViewController(withIdentifier: "CameraViewController")
        self.present(cameraViewController, animated: true, completion: nil)
    }
    
    @IBAction func selectFromLibrary(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeMovie as String]
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.progressBar.isHidden = true

        if let url = urlOfVideo {
            urlLabel.text = url.absoluteString
            print(url.absoluteString)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
