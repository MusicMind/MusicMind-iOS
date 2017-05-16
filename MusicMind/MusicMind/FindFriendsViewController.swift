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

////////////////////////////////////////
//        // TEMP TEST DATA:
//        let johnDoeRef = FIRDatabase.database().reference().child("users/VIyKDq9RzGgcRq9vZ50NnRW1nps2")
//        
//        johnDoeRef.observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
//            let user = User(withSnapshot: snapshot)
//            
//            self.results.append(user)
//            
//            self.tableView.reloadData()
//        }
///////////////////////////////////////
    }
    
    func searchForUserByName(withString: String) {
        let usersRef = FIRDatabase.database().reference().child("users")

        usersRef.queryOrdered(byChild: "firstName")
            .queryStarting(atValue: withString)
            .queryEnding(atValue: withString+"\u{f8ff}")
            .observeSingleEvent(of: .value, with: { snapshot in
            let children = snapshot.children
            
            while let userSnapshot = children.nextObject() as? FIRDataSnapshot {
                let user = User(withSnapshot: userSnapshot)
                
                self.results.append(user)
                self.tableView.reloadData()
            }
        })
    }
    
}

extension FindFriendsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
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
                print("There was an issue adding friend")
            } else {
                print("Friend added")
            }
        }
    }
}

extension FindFriendsViewController: UITableViewDelegate {
    
}

extension FindFriendsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell") as! FindFriendsTableViewCell
        
        let user = results[0]
        
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

