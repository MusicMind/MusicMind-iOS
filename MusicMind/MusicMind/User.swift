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
 
    var firebaseAuthUser: FIRUser? = nil
    var id: String? = nil
    var email: String? = nil
    var firstName: String? = nil
    var lastName: String? = nil
    var mobileNumber: String? = nil
    var birthday: Date? = nil
    var profilePhoto: URL? = nil
    
    init(withSnapshot snapshot: FIRDataSnapshot) {
        firebaseAuthUser = FIRAuth.auth()?.currentUser
        id = firebaseAuthUser?.uid
        
        // TODO: init the following properties from snapshot:
        email = nil
        firstName = nil
        lastName = nil
        mobileNumber = nil
        birthday = nil
        profilePhoto = nil
    }

}
