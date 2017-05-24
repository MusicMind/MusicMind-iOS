//
//  UserSettingsViewController.swift
//  MusicMind
//
//  Created by Adam Stafford on 23/05/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit
import Firebase

class UserSettingsViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    var localUrlOfprofilePhoto: URL?
    private var uploadTask: FIRStorageUploadTask?
    private var downloadURLString: String?
    private var user: User?
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var changePictureButton: UIButton!
    
    @IBAction func signOut(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()
            
            let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
            let welcomeViewController = storyboard.instantiateInitialViewController()
            
            UIApplication.shared.keyWindow?.rootViewController = welcomeViewController
        } catch {
            print(error.localizedDescription)
        }
    }
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
//        if image != nil {
//            profilePicture.image = image
//            profilePicture.contentMode = .scaleAspectFit
//            let imageUrl          = info[UIImagePickerControllerReferenceURL] as? NSURL
//            let imageName         = imageUrl?.lastPathComponent
//            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
//            let photoURL          = NSURL(fileURLWithPath: documentDirectory)
//            let localPath         = photoURL.appendingPathComponent(imageName!)
//        
//        if !FileManager.default.fileExists(atPath: localPath!.path) {
//            do {
//                attemptUpload(image!)
//                print("file saved")
//            }catch {
//                print("error saving file")
//            }
//        }
//        else {
//            print("file already exists")
//        }
//        localUrlOfprofilePhoto = localPath
//        
//        self.dismiss(animated: true, completion: nil);
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let email = FIRAuth.auth()?.currentUser?.email {
            infoLabel.text = "\nSigned in as \(email)\n\n\(prettyVersionNumber)"
        } else {
            infoLabel.text = "\(prettyVersionNumber)"
        }
        
        if let pict = FIRAuth.auth()?.currentUser?.photoURL {
            profilePicture.image = UIImage.init(named: pict.absoluteString)
        } else {
            profilePicture.image = UIImage.init(named: "cool-180.png")
        }
        
        profilePicture.isUserInteractionEnabled = true
        
        let userRef = FIRDatabase.database().reference().child("users/\(FIRAuth.auth()!.currentUser!.uid)")
        
        userRef.observe(.value) { (snapshot: FIRDataSnapshot) in
            self.user = User(withSnapshot: snapshot)
            
            if let dictionaryStringOfUser = self.user?.asDictionary.description {
                print(dictionaryStringOfUser)
            }
        }
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        setupNavigationBar(theme: .light)
    }
    
    func attemptUpload(_ image: NSData) {
        
        //  Store Current Date
        let currentDateTime = Date()
        let time = String(currentDateTime.timeIntervalSinceReferenceDate)
        
        //  Store Naming Convention
        let storageRef = FIRStorage.storage().reference(withPath: "users/\(FIRAuth.auth()!.currentUser!.uid)"+"/profilePhotos/"+time+".jpeg")
        let uploadMetadata = FIRStorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        
        if let localUrlOfprofilePhoto = localUrlOfprofilePhoto {
            uploadTask = storageRef.putFile(localUrlOfprofilePhoto, metadata: uploadMetadata) { (metadata, error) in
                if error == nil {
                    let downloadUrl = metadata?.downloadURL()
                    
                    if let downloadUrl = downloadUrl {
                        
                        self.downloadURLString = downloadUrl.absoluteString
                        
                        
                        // Create a post model and upload to firebase db
                        var post = ProfilePhoto()
                        guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
                        post.authorId = uid
                        post.dateTimeCreated = Date()
                        post.profilePhotoDownloadUrl = downloadUrl
                        
                        let postRef = FIRDatabase.database().reference().child("profilePhotos").childByAutoId()
                        
                        postRef.setValue(post.asDictionary, withCompletionBlock: { (error: Error?, ref: FIRDatabaseReference) in
                            if let error = error {
                                print(error.localizedDescription)
                            } else {
                                print("Successfully posted new profilePhoto to firebase")
                                
                                // We also need to create a userPosts lookup table
                                let userPostsRef = FIRDatabase.database().reference().child("profilePhotos/\(uid)")
                                
                                userPostsRef.updateChildValues([ref.key: true], withCompletionBlock: { (error: Error?, ref: FIRDatabaseReference) in
                                    if let error = error {
                                        print(error.localizedDescription)
                                    } else {
                                        print("pushed to profilePhotos")
                                    }
                                })
                            }
                        })
                        
                    }
                } else {
                    print("There was an error: \(error!.localizedDescription)")
                }
            }
            
            uploadTask?.observe(.progress) { [weak self] (snapshot) in
                guard self != nil else { return }
                
                guard snapshot.progress != nil else { return }
                
            }
        }
    }
    
    @IBAction func changePicture(_ sender: Any) {
        let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        if image != nil {
            profilePicture.image = image!
            profilePicture.contentMode = .scaleAspectFit
            
            let imageData = UIImageJPEGRepresentation(image!, 1.0) as NSData?
            attemptUpload(imageData!)
            
            picker.dismiss(animated: true, completion: nil)
        }
    }
    }

