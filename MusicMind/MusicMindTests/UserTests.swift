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
        let user = User(newId: "ABC123-testCreatingJohnDoeUserAndTestingFirstName")
        
        if let ref = user.userRef {
            ref.observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                if let user = snapshot.value as? [String: Any?] {
                    if let name = user["firstName"] as? String {
                        if name == "John" {
                            e.fulfill()
                        }
                    }
                }
            })
        }
        
        user.firstName = "John"
        
        wait(for: [e], timeout: 10)
    }
    
    func testCreatingJohnDoeUserAndTestingLastName() {
        let e = expectation(description: "test last name")
        let user = User(newId: "ABC123-testCreatingJohnDoeUserAndTestingLastName")
        
        if let ref = user.userRef {
            ref.observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                if let user = snapshot.value as? [String: Any?] {
                    if let name = user["lastName"] as? String {
                        if name == "Doe" {
                            e.fulfill()
                        }
                    }
                }
            })
        }
        
        user.lastName = "Doe"
        
        wait(for: [e], timeout: 10)
    }
    
    func testCreatingJohnDoeUserAndTestingMobileNumber() {
        let e = expectation(description: "test mobile number")
        let user = User(newId: "ABC123-testCreatingJohnDoeUserAndTestingMobileNumber")
        
        if let ref = user.userRef {
            ref.observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                if let user = snapshot.value as? [String: Any?] {
                    if let number = user["mobileNumber"] as? String {
                        if number == "000-000-0000" {
                            e.fulfill()
                        }
                    }
                }
            })
        }
        
        user.mobileNumber = "000-000-0000"
        
        wait(for: [e], timeout: 10)
    }
    
    func testCreatingJohnDoeUserAndTestingBirthday() {
        let e = expectation(description: "test mobile number")
        let user = User(newId: "ABC123-testCreatingJohnDoeUserAndTestingBirthday")
        
        let birthdayDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let ref = user.userRef {
            ref.observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
                if let user = snapshot.value as? [String: Any?] {
                    if let dateString = user["birthday"] as? String {
                        
                        let date = dateFormatter.date(from: dateString)
                        
                        if date == birthdayDate {
                            e.fulfill()
                        }
                    }
                }
            })
        }
        
        user.birthday = birthdayDate
        
        wait(for: [e], timeout: 10)
    }
}
