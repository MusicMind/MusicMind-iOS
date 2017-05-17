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
    
    var results = [User]()
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
    
    func userIdsForAllUsersWithNamesMatching(searchString: String, completionHandler: @escaping (_ ids: [String]) -> ())  {
        let searchableNamesRef = FIRDatabase.database().reference().child("searchableNames")
        
        searchableNamesRef.queryOrderedByKey()
            .queryStarting(atValue: searchString.lowercased())
            .queryEnding(atValue: searchString.lowercased()+"\u{f8ff}")
            .observeSingleEvent(of: .value, with: { snapshot in
                let children = snapshot.children
                var searchResults = [String]()
                
                while let child = children.nextObject() as? FIRDataSnapshot {
                    if let id = child.value as? String {
                        searchResults.append(id)
                    }
                }
                
                completionHandler(searchResults)
        })
    }
    
    func searchForUserByName(withString: String) {
        userIdsForAllUsersWithNamesMatching(searchString: withString) { (userIdsToFetch: [String]) in
            self.results = []
            
            for id in userIdsToFetch {
                let userRef = FIRDatabase.database().reference().child("users/\(id)")
                
                userRef.observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
                    let user = User(withSnapshot: snapshot)
                    
                    self.results.append(user)
                    self.tableView.reloadData()
                })
            }
        }
    }
    
}

extension FindFriendsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            results = []
            tableView.reloadData()
        } else {
            searchForUserByName(withString: searchText)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // TODO: search
    }

}

extension FindFriendsViewController: AddButtonDelegate {
    func addButtonTapped(at index: Int) {
        
        guard let currentUserId = FIRAuth.auth()?.currentUser?.uid else { return }
        guard let friendId = results[index].id else { return }
        
        let userFriendsRef = FIRDatabase.database().reference().child("userFriends/\(currentUserId)")
        
        userFriendsRef.updateChildValues([friendId : true]) { (error: Error?, ref: FIRDatabaseReference) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Friend added")
            }
        }
    }
}

extension FindFriendsViewController: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            print("delete")
//        }
//    }
    
}

extension FindFriendsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as! FindFriendsTableViewCell
        
        let user = results[indexPath.row]
        
        var name = "No name"

        if let firstName = user.firstName {
            name = firstName
        }
        
        if let lastName = user.lastName {
            name.append(" \(lastName)")
        }
        
        cell.nameLabel.text = name
        
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
        
        cell.index = indexPath.row
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(65)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
}

