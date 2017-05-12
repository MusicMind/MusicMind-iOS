//
//  FindFriendsViewController.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 5/12/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit
import Firebase

class FindFriendsViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        // Setups
        setupNavigationBar(theme: .light)
        hideKeyboardWhenTappedAround()
        
        // Set delegates
        searchBar.delegate = self
    }
    
}

extension FindFriendsViewController: UISearchBarDelegate {
    
}

// Add button statuses
// Add
// Checked
