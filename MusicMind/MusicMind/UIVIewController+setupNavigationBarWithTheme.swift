//
//  UIVIewController+setupNavigationBarWithTheme.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 4/11/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import Foundation

extension UIViewController {
    func setupNavigationBar(theme: NavigationBarTheme) {
        let tintColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        let transparentImage = UIImage.imageColored(color: UIColor.clear)
        let navBar = self.navigationController?.navigationBar
        
        navBar?.setBackgroundImage(transparentImage, for: .default)
        navBar?.shadowImage = transparentImage
        navBar?.isTranslucent = true
        navBar?.tintColor = tintColor
        
        // And show status bar
        UIApplication.shared.statusBarStyle = .default
        UIApplication.shared.isStatusBarHidden = false
    }
}
