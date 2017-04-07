//
//  UIViewController+hideKeyboardWhenTappedAround.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 4/7/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import Foundation

// Thanks to http://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
