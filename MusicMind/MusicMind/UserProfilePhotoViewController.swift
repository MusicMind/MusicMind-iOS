//
//  UserProfilePictureViewController.swift
//  MusicMind
//
//  Created by david samuel on 5/2/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit

class ProfilePhotoViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBAction func showImagePicker(_ sender: Any) {
        let imagePickerVC = UIImagePickerController()
        present(imagePickerVC, animated: true, completion: nil)
        
        func isSourceTypeAvailable(_ sourceType: UIImagePickerControllerSourceType) -> Bool{
            
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}



