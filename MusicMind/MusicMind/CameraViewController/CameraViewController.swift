//
//  CameraViewController.swift
//  MusicMind
//
//  Created by Angel Contreras on 2/28/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: APPLCameraViewController {
    
    @IBOutlet weak var previewView: PreviewView!
    @IBOutlet weak var cameraButton: UIButton!
    
    override func viewDidLoad() {
        self._previewView = previewView
        self._cameraButton = cameraButton
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func toggleCameraPressed(_ sender: Any) {
        self.changeCamera()
    }
    @IBAction func recordButtonPressed(_ sender: Any) {
        
    }
}

// MARK: - Photo Capture Delegate Functions
//extension CameraViewController: PhotoCaptureDelegate {
//    
//}

