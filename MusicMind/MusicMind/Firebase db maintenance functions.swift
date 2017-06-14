//
//  Firebase db maintenance functions.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 5/12/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import Foundation
import Firebase

func fetchUsersThenGenerateSearchNames(completionHandler: @escaping (_ searchableNames: [String: String]) -> ()) {
    /// How to use:
    /// fetchUsersThenGenerateSearchNames { (searchNames: [String : String]) in
    ///     let ref = FIRDatabase.database().reference().child("searchableNames")
    ///
    ///     ref.updateChildValues(searchNames)
    /// }
    
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
