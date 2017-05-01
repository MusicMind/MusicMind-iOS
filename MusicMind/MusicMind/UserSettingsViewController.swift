//
//  UserSettingsViewController.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 4/26/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit

class UserSettingsViewController: UITableViewController {
   
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBAction func signOut(_ sender: Any) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let email = userLoginCredentials.firebaseUserEmail?.lowercased() {
            infoLabel.text = "\nSigned in as \(email)\n\n\(prettyVersionNumber)"
        } else {
            infoLabel.text = "\(prettyVersionNumber)"
        }
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        setupNavigationBar(theme: .light)
    }
}
