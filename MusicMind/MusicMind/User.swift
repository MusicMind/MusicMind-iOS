//
//  User.swift
//  MusicMind
//
//  Created by Angel Contreras on 4/3/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import Foundation
import Firebase

// Create new user
// Init preexisting user
// Update user info

struct User {
    private let usersRef = FIRDatabase.database().reference(withPath: "users")
    
    init(firebaseUserWithUuid uuid: String) {
        let userRef = usersRef.child(uuid)
        
        self.uuid = uuid
        self.firstName = userRef.value(forKey: "firstName") as! String
        self.lastName = nil
        self.mobileNumber = nil
        self.birthday = nil
    }
    
//    func addUserToUserList(_ user: User) {
//        var userAsDictionary: [String: Any] = [:]
//        
//        for (key, value) in user.dictionaryRepresentation {
//            if let value = value {
//                userAsDictionary[key] = value
//            }
//        }
//        usersRef.child(uuid).updateChildValues(userAsDictionary)
//    }
//    
    var uuid: String?
    var firstName: String?
    var lastName: String?
    var mobileNumber: String?
    var birthday: Date?
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy-MM-dd"
    
}
