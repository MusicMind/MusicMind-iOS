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
        
        let userRef = FIRDatabase.database().reference().child("users/\(FIRAuth.auth()!.currentUser!.uid)")
        
        userRef.observe(.value) { (snapshot: FIRDataSnapshot) in
            self.user = User(withSnapshot: snapshot)
            
            if let dictionaryStringOfUser = self.user?.asDictionary.description {
                print(dictionaryStringOfUser)
            }
        }
        let pict1 = FIRDatabase.database().reference().child("profilePhotos")
        pict1.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            do {
                print(snapshot)
                let value = snapshot.childSnapshot(forPath: FIRAuth.auth()!.currentUser!.uid).value as? String
                if (value == nil) {
                    throw NSError.init()
                }
                if (!((try? Data(contentsOf: NSURL(string:value!)! as URL)) != nil)) {
                    throw NSError.init()
                }
                let data = try? Data(contentsOf: NSURL(string:value!)! as URL)
                self.profilePicture.image = UIImage(data: data!)
                self.profilePicture.image = UIImage(data: data!)
                self.profilePicture.contentMode = .scaleAspectFit
            } catch {
                let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/musicmind-9723f.appspot.com/o/profilePhotos%2Fplaceholder.png?alt=media&token=cee07892-57f7-45d4-84ee-95c4fbf4cb2a")
                let data = try? Data(contentsOf: url!)
                self.profilePicture.image = UIImage(data: data!)
                self.profilePicture.contentMode = .scaleAspectFit
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
            let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/musicmind-9723f.appspot.com/o/profilePhotos%2Fplaceholder.png?alt=media&token=cee07892-57f7-45d4-84ee-95c4fbf4cb2a")
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            self.profilePicture.image = UIImage(data: data!)
            self.profilePicture.contentMode = .scaleAspectFit
        }
        /*if let pict = pict1 {
            profilePicture.image = UIImage.init(named: pict.absoluteString)
        } else {
            let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/musicmind-9723f.appspot.com/o/profilePhotos%2Fplaceholder.png?alt=media&token=cee07892-57f7-45d4-84ee-95c4fbf4cb2a")
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            profilePicture.image = UIImage(data: data!)
            profilePicture.contentMode = .scaleAspectFit
        }*/
        
        profilePicture.isUserInteractionEnabled = true
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        setupNavigationBar(theme: .light)
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
                guard self != nil else { return }
                
                guard snapshot.progress != nil else { return }
                
            }
        }
    }
    
    @IBAction func openPhotoTaker(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            present(imagePicker, animated: true, completion: nil)
    }

    @IBAction func changePicture(_ sender: Any) {
        let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        if image != nil {
            profilePicture.image = image!
            profilePicture.contentMode = .scaleAspectFit
            localUrlOfprofilePhoto = info[UIImagePickerControllerReferenceURL] as! URL
            
            let imageData = UIImageJPEGRepresentation(image!, 1.0) as NSData?
            attemptUpload(imageData!)
            
            picker.dismiss(animated: true, completion: nil)
        }
    }
    }

