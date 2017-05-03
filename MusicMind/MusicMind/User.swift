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
    private let currentUserRef: FIRDatabaseReference?

    
    init(firebaseUserWithUuid uuid: String, completionHandler: @escaping () -> ()) {
        
        currentUserRef = FIRDatabase.database().reference().child("users/\(uuid)")
        
        currentUserRef?.setValue(["firstName": "test"], withCompletionBlock: { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("success")
                completionHandler()
            }
        })
        
        
//        self.ref.child("users").child(uuid).setValue(["firstName": "testname"])
//        self.ref.childByAutoId().setValue(["test":"test"])

//        self.currentUser = users.child(uuid).setValue(uuid)
        self.uuid = uuid
        self.firstName = nil
        self.lastName = nil
        self.mobileNumber = nil
        self.birthday = nil
    }
    
//    init(newUserWithFirstName firstName: String?, lastName: String?) {
//        self.init(firebaseUserWithUuid: "abc")
//        
//        self.firstName = firstName
//        self.lastName = lastName
//        self.birthday = nil
//        self.mobileNumber = nil
//    }
    
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
//    {
//        didSet {
//            if let uuid = uuid, let firstName = firstName, let currentUser = currentUser {
//                currentUser.child("\(uuid)/firstName").setValue(firstName)
//            }
//        }
//    }
    var lastName: String?
    var mobileNumber: String?
    var birthday: Date?
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy-MM-dd"
    
}
