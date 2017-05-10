//
//  User.swift
//  MusicMind
//
//  Created by Angel Contreras on 4/3/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import Foundation
import Firebase

struct User: FirebaseConvertable {
 
    var firebaseAuthUser: FIRUser?
    var id: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var mobileNumber: String?
    var birthday: Date?
    var profilePhoto: URL?
    var dateCreated: Date?
    private let dateFormatter = DateFormatter()
    var asDictionary: [String: Any] {
        var dict: [String: Any] = [:]
        
        if let email = email { dict["email"] = email }
        if let firstName = firstName { dict["firstName"] = firstName }
        if let lastName = lastName { dict["lastName"] = lastName }
        if let mobileNumber = mobileNumber { dict["mobileNumber"] = mobileNumber }
        if let birthday = birthday { dict["birthday"] = dateFormatter.string(from: birthday) }
        if let profilePhoto = profilePhoto { dict["profilePhoto"] = profilePhoto.absoluteString }
        if let dateCreated = dateCreated { dict["dateCreated"] = dateFormatter.string(from: dateCreated) }
        
        return dict
    }
    
    init() {
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    init(withSnapshot snapshot: FIRDataSnapshot) {
        self.init()
        
        firebaseAuthUser = FIRAuth.auth()?.currentUser
        id = firebaseAuthUser?.uid
        
//        firstName = (snapshot.value as! [String: Any])["firstName"] as? String
        
        if let userData = snapshot.value as? [String: Any] {

            // First name
            if let firstName = userData["firstName"] as? String {
                if firstName != self.firstName {
                    self.firstName = firstName
                }
            }

            // Last name
            if let lastName = userData["lastName"] as? String {
                if lastName != self.lastName {
                    self.lastName = lastName
                }
            }

            // Mobile number
            if let mobileNumber = userData["mobileNumber"] as? String {
                if mobileNumber != self.mobileNumber {
                    self.mobileNumber = mobileNumber
                }
            }

            // Email
            if let email = userData["email"] as? String {
                if email != self.email {
                    self.email = email
                }
            }

            // Profile photo
            if let profilePhotoUrlString = userData["profilePhoto"] as? String {
                let profilePhotoUrl = URL(string: profilePhotoUrlString)

                if let profilePhotoUrl = profilePhotoUrl {
                    if profilePhotoUrl != self.profilePhoto {
                        self.profilePhoto = profilePhotoUrl
                    }
                }
            }

            // Birthday
            if let birthdayString = userData["birthday"] as? String {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                
                let birthdayDate = formatter.date(from: birthdayString)
                
                if let birthdayDate = birthdayDate {
                    if birthdayDate != self.birthday {
                        self.birthday = birthdayDate
                    }
                }
            }
            
            // Date created
            if let dateCreatedString = userData["dateCreated"] as? String {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                
                let dateCreatedDate = formatter.date(from: dateCreatedString)
                
                if let dateCreatedDate = dateCreatedDate {
                    if dateCreatedDate != self.dateCreated {
                        self.dateCreated = dateCreatedDate
                    }
                }
            }
        }
    }
    
}
