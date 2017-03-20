//
//  User.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 3/18/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit
import KeychainSwift

class User: NSObject {
    
    private let keychain: KeychainSwift!
    
    /// Constant keys for accessing values in keychain
    private enum KeychainKey: String {
        case firebaseUserEmail = "MMEmail"
        case firebaseUserPassword = "MMPassword"
    }
    
    override init() {
        keychain = KeychainSwift()

        super.init()
    }

    var firebaseUserEmail: String? {
        get {
            
            return keychain.get(KeychainKey.firebaseUserEmail.rawValue)
        }
        set {            
            if let unwrappedNewValue = newValue {
                keychain.set(unwrappedNewValue, forKey: KeychainKey.firebaseUserEmail.rawValue)
            } else {
                keychain.delete(KeychainKey.firebaseUserEmail.rawValue)
            }
        }
    }
    
    var firebaseUserPassword: String? {
        get {
            
            return keychain.get(KeychainKey.firebaseUserPassword.rawValue)
        }
        set {
            if let unwrappedNewValue = newValue {
                keychain.set(unwrappedNewValue, forKey: KeychainKey.firebaseUserPassword.rawValue)
            } else {
                keychain.delete(KeychainKey.firebaseUserPassword.rawValue)
            }
        }
    }

}
