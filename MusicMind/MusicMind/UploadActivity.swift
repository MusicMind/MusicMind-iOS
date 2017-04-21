//
//  UploadActivity.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 4/21/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit

class UploadActivity: UIActivity {
    
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
        return true
    }
    
    override func prepare(withActivityItems activityItems: [Any]) {
        // code
    }
    
//    override var activityCategory: UIActivityCategory {
//        return UIActivityCategory.action
//    }
}
