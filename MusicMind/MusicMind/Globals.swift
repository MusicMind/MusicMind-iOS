//
//  Globals.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 3/18/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import Foundation

var user = User()
let spotifyAuth = SPTAuth.defaultInstance()!
let spotifyStreamingController = SPTAudioStreamingController.sharedInstance()!

enum NavigationBarTheme {
    case light
    case dark
}

// https://gist.github.com/wvdk/6d4478d1d975068a011eb0bc7d3c5c6f
var prettyVersionNumber: String {
    get {
        if let infoDictionary = Bundle.main.infoDictionary {
            if let versionNumber = infoDictionary["CFBundleShortVersionString"] as? String,
                let buildNumber = infoDictionary["CFBundleVersion"] as? String {
                
                return "\(versionNumber) (\(buildNumber))"
            }
        }
        
        return "No version number found."
    }
}
