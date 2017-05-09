//
//  User.swift
//  MusicMind
//
//  Created by Angel Contreras on 4/3/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import Foundation
import Firebase

class User {
    var firebaseAuthUser: FIRUser? = nil
    var id: String? = nil
    private(set) var email: String? = nil
    var firstName: String? = nil
    var lastName: String? = nil
    var mobileNumber: String? = nil
    var birthday: Date? = nil
    var profilePhoto: URL? = nil
    
    convenience init(withSnapshot snapshot: FIRDataSnapshot) {
        self.init()
    }

}
