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
 
    let firebaseAuthUser: FIRUser?
    let id: String?
    let email: String?
    let firstName: String?
    let lastName: String?
    let mobileNumber: String?
    let birthday: Date?
    let profilePhoto: URL?
    
    init(withSnapshot snapshot: FIRDataSnapshot) {
        firebaseAuthUser = FIRAuth.auth()?.currentUser
        id = firebaseAuthUser?.uid
        email = nil
        firstName = nil
        lastName = nil
        mobileNumber = nil
        birthday = nil
        profilePhoto = nil
    }

}
