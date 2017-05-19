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
    var cellsByUser = [String: FindFriendsTableViewCell]()
    var searchResults = [User]() {
        didSet {
            cellsByUser.removeAll()
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        setupNavigationBar(theme: .light)
        hideKeyboardWhenTappedAround()
        
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        // Create a Firebase observer on the userFriends table which will continuously update the TableViewCells when a user is added or removed from the list
        if let currentUserId = FIRAuth.auth()?.currentUser?.uid {
            let usersFriendsRef = FIRDatabase.database().reference().child("userFriends/\(currentUserId)")

            usersFriendsRef.observe(.value, with: { (snapshot: FIRDataSnapshot) in
                if let friends = snapshot.value as? [String: Bool] {
                    for (cellUserId, cell) in self.cellsByUser {
                        for (friendId, _) in friends {
                            if cellUserId == friendId {
                                cell.addButton.titleLabel?.text = "AAA"
                            } else {
                                cell.addButton.titleLabel?.text = "BBB"
                            }
                        }
                    }
                }
            })
            
        }
    }
    
    fileprivate func searchForUserByName(withString: String) {
        func userIdsForAllUsersWithNamesMatching(searchString: String, completionHandler: @escaping (_ ids: [String]) -> ())  {
            let searchableNamesRef = FIRDatabase.database().reference().child("searchableNames")
            
            searchableNamesRef.queryOrderedByKey()
                .queryStarting(atValue: searchString.lowercased())
                .queryEnding(atValue: searchString.lowercased()+"\u{f8ff}")
                .observeSingleEvent(of: .value, with: { snapshot in
                    let children = snapshot.children
                    var results = [String]()
                    
                    while let child = children.nextObject() as? FIRDataSnapshot {
                        if let id = child.value as? String {
                            results.append(id)
                        }
                    }
                    
                    completionHandler(results)
                })
        }
        
        userIdsForAllUsersWithNamesMatching(searchString: withString) { (userIdsToFetch: [String]) in
            self.searchResults = []
            
            for id in userIdsToFetch {
                let userRef = FIRDatabase.database().reference().child("users/\(id)")
                
                userRef.observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
                    let user = User(withSnapshot: snapshot)
                    
                    self.searchResults.append(user)
                })
            }
        }
    }
    
}

extension FindFriendsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchResults = []
        } else {
            searchForUserByName(withString: searchText)
        }
    }

}

extension FindFriendsViewController: AddButtonDelegate {
    func addButtonTapped(at indexPath: IndexPath) {
//        guard let currentUserId = FIRAuth.auth()?.currentUser?.uid else { return }
//        guard let friendId = searchResults[indexPath.row].id else { return }
//        guard let cell = tableView.cellForRow(at: indexPath) as? FindFriendsTableViewCell else { return }
//        
//        let userFriendsRef = FIRDatabase.database().reference().child("userFriends/\(currentUserId)")
//        
//        var result = searchResults[indexPath.row]
//        
//        // Either add or remove friend from db list
//        
//        searchResults[indexPath.row] = result
    }
}

extension FindFriendsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as! FindFriendsTableViewCell
        let user = searchResults[indexPath.row]
        var fullName = ""
        
        // Assemble a Dictionary of user id Strings with references to their respective TableViewCells
        if let id = user.id {
            cellsByUser[id] = cell
        }
        
        if let firstName = user.firstName { fullName = firstName }
        if let lastName = user.lastName { fullName.append(" \(lastName)") }
        
        if let profilePhotoUrl = user.profilePhoto {
            URLSession.shared.dataTask(with: profilePhotoUrl) { (data: Data?, response: URLResponse?, error: Error?) in
                if let data = data {
                    let image = UIImage(data: data)
                    
                    DispatchQueue.main.async {
                        cell.profileImage.image = image
                    }
                }
            }.resume()
        } else {
            cell.profileImage.image = nil
        }
        
        cell.indexPath = indexPath
        cell.delegate = self
        cell.nameLabel.text = fullName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(75)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
}

