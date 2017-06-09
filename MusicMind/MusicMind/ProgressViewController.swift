//
//  ProgressViewController.swift
//  MusicMind
//
//  Created by Adam Stafford on 8/06/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit
import Firebase

class ProgressViewController: UIViewController {
    @IBOutlet private weak var progressBar: UIProgressView!
    @IBOutlet private weak var text1: UILabel!
    @IBOutlet private weak var question: UILabel!
    @IBOutlet private weak var confirm: UIButton!
    @IBOutlet private weak var cancel: UIButton!
    public var localUrlOfprofilePhoto: URL?
    private var uploadTask: FIRStorageUploadTask?
    private var downloadURLString: String?
    private var user: User?
    public var imageData: NSData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar.isHidden = true
        text1.isHidden = true
        question.isHidden = false
        confirm.isHidden = false
        cancel.isHidden = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func begin() {
        progressBar.isHidden = false
        text1.isHidden = false
        question.isHidden = true
        confirm.isHidden = true
        cancel.isHidden = true
        attemptUpload(imageData)
    }
    
    @IBAction func close() {
        navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    func attemptUpload(_ image: NSData) {
        
        //  Store Current Date
        let currentDateTime = Date()
        let time = String(currentDateTime.timeIntervalSinceReferenceDate)
        //  Store Naming Convention
        var storageRef = FIRStorage.storage().reference(withPath: "profilePhotos/"+time+".jpg")
        if let uid1 = FIRAuth.auth()!.currentUser?.uid {
            storageRef = FIRStorage.storage().reference(withPath: "profilePhotos/"+uid1+time+".jpg")
        }
        let uploadMetadata = FIRStorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        if let localUrlOfprofilePhoto1 = localUrlOfprofilePhoto {
            uploadTask = storageRef.put(image as Data, metadata: uploadMetadata) { (metadata, error) in
                if error == nil {
                    let downloadUrl = metadata?.downloadURL()
                    
                    if let downloadUrl = downloadUrl {
                        
                        self.downloadURLString = downloadUrl.absoluteString
                        self.user?.profilePhoto = downloadUrl
                        
                        
                        // Create a post model and upload to firebase db
                        let photoUrl = self.downloadURLString
                        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
                        
                        let postRef = FIRDatabase.database().reference().child("profilePhotos/\(uid)")
                        postRef.setValue(photoUrl, withCompletionBlock: { (error: Error?, ref: FIRDatabaseReference) in
                            if let error = error {
                                print(error.localizedDescription)
                            } else {
                                print("Successfully posted new profilePhoto to firebase")
                                
                                // We also need to create a userPosts lookup table
                                let userPostsRef = FIRDatabase.database().reference().child("profilePhotos")
                                
                                userPostsRef.updateChildValues([uid: self.downloadURLString], withCompletionBlock: { (error: Error?, ref: FIRDatabaseReference) in
                                    if let error = error {
                                        print(error.localizedDescription)
                                    } else {
                                        print("pushed to profilePhotos")
                                    }
                                })
                            }
                        })
                        
                    } else {
                        print("There was an error: \(error!.localizedDescription)")
                    }
                    
                    print(downloadUrl?.absoluteString)
                    self.user?.profilePhoto = downloadUrl
                    print(FIRDatabase.database().reference().child("users/\(self.user?.id!)"))
                    
                } else {
                    print("There was an error: \(error!.localizedDescription)")
                }
            }
            
            uploadTask?.observe(.progress) { [weak self] (snapshot) in
                guard let strongSelf = self else { return }
                
                guard let progress = snapshot.progress else { return }
                
                strongSelf.progressBar.progress = Float(progress.fractionCompleted)
                if (progress.fractionCompleted == 1.0) {
                    self!.close()
                }
            }
        }
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
