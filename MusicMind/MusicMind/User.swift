//
//  User.swift
//  MusicMind
//
//  Created by Angel Contreras on 4/3/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//
import Foundation

struct User {
    
    private enum UserDefaultsKeys: String {
        case firstNameKey = "MMFirstName"
        case lastNameKey = "MMLastName"
        case birthdayKey = "MMBirthday"
        case firebaseUUIDKey = "MMFirebaseUUIDKey"
        case mobileNumberKey = "MMMobileNumber"
    }
    
    var firstName: String?
    
    
    var lastName: String?
    
    var birthday: Date?
    
    var firebaseUUID: String?
    
    var mobileNumber: String?
    
    var dictionaryRepresentation: [String: Any?] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return ["firstName": self.firstName,
                "lastName": self.lastName,
                "birthday": dateFormatter.string(from: self.birthday!),
                "mobileNum": self.mobileNumber]
    }
}
