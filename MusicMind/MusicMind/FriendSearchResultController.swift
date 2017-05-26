//
//  FriendSearchResultController.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 5/15/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit

class FriendSearchResultController: UITableViewCell {
    
    var indexPath: IndexPath?
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func addFriend(_ sender: Any) {
       
    }
    
    //        // Create a Firebase observer on the userFriends table which will update the TableView cells when a user is added or removed from the list
    //        if let currentUserId = FIRAuth.auth()?.currentUser?.uid {
    //            let usersFriendsRef = FIRDatabase.database().reference().child("userFriends/\(currentUserId)")
    //
    //            usersFriendsRef.observe(.value, with: { (snapshot: FIRDataSnapshot) in
    //                if let friends = snapshot.value as? [String: Bool] {
    //                    for (cellUserId, cell) in self.cellsByUser {
    //                        for (friendId, _) in friends {
    //                            if cellUserId == friendId {
    //                                cell.addButton.titleLabel?.text = "AAA"
    //                            } else {
    //                                cell.addButton.titleLabel?.text = "BBB"
    //                            }
    //                        }
    //                    }
    //                }
    //            })
    //        }
    
    
}
