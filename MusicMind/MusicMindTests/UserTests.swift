//
//  UserTests.swift
//  MusicMind
//
//  Created by Angel Contreras on 4/4/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import XCTest
@testable import MusicMind
import Firebase

class UserTests: XCTestCase {
    
    func testInitWithSnapshot() {
        let e = expectation(description: "Testing init with snapshot")
        
        // First let's get a snapshot of John Doe user
        
        let hardCodedUidForJohnDoe = "VIyKDq9RzGgcRq9vZ50NnRW1nps2"
        let userRef = FIRDatabase.database().reference().child("users\(hardCodedUidForJohnDoe)")
        
        userRef.observe(.value) { (snapshot: FIRDataSnapshot) in
            // Now lets initialize a user using that snapshop
            
            let user = User(withSnapshot: snapshot)
            
            if user.firstName == "John" {
                e.fulfill()
            }
        }
        
        wait(for: [e], timeout: 5)
    }
    


    
    
}
