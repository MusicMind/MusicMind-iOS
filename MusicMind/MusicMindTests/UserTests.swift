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
    
    func testCreatingJohnDoeUserAndTestingFirstName() {
        let e = expectation(description: "test first name")
        let johnDoeUser = User(newId: "ABC123-fakeUidForJohnDoe")
        
        if let ref = johnDoeUser.userRef {
            ref.observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                if let user = snapshot.value as? [String: Any?] {
                    
                    if let firstName = user["firstName"] as? String {
                        if firstName == "John" {
                            e.fulfill()
                        }
                    }
                }
                
                
                
            })
        }
        
        johnDoeUser.firstName = "John"
        
        wait(for: [e], timeout: 10)
    }
    
    func testCreatingJohnDoeUserAndTestingLastName() {
        let e = expectation(description: "test last name")
        let johnDoeUser = User(newId: "ABC123-fakeUidForJohnDoe")
        
        if let ref = johnDoeUser.userRef {
            ref.observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                if let user = snapshot.value as? [String: Any?] {
                    
                    if let lastName = user["lastName"] as? String {
                        if lastName == "Doe" {
                            e.fulfill()
                        }
                    }
                }
                

                
            })
        }
        
        johnDoeUser.lastName = "Doe"
        
        wait(for: [e], timeout: 10)
    }
    
}
