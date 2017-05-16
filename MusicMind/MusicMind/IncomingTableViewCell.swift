//
//  IncomingTableViewCell.swift
//  MusicMind
//
//  Created by Alec Arshavsky on 5/7/17.
//  Copyright © 2017 Alec Arshavsky. All rights reserved.
//

import UIKit

class IncomingTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        messageView.layer.cornerRadius = 15;
    }

    
}
