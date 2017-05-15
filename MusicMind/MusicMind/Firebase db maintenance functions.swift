//
//  Firebase db maintenance functions.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 5/12/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import Foundation
import Firebase

// Create a function that goes through every user and creates a “searchName” value
//
//func iterateThroughEveryUser() {
//    
//    
//    
//    let searchNames: [String: String]
//    
//    let usersRef = FIRDatabase.database().reference().child("users")
//    
//    usersRef.observe(.value) { (snapshot: FIRDataSnapshot) in
//        
//        
//        let children = snapshot.children
//        
//        while let child = children.nextObject() as? FIRDataSnapshot {
//            let user = User(withSnapshot: child)
//            
//            // create a SearchFriendResult
//
//            if let id = user.id {
//                
//                if let firstName = user.firstName {
//                    
//                }
//                
//                if let lastName = user.lastName {
//                    
//                }
//                
//                
////                searchNames[""] = id
//            }
//        
//            
//            print(user.asDictionary)
//        }
//    }
//}
//

