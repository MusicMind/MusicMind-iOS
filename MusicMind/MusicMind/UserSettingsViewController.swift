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
    var imageData: NSData!
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
                self.profilePicture.clipsToBounds = true
            } catch {
                let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/musicmind-9723f.appspot.com/o/profilePhotos%2Fplaceholder.png?alt=media&token=cee07892-57f7-45d4-84ee-95c4fbf4cb2a")
                let data = try? Data(contentsOf: url!)
                self.profilePicture.image = UIImage(data: data!)
                self.profilePicture.contentMode = .scaleAspectFit
                self.profilePicture.clipsToBounds = true
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
            let url = URL(string: "https://firebasestorage.googleapis.com/v0/b/musicmind-9723f.appspot.com/o/profilePhotos%2Fplaceholder.png?alt=media&token=cee07892-57f7-45d4-84ee-95c4fbf4cb2a")
            let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            self.profilePicture.image = UIImage(data: data!)
            self.profilePicture.contentMode = .scaleAspectFit
            self.profilePicture.clipsToBounds = true
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
        
        var image = info[UIImagePickerControllerOriginalImage] as? UIImage
        if image != nil {
            profilePicture.image = image!
            profilePicture.contentMode = .scaleAspectFit
            profilePicture.clipsToBounds = true
            //image = image?.resize(width: 50)
            if let data = UIImagePNGRepresentation(image!) {
                let filename = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(String(Date().timeIntervalSinceReferenceDate)+(FIRAuth.auth()?.currentUser?.uid)!+".jpg")
                try? data.write(to: NSURL(string: filename)! as URL)
                localUrlOfprofilePhoto = NSURL(string: filename)! as URL
            }
            self.imageData = UIImageJPEGRepresentation(image!, 1.0) as NSData!
            picker.dismiss(animated: true, completion: nil)
            performSegue(withIdentifier: "upload", sender: self)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! ProgressViewController
        dest.localUrlOfprofilePhoto = localUrlOfprofilePhoto
        dest.imageData = self.imageData
    }
}
