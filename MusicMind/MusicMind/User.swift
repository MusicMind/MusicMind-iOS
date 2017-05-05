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
    var userRef: FIRDatabaseReference? {
        didSet {
            // Create an observer for entire user listing in firebase that will update the values of this user instance when updates are made to firebase
            userRef?.observe(.value, with: { (snapshot) in
                if let user = snapshot.value as? [String: Any?] {
                    print(user.debugDescription)
                    
                    if let firstName = user["firstName"] as? String {
                        self.firstName = firstName
                    }
                    
                }
                
            })
        }
    }
    let id: String?
    var isAlreadyInFirebase: Bool = false
    var firstName: String? {
        didSet {
            if let firstName = firstName, let userRef = userRef {
                userRef.setValue(["firstName": firstName])
            }
        }
    }
    var lastName: String? {
        didSet {
            if let lastName = lastName, let userRef = userRef {
                userRef.setValue(["lastName": lastName])
            }
        }
    }
    var mobileNumber: String? {
        didSet {
            if let number = mobileNumber, let userRef = userRef {
                userRef.setValue(["mobileNumber": number])
            }
        }
    }
    var birthday: Date? {
        didSet {
            if let birthday = birthday, let userRef = userRef {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                
                let birthdayString = formatter.string(from: birthday)
                
                userRef.setValue(["birthday": birthdayString])
            }
        }
    }
    
    init() {
        userRef = nil
        id = nil
        firstName = nil
        lastName = nil
        mobileNumber = nil
        birthday = nil
    }
    
    init (withId: String) {
        userRef = FIRDatabase.database().reference().child("users/\(withId)")
        id = withId
        firstName = nil
        lastName = nil
        mobileNumber = nil
        birthday = nil
    }
    
    func pushNewUserToFirebase(withId: String) {
        let usersRef = FIRDatabase.database().reference().child("users")
        userRef = FIRDatabase.database().reference().child("users/\(withId)")

        
        if let userRef = userRef,
            let firstName = firstName,
            let lastName = lastName,
            let mobileNumber = mobileNumber,
            let birthday = birthday {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            
            let birthdayString = formatter.string(from: birthday)
            
            userRef.setValue(["firstName": firstName,
                              "lastName": lastName,
                              "mobileNumber": mobileNumber,
                              "birthday": birthdayString])
            
            isAlreadyInFirebase = true
        }
        
    }

}
