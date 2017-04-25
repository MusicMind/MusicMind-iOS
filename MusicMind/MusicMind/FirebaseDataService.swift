//
//  FirebaseDataService.swift
//  MusicMind
//
//  Created by Angel Contreras on 4/4/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

fileprivate let database = FIRDatabase.database().reference()
fileprivate let storage = FIRStorage.storage().reference()

class FirebaseDataService{
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
    
}
