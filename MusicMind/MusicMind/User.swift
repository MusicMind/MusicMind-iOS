//
//  User.swift
//  MusicMind
//
//  Created by Angel Contreras on 4/3/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import Foundation

struct User{
    
    private enum UserDefaultsKeys: String{
        case firstNameKey = "MMFirstName"
        case lastNameKey = "MMLastName"
        case birthdayKey = "MMBirthday"
        case firebaseUUIDKey = "MMFirbaseUUID"
    }
    
<<<<<<< HEAD
    var firstName: String?{
        get{
            return UserDefaults.standard.object(forKey: UserDefaultsKeys.firstNameKey.rawValue) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.firstNameKey.rawValue)
        }
=======
    /// Constant keys for accessing values in keychain
    private enum KeychainKey: String {
        case firebaseUserEmail = "MMEmail"
        case firebaseUserPassword = "MMPassword"

>>>>>>> origin/Issue-52-Sign-Up-Screen
    }
    
    var lastName: String?{
        get{
            return UserDefaults.standard.object(forKey: UserDefaultsKeys.lastNameKey.rawValue) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.lastNameKey.rawValue)
        }
    }
    
    var birthday: Date?{
        get{
            return UserDefaults.standard.object(forKey: UserDefaultsKeys.birthdayKey.rawValue) as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.birthdayKey.rawValue)
        }
    }
    
    var firebaseUUID: String? {
        get{
            return UserDefaults.standard.object(forKey: UserDefaultsKeys.firebaseUUIDKey.rawValue) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.firebaseUUIDKey.rawValue)
        }
    }
    
    var spotifyToken: String?
<<<<<<< HEAD
=======
    
    var firstName: String?
    
    var lastName: String?
    
    var birthday: Date?
    
    var firebaseUUID: String?
    
    var dictionaryRepresentation: [String: Any] {
        return ["firstName": self.firstName, "lastName": self.lastName, "birthday": self.birthday]
    }

>>>>>>> origin/Issue-52-Sign-Up-Screen
}
