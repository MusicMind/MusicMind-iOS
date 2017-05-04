//
//  User.swift
//  MusicMind
//
//  Created by Angel Contreras on 4/3/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import Foundation
import Firebase

struct User {
    let currentUserRef: FIRDatabaseReference?
    let id: String?
    var firstName: String? {
        didSet {
            if let firstName = firstName, let currentUserRef = currentUserRef {
                currentUserRef.setValue(["firstName": firstName])
            }
        }
    }
    var lastName: String?
    var mobileNumber: String?
    var birthday: Date?
    
    init (newId: String) {
        currentUserRef = FIRDatabase.database().reference().child("users/\(newId)")
        id = newId
        firstName = nil
        lastName = nil
        mobileNumber = nil
        birthday = nil
    }
}
