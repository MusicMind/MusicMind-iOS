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
 
//    var firebaseAuthUser: FIRUser?
    var id: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var mobileNumber: String?
    var birthday: Date?
    var profilePhoto: URL?
    var dateCreated: Date?
    fileprivate let dateFormatter = DateFormatter()
    
    init() {
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
}

extension User: FirebaseConvertable {
    
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

    init(withSnapshot snapshot: FIRDataSnapshot) {
        self.init()
        
        id = snapshot.key
        
        if let userData = snapshot.value as? [String: Any] {
            if let firstName = userData["firstName"] as? String { self.firstName = firstName }
            if let lastName = userData["lastName"] as? String { self.lastName = lastName }
            if let mobileNumber = userData["mobileNumber"] as? String { self.mobileNumber = mobileNumber }
            if let email = userData["email"] as? String { self.email = email }
            if let profilePhotoUrlString = userData["profilePhoto"] as? String { profilePhoto = URL(string: profilePhotoUrlString) }
            if let birthdayString = userData["birthday"] as? String { birthday = dateFormatter.date(from: birthdayString) }
            if let dateCreatedString = userData["dateCreated"] as? String { dateCreated = dateFormatter.date(from: dateCreatedString) }
        }
    }
    
}
