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
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func searchForUserByName(withString: String) -> [User]? {
        
        var results: [User]?
        let usersRef = FIRDatabase.database().reference().child("users")
            
        usersRef.queryOrdered(byChild: "firstName")
            .queryStarting(atValue: withString)
            .queryEnding(atValue: withString+"\u{f8ff}")
            .observeSingleEvent(of: .value, with: { snapshot in
            let children = snapshot.children
            
            while let userSnapshot = children.nextObject() as? FIRDataSnapshot {
                let user = User(withSnapshot: userSnapshot)
                
                results?.append(user)
            }
        })
        
        
        return results
    }
    
}

extension FindFriendsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if !searchText.isEmpty {
            let searchResults = searchForUserByName(withString: searchText)
        }
        
        
        // display search results
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //
    }

}

extension FindFriendsViewController: UITableViewDelegate {
    
}

extension FindFriendsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        //  Statuses
        // Add
        // Checked
  
        return cell
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
}

