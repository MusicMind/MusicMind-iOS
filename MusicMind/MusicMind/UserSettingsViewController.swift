//
//  UserSettingsViewController.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 4/26/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit

class UserSettingsViewController: UITableViewController {
   
    @IBAction func signOut(_ sender: Any) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        setupNavigationBar(theme: .light)
    }
}
