//
//  UserTests.swift
//  MusicMind
//
//  Created by Angel Contreras on 4/4/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import XCTest
@testable import MusicMind


class UserTests: XCTestCase {
    
//    func testFirstNamePersistance(){
//        let firstName = "Angel"
//        let user = User()
//        user.firstName = "Angel"
//        XCTAssert(user.firstName == firstName)
//    }
    
    func testInitForUuid() {
        let testUser = User(firebaseUserWithUuid: "abc123fakeUuidForJohnDoe")
        
        let e = expectation(description: "init with uuid")
        
        print("starting")
        
        testUser.ref.childByAutoId().setValue(["abc":"abc"]) { (error, ref) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("success")
                e.fulfill()
            }
        }
        
        wait(for: [e], timeout: 10)
    }
    
    func testCreatingJohnDoe() {
        
        
        
//        let _ = User(newUserWithFirstName: "John", lastName: "Doe")
        
//        let
    }
    
}
