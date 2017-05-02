//
//  User.swift
//  MusicMind
//
//  Created by Angel Contreras on 4/3/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//
import Foundation

struct User {
    
    static let shared = FirebaseDataService()
    
    // DB References
    private let userDatabase = database.child("users")
    
    func addUserToUserList(_ user: User) {
        var userAsDictionary: [String: Any] = [:]
        
        for (key, value) in user.dictionaryRepresentation {
            if let value = value {
                userAsDictionary[key] = value
            }
        }
        
        userDatabase.child(user.firebaseUUID!).updateChildValues(userAsDictionary)
    }
    
    fileprivate let database = FIRDatabase.database().reference()
    fileprivate let storage = FIRStorage.storage().reference()

    
    var uuid: String?
    var firstName: String?
    var lastName: String?
    var mobileNumber: String?
    var birthday: Date?
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy-MM-dd"
    
}
