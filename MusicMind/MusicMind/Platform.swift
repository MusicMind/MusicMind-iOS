//
//  Platform.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 4/25/17.
//  Copyright © 2017 WVDK. All rights reserved.
//
//  All credit to http://stackoverflow.com/a/30284266/6407050
//

import Foundation

struct Platform {
    
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
}
