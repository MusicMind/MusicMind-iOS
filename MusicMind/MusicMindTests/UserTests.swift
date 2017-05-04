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
    
    func testInitForUuid() {
        let e = expectation(description: "init with uuid")
        
        let johnDoeUser = User(newId: "fakeUuidForJohnDoe")
        
        if let userRef = johnDoeUser.userRef {
            userRef.observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                print("value changed")
                print(snapshot.description)
                e.fulfill()
            })
        }
        
        johnDoeUser.firstName = "John"
        
        
        
        wait(for: [e], timeout: 100)
    }
    
}
