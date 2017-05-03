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
    
    func testInitForUuid() {
        let e = expectation(description: "init with uuid")

        let testUser = User(firebaseUserWithUuid: "fakeUuidForJohnDoe") {
            e.fulfill()
        }
        
        wait(for: [e], timeout: 10)
    }
    
}
