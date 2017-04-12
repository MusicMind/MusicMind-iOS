//
//  WelcomeViewController.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 4/3/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Navigation bar styling
        let transparentImage = UIImage.imageColored(color: UIColor.clear)
        let navBar = self.navigationController?.navigationBar
        navBar?.setBackgroundImage(transparentImage, for: .default)
        navBar?.shadowImage = transparentImage
        navBar?.isTranslucent = true
       // navBar?.tintColor = secondaryTextColor
        navBar?.tintColor = UIColor.init(colorLiteralRed: 240/255.0, green: 10/255.0, blue: 136/255.0, alpha:1)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
