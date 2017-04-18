//
//  AppDelegate.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 2/28/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var user: User!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FIRApp.configure()
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if SPTAuth.defaultInstance().canHandle(url) {
            SPTAuth.defaultInstance().handleAuthCallback(withTriggeredAuthURL: url, callback: {
                (error, session) in
                if error != nil {
                    print("*** Auth error \(String(describing: error))")
                    return
                }
            })
        }
        
                return false
    }
}

