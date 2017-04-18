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
        // Override point for customization after application launch.
        
        FIRApp.configure()
        
        
        /* Example from another app I built of how I changed the initial screen depending on if user has already logged in
         
         
        // Check if user already signed in, and if so skip to arrived timeline.
        if activeUser.loginStatus == .signedInAndAuthenticated {
            
            log.verbose("Found a token. Skipping sign in step.")
            
            log.verbose("Creating storyboard and setting ArrivedTimeline to initial view controller.")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let ArrivedTimelineView = storyboard.instantiateViewController(withIdentifier: "arrived")
            self.window?.rootViewController = ArrivedTimelineView
            
            
            //            try! activeUser.registerForPush() // don't need to handle throw because already checked above.
        } else {
            log.warning("Not signed in and authenticated.")
            
            if activeUser.loginStatus == LoginStatus.signedInButNotAuthenticated {
                log.verbose("Found an email. Skipping to arrived timeline and displaying emailNotVerifiedView.")
                log.verbose("Creating storyboard and setting ArrivedTimeline to initial view controller.")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let ArrivedTimelineView = storyboard.instantiateViewController(withIdentifier: "arrived")
                
                self.window?.rootViewController = ArrivedTimelineView
            }
        }
         
         
        */
        
        
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if SPTAuth.defaultInstance().canHandle(url) {
            SPTAuth.defaultInstance().handleAuthCallback(withTriggeredAuthURL: url, callback: {
                (error, session) in
                if error != nil {
                    print("*** Auth error \(error)")
                    return
                }
//                user.spotifyToken = session?.accessToken
//                let story = UIStoryboard.init(name: "SpotifyAuth", bundle: nil)
//                let tabView = story.instantiateViewController(withIdentifier: "tabView")
//                self.window?.rootViewController = tabView
                
            })
        }
        
                return false
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

