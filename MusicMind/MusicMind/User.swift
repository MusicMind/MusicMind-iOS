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
    let userRef: FIRDatabaseReference?
    let id: String?
    var firstName: String? {
        didSet {
            if let firstName = firstName, let userRef = userRef {
                userRef.setValue(["firstName": firstName])
            }
        }
    }
    var lastName: String?
    var mobileNumber: String?
    var birthday: Date?
    
    init (newId: String) {
        userRef = FIRDatabase.database().reference().child("users/\(newId)")
        id = newId
        firstName = nil
        lastName = nil
        mobileNumber = nil
        birthday = nil
    }
}
