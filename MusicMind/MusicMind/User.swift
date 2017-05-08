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
    var userRef: FIRDatabaseReference? = nil
    var firebaseAuthUser: FIRUser? = nil
    var id: String? = nil
    private(set) var email: String? = nil
    private var observerHandle: UInt? = nil
    var firstName: String? = nil {
        didSet {
            if let userRef = userRef {
                if let firstName = firstName {
                    userRef.setValue(["firstName": firstName])
                } else {
                    // remove value from firebase
                }
                
                userRef.child("firstName").observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
                    // set self with new value
                    
                    if let name = snapshot.value as? String {
                        print(name)
                    }
                    
                    // First name
//                    if let firstName = user["firstName"] as? String {
//                        if firstName != self.firstName {
//                            self.firstName = firstName
//                        }
//                    }
                    
                    print(snapshot.value as? [String: Any])
                })
                
            }
        }
    }
    var lastName: String? = nil {
        didSet {
            if let lastName = lastName, let userRef = userRef {
                userRef.setValue(["lastName": lastName])
            }
        }
    }
    var mobileNumber: String? = nil {
        didSet {
            if let number = mobileNumber, let userRef = userRef {
                userRef.setValue(["mobileNumber": number])
            }
        }
    }
    var birthday: Date? = nil {
        didSet {
            if let birthday = birthday, let userRef = userRef {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                
                let birthdayString = formatter.string(from: birthday)
                
                userRef.setValue(["birthday": birthdayString])
            }
        }
    }
    var profilePhoto: URL? = nil {
        didSet {
            if let profilePhoto = profilePhoto, let userRef = userRef {
                userRef.setValue(["profilePhoto": profilePhoto.absoluteString])
            }
        }
    }
    
    func pushNewUserToFirebaseDatabase(assosiatedWithAuthUser authUser: FIRUser) {
        if let id = id {
            userRef = FIRDatabase.database().reference().child("users\(id)")
        } else {
            userRef = FIRDatabase.database().reference().child("users").childByAutoId()
        }
        
        if let userRef = userRef {
            // Construct a dictionary out of all non-nil properties and send to firebase
            var dictionaryRepresentation: [String: String] = [:]
            
            if let firstName    = firstName { dictionaryRepresentation["firstName"] = firstName }
            if let lastName     = lastName { dictionaryRepresentation["lastName"] = lastName }
            if let mobileNumber = mobileNumber { dictionaryRepresentation["mobileNumber"] = mobileNumber }
            if let email        = email { dictionaryRepresentation["email"] = email }
            if let profilePhoto = profilePhoto { dictionaryRepresentation["profilePhoto"] = profilePhoto.absoluteString }
            if let birthday     = birthday {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let birthdayString = formatter.string(from: birthday)
                dictionaryRepresentation["birthday"] = birthdayString
            }

            userRef.setValue(dictionaryRepresentation) { (error, ref) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    convenience init(withAuthUser authUser: FIRUser) {
        self.init()
        
        userRef = FIRDatabase.database().reference().child("users/\(authUser.uid)")
        
        id = authUser.uid
        firstName = nil
        lastName = nil
        mobileNumber = nil
        birthday = nil
        email = nil
        profilePhoto = nil
    }

}
