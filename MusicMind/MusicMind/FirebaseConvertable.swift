//
//  FirebaseConvertable.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 5/10/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import Foundation
import Firebase

protocol FirebaseConvertable {
    var asDictionary: [String: Any] { get }
    
    init(withSnapshot snapshot: FIRDataSnapshot)
}
