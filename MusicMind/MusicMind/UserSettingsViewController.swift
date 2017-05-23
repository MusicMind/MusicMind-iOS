//
//  UserSettingsViewController.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 4/26/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit
import Firebase

class UserSettingsViewController: UITableViewController {
   
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let email = FIRAuth.auth()?.currentUser?.email {
            infoLabel.text = "\nSigned in as \(email)\n\n\(prettyVersionNumber)"
        } else {
            infoLabel.text = "\(prettyVersionNumber)"
        }
        
        if let pict = FIRAuth.auth()?.currentUser?.photoURL {
            profilePicture.image = UIImage.init(pict)
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
    func singleTouch(recognizer: UIGestureRecognizer) {
        print("image clicked")
    }
}
