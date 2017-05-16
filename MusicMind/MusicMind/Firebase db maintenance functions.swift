//
//  Firebase db maintenance functions.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 5/12/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import Foundation
import Firebase

/// Goal: To have "searchableNames" a lookup table of String 1->* UserID values
/// Names must be lowercase, and concatenated first and last name
/// Go through every user in the "users" table
/// Generate searchableName value
/// Add to "searchableName" table

func fetchUsersAndGenerateSearchNames(completionHandler: @escaping (_ searchableNames: [String: String]) -> ()) {
    var searchNames = [String: String]() // [name: id]
    let usersRef = FIRDatabase.database().reference().child("users")
    
    usersRef.observe(.value) { (snapshot: FIRDataSnapshot) in
        let children = snapshot.children
        
        while let child = children.nextObject() as? FIRDataSnapshot {
            let user = User(withSnapshot: child)

            if let id = user.id {
                var name = ""

                if let firstName = user.firstName {
                    name = firstName.lowercased()
                }
                
                if let lastName = user.lastName {
                    name = name.appending(" \(lastName)").lowercased()
                }
                
                if !name.isEmpty {
                    searchNames[name] = id
                }
            }
        }
    
        completionHandler(searchNames)
    }
}

