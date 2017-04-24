//
//  UploadActivity.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 4/21/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit

class UploadActivity: UIActivity {
    
    private var sendToFriendViewController: SendToFriendViewController?
    
    override var activityType: UIActivityType? {
        return nil
    }
    
    override var activityTitle: String? {
        return "Upload to MusicMind"
    }
    
    override var activityImage: UIImage? {
        return #imageLiteral(resourceName: "cool")
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        for item in activityItems {
            if let url = item as? URL {
                if url.lastPathComponent == "movie.mov" || url.lastPathComponent == "movie.mp4" {
                    return true
                }
            }
        }
        
        return false
    }
    
    override func prepare(withActivityItems activityItems: [Any]) {
        for item in activityItems {
            if let url = item as? URL {
                print("Item is a url. See: \(url.absoluteString)")
                
                // save url
                
                // get vc ready
                
                sendToFriendViewController = SendToFriendViewController(nibName: "SendToFriendView", bundle: Bundle.main)
                
            }
        }
    }
    
    override var activityViewController: UIViewController? {
        return sendToFriendViewController
    }
    
//    override var activityCategory: UIActivityCategory {
//        return UIActivityCategory.action
//    }
}
