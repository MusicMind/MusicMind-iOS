//
//  EmailVerifier.swift
//  MusicMind
//
//  Created by Angel Contreras on 4/10/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import Foundation

class EmailVerifier{
    static func isValid(email: String, completion: ((_ valid: Bool) -> Void)) {
        let filterString = "[A-Z0-9a-z\\._%-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", argumentArray: [filterString])
        completion(emailTest.evaluate(with: email, substitutionVariables: nil))
    }
}
