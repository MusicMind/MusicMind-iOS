//
//  FindFriendTableViewCell.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 5/15/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit

class FindFriendsTableViewCell: UITableViewCell {
    
    var indexPath: IndexPath?
    var delegate: AddButtonDelegate?
    var alreadyAdded: Bool = false {
        didSet {
            if alreadyAdded {
                addButton.titleLabel?.text = "Remove"
            } else {
                addButton.titleLabel?.text = "Add"
            }
        }
    }
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func addFriend(_ sender: Any) {
        guard let delegate = delegate else {
            return
        }
        guard let indexPath = indexPath else {
            return
        }
        
        delegate.addButtonTapped(at: indexPath)
    }
    
}
