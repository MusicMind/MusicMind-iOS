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
        
        // Setup spotify auth
        spotifyAuth.sessionUserDefaultsKey = "MMSpotifySession" // Enable automatic saving of the session to defaults
        spotifyAuth.clientID = "3b7f66602b9c45b78f4aa55de8efd046"
        spotifyAuth.redirectURL = URL(string: "musicmind://returnAfterSpotify")
        spotifyAuth.requestedScopes = [SPTAuthStreamingScope]
        
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
                    //////////////////////////////////////////////////
                    
                    if session.isValid() {
                        print("session is valid")
                    }
                    else {
                        print("nope")
                    }
                }
                
            })
            
            return true
        }
        
        return false
    }
}

