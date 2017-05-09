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
 
    var firebaseAuthUser: FIRUser?
    var id: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var mobileNumber: String?
    var birthday: Date?
    var profilePhoto: URL?
    
    init() {}
    
    init(withSnapshot snapshot: FIRDataSnapshot) {
        firebaseAuthUser = FIRAuth.auth()?.currentUser
        id = firebaseAuthUser?.uid
        
        // TODO: init the following properties from snapshot:
//        email = nil
//        firstName = nil
//        lastName = nil
//        mobileNumber = nil
//        birthday = nil
//        profilePhoto = nil
    }

}
