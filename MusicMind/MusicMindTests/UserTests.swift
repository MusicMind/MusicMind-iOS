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
    
    func testCreatingJohnDoeUser() {
        let e = expectation(description: "init with uuid")
        let johnDoeUser = User(newId: "fakeUuidForJohnDoe")
        
        if let ref = johnDoeUser.userRef {
            ref.observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                if let user = snapshot.value as? [String: Any?] {
                    assert((user["firstName"] as! String) == "John")
                }
                
                e.fulfill()
            })
        }
        
        johnDoeUser.firstName = "John"
        
        wait(for: [e], timeout: 100)
    }
    
}
