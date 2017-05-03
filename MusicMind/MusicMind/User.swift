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

        self.uuid = uuid
        self.firstName = nil
        self.lastName = nil
        self.mobileNumber = nil
        self.birthday = nil
    }
    
    var uuid: String?
    var firstName: String? {
        didSet {
            if let firstName = firstName, let currentUserRef = currentUserRef {
                currentUserRef.setValue(["firstName": firstName], withCompletionBlock: { (error, ref) in
                    //
                })
            }
        }
    }
    var lastName: String?
    var mobileNumber: String?
    var birthday: Date?
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy-MM-dd"
    
}
