//
//  UserTests.swift
//  MusicMind
//
//  Created by Angel Contreras on 4/4/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import XCTest

class UserTests: XCTestCase {
    
    func testFirstNamePersistance(){
        let firstName = "Angel"
        let user = User()
        user.firstName = "Angel"
        XCTAssert(user.firstName == firstName)
    }
    
}
