//
//  UserProfilePictureViewController.swift
//  MusicMind
//
//  Created by david samuel on 5/2/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit

class ProfilePhotoViewController: UIViewController {
    @IBAction func showImagePicker(_ sender: Any) {
        let imagePickerVC = UIImagePickerController()
        present(imagePickerVC, animated: true, completion: nil)
    }

}



