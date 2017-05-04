//
//  UserProfilePictureViewController.swift
//  MusicMind
//
//  Created by david samuel on 5/2/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit

class UserProfilePhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBAction func openPhotoTaker(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        
        imagePicker.sourceType = .camera
        
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        if image != nil {
        photoImageView.image = image!
        }
    }
    @IBOutlet weak var didTakePhoto: UIImageView!
    // MARK: Properties
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBAction func showImagePicker(_ sender: Any) {
        let imagePickerVC = UIImagePickerController()
        present(imagePickerVC, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}



