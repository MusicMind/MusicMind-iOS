//
//  UIViewController+hideKeyboardWhenTappedAround.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 3/30/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import Foundation

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
