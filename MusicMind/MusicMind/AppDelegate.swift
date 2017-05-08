//
//  AppDelegate.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 2/28/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit
import Firebase
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var user: User!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FIRApp.configure()
        
        // If user is already signed in skip the onboarding flow
        if FIRAuth.auth()?.currentUser != nil {
            let storyboard = UIStoryboard(name: "CameraCapture", bundle: nil)
            let welcomeViewController = storyboard.instantiateInitialViewController()
            
            self.window?.rootViewController = welcomeViewController
        } else {
            let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
            let welcomeViewController = storyboard.instantiateInitialViewController()
            
            self.window?.rootViewController = welcomeViewController
        }
        
        // Setup spotify auth
        spotifyAuth.sessionUserDefaultsKey = "MMSpotifySession" // Enable automatic saving of the session to defaults
        spotifyAuth.clientID = "3b7f66602b9c45b78f4aa55de8efd046"
        spotifyAuth.redirectURL = URL(string: "musicmind://returnAfterSpotify")
        spotifyAuth.requestedScopes = [SPTAuthStreamingScope]
        
        do {
            try spotifyStreamingController.start(withClientId: spotifyAuth.clientID)
            
            spotifyStreamingController.setTargetBitrate(SPTBitrate.normal, callback: { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            })
            
            spotifyStreamingController.diskCache = SPTDiskCache(capacity: 5)
        } catch {
            print(error)
        }
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {

        // Check if this is coming from the Spotify login flow
        if spotifyAuth.canHandle(url) {
            spotifyAuth.handleAuthCallback(withTriggeredAuthURL: url, callback: {
                (error, session) in
                
                if let error = error {
                    print(error.localizedDescription)
                } else if let session = session {
                    if session.isValid() {
                        spotifyAuth.session = session
                    }
                }
            })
            
            return true
        }
        
        return false
    }
    
    
    
    
    
    
    
    
    
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "MusicMind")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    
    
    
}

