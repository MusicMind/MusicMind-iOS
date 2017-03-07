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
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        delegate = self
        _previewView = previewView
        super.viewDidLoad()
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func toggleCameraPressed(_ sender: Any) {
        self.changeCamera()
    }
    @IBAction func recordButtonPressed(_ sender: Any) {
        self.toggleMovieRecording()
    }
}

extension CameraViewController: APPLCameraViewControllerDelegate{
    func shouldEnableCameraUI(enabled: Bool) {
        cameraButton.isEnabled = enabled
    }
    
    func shouldEnableRecordUI(enabled: Bool) {
        recordButton.isEnabled = enabled
    }
    
    func recordingHasStarted() {
        
    }
    
    func canStartRecording() {
        
    }
}

// MARK: - Photo Capture Delegate Functions
//extension CameraViewController: PhotoCaptureDelegate {
//    
//}

