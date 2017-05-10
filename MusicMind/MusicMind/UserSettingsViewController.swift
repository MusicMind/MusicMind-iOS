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
   
    @IBOutlet weak var infoLabel: UILabel!
    
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
        
        
        // lets see what happens when I init with snapshot
        
        let userRef = FIRDatabase.database().reference().child("users/\(FIRAuth.auth()!.currentUser!.uid)")
        
        userRef.observe(.value) { (snapshot: FIRDataSnapshot) in
            let user = User(withSnapshot: snapshot)
            
            print(user.asDictionary)
        }
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        setupNavigationBar(theme: .light)
    }
}
