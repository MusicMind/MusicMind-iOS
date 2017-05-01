//
//  User.swift
//  MusicMind
//
//  Created by Angel Contreras on 4/3/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//
import Foundation

struct User{
    
    private enum UserDefaultsKeys: String {
        case firstNameKey = "MMFirstName"
        case lastNameKey = "MMLastName"
        case birthdayKey = "MMBirthday"
        case firebaseUUIDKey = "MMFirebaseUUIDKey"
        case mobileNumberKey = "MMMobileNumber"
    }
    
    var firstName: String? {
        get{
            return UserDefaults.standard.object(forKey: UserDefaultsKeys.firstNameKey.rawValue) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.firstNameKey.rawValue)
        }
    }
    
    
    var lastName: String? {
        get{
            return UserDefaults.standard.object(forKey: UserDefaultsKeys.lastNameKey.rawValue) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.lastNameKey.rawValue)
        }
    }
    
    var birthday: Date? {
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
    
    var mobileNumber: String? {
        get{
            return UserDefaults.standard.object(forKey: UserDefaultsKeys.mobileNumberKey.rawValue) as? String
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.mobileNumberKey.rawValue)
        }
    }
    
    var dictionaryRepresentation: [String: Any?] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return ["firstName": self.firstName,
                "lastName": self.lastName,
                "birthday": dateFormatter.string(from: self.birthday!),
                "mobileNum": self.mobileNumber]
    }
}
