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
    
    var searchResults = [(user: User, isAlreadyFriend: Bool)]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        setupNavigationBar(theme: .light)
        hideKeyboardWhenTappedAround()
        
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func userIdsForAllUsersWithNamesMatching(searchString: String, completionHandler: @escaping (_ ids: [String]) -> ())  {
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
    
    fileprivate func searchForUserByName(withString: String) {
        userIdsForAllUsersWithNamesMatching(searchString: withString) { (userIdsToFetch: [String]) in
            self.searchResults = []
            
            for id in userIdsToFetch {
                let userRef = FIRDatabase.database().reference().child("users/\(id)")
                
                userRef.observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
                    let user = User(withSnapshot: snapshot)
                    
                    // Check if this user is already a friend
                    if let currentUserId = FIRAuth.auth()?.currentUser?.uid, let friendId = user.id {
                        let currentUsersFriendsRef = FIRDatabase.database().reference().child("userFriends/\(currentUserId)")
                        
                        currentUsersFriendsRef.observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in

                            if let x = snapshot.value as? [String: Bool] {
                                if x[friendId] == true {
                                    self.searchResults.append((user: user, isAlreadyFriend: true))
                                } else {
                                    self.searchResults.append((user: user, isAlreadyFriend: false))
                                }
                            }
                        })
                        
                    }
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
        guard let currentUserId = FIRAuth.auth()?.currentUser?.uid else { return }
        guard let friendId = searchResults[indexPath.row].user.id else { return }
        guard let cell = tableView.cellForRow(at: indexPath) as? FindFriendsTableViewCell else { return }
        
        let userFriendsRef = FIRDatabase.database().reference().child("userFriends/\(currentUserId)")
        
        var result = searchResults[indexPath.row]
        
        if result.isAlreadyFriend {
            userFriendsRef.child(friendId).removeValue(completionBlock: { (error: Error?, ref: FIRDatabaseReference) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    result.isAlreadyFriend = false
                }
            })
        } else {
            userFriendsRef.updateChildValues([friendId : true]) { (error: Error?, ref: FIRDatabaseReference) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    result.isAlreadyFriend = true
                }
            }
        }
        
        searchResults[indexPath.row] = result
    }
}

extension FindFriendsViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as! FindFriendsTableViewCell
        let user = searchResults[indexPath.row].user
        var fullName = ""
        
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
        
        if searchResults[indexPath.row].isAlreadyFriend {
            cell.addButton.titleLabel?.text = "Remove"
        } else {
            cell.addButton.titleLabel?.text = "Add"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(75)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
}

