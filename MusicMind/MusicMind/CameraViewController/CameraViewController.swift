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
    @IBOutlet weak var photoToolBarItem: UIBarButtonItem!
    @IBOutlet weak var videoToolBarItem: UIBarButtonItem!
    
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
    
    
    @IBAction func photoToolBarButtonPressed(_ sender: Any) {
        toggleCaptureMode(.photo)
        photoToolBarItem.tintColor = UIColor.black
        videoToolBarItem.tintColor = UIColor.blue
        
    }
    
    @IBAction func videoToolBarItemPressed(_ sender: Any) {
        toggleCaptureMode(.movie)
        photoToolBarItem.tintColor = UIColor.blue
        videoToolBarItem.tintColor = UIColor.black
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

