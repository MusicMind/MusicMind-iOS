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
        
        let storyboard = UIStoryboard.init(name: "Welcome", bundle: Bundle.main)
        
        welcomeVC = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
        
        UIApplication.shared.keyWindow!.rootViewController = welcomeVC
        
        XCTAssertNotNil(welcomeVC.view)    
    }
    
    override func tearDown() {
        welcomeVC = nil
        
        super.tearDown()
    }
    
    func testExample() {
        XCTAssert(true)
    }
}
