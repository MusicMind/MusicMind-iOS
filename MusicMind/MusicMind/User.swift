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
                    
                    // First name
                    if let firstName = user["firstName"] as? String {
                        if firstName != self.firstName {
                            self.firstName = firstName
                        }
                    }
                    
                    // Last name
                    if let lastName = user["lastName"] as? String {
                        if lastName != self.lastName {
                            self.lastName = lastName
                        }
                    }
                    
                    // Mobile number
                    if let mobileNumber = user["mobileNumber"] as? String {
                        if mobileNumber != self.mobileNumber {
                            self.mobileNumber = mobileNumber
                        }
                    }
                    
                    // Email
                    if let email = user["email"] as? String {
                        if email != self.email {
                            self.email = email
                        }
                    }
                    
                    // Profile photo
                    if let profilePhotoUrlString = user["profilePhoto"] as? String {
                        let profilePhotoUrl = URL(string: profilePhotoUrlString)
                        
                        if let profilePhotoUrl = profilePhotoUrl {
                            if profilePhotoUrl != self.profilePhoto {
                                self.profilePhoto = profilePhotoUrl
                            }
                        }
                    }
                    
                    // Birthday
                    if let birthdayString = user["birthday"] as? String {
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
                        
                        let birthdayDate = formatter.date(from: birthdayString)
                        
                        if let birthdayDate = birthdayDate {
                            if birthdayDate != self.birthday {
                                self.birthday = birthdayDate
                            }
                        }
                    }
                }
            })
        }
    }
    var firebaseAuthUser: FIRUser?
    let id: String?
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
    private(set) var email: String?
    var profilePhoto: URL? {
        didSet {
            if let profilePhoto = profilePhoto, let userRef = userRef {
                userRef.setValue(["profilePhoto": profilePhoto.absoluteString])
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
        email = nil
        profilePhoto = nil
    }
    
    func pushNewUserToFirebaseDatabase(assosiatedWithAuthUser authUser: FIRUser) {
        if let id = id {
            userRef = FIRDatabase.database().reference().child("users\(id)")
        } else {
            userRef = FIRDatabase.database().reference().child("users").childByAutoId()
        }
        
        if let userRef = userRef {
            
            // Construct a dictionary out of all non-nil properties then send to firebase
            var dictionaryRepresentation: [String: String] = [:]
            
            // First name
            if let firstName = firstName {
                dictionaryRepresentation["firstName"] = firstName
            }
            
            // Last name
            if let lastName = lastName {
                dictionaryRepresentation["lastName"] = lastName
            }
            
            // Mobile number
            if let mobileNumber = mobileNumber {
                dictionaryRepresentation["mobileNumber"] = mobileNumber
            }
            
            // Email
            if let email = email {
                dictionaryRepresentation["email"] = email
            }
            
            // Profile photo
            if let profilePhoto = profilePhoto {
                dictionaryRepresentation["profilePhoto"] = profilePhoto.absoluteString
            }
            
            // Birthday
            if let birthday = birthday {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                
                let birthdayString = formatter.string(from: birthday)
                
                dictionaryRepresentation["birthday"] = birthdayString
            }

            userRef.setValue(dictionaryRepresentation) { (error, ref) in
                // completion code
            }   
        }
    }
    
    init(withAuthUser authUser: FIRUser) {
        userRef = FIRDatabase.database().reference().child("users/\(authUser.uid)")
        
        // TODO: fetch single and set all values for self from the snapshot
        
        id = authUser.uid
        firstName = nil
        lastName = nil
        mobileNumber = nil
        birthday = nil
        email = nil
        profilePhoto = nil
    }


}
