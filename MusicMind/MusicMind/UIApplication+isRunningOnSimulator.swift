//
//  UIApplication+isRunningOnSimulator.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 5/11/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import Foundation

extension UIApplication {
 
    static var isRunningOnSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
}
