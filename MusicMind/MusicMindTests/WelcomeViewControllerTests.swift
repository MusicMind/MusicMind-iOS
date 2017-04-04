//
//  WelcomeViewControllerTests.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 4/4/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import XCTest
@testable import MusicMind

class WelcomeViewControllerTests: XCTestCase {
    
    var welcomeVC: WelcomeViewController!
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let storyboard = UIStoryboard.init(name: "Welcome", bundle: Bundle.main)
        
        welcomeVC = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
        
//        welcomeVC = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! MusicMind.WelcomeViewController
        
//        UIApplication.shared.keyWindow!.rootViewController = welcomeVC
        
//        XCTAssertNotNil(welcomeVC.view)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        XCTAssert(true)
        
    }
}
