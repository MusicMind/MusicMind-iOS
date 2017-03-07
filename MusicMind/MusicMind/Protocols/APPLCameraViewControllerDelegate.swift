//
//  APPLCameraViewControllerDelegate.swift
//  MusicMind
//
//  Created by Angel Contreras on 3/7/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import Foundation

protocol APPLCameraViewControllerDelegate: class {
    func shouldEnableRecordUI(enabled: Bool)
    func shouldEnableCameraUI(enabled: Bool)
    
    // For future use when we would like to show that there is a recording in progress
    func canStartRecording()
    func recordingHasStarted()
}
