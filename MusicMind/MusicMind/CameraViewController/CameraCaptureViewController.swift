//
//  CameraCaptureViewController.swift
//  MusicMind
//
//  Created by Angel Contreras on 2/28/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit
import AVFoundation
import RecordButton

class CameraCaptureViewController: APPLCameraViewController {
    
    @IBOutlet weak var previewView: PreviewView!
    @IBOutlet weak var cameraButton: UIButton!
    
    var recordButton: RecordButton!
    var isRecording: Bool = false
    
    override func viewDidLoad() {
        delegate = self
        _previewView = previewView
        
        toggleCaptureMode(.movie)
        
        recordButton = RecordButton(frame: CGRect(x: 0,y: 0,width: 70,height: 70))
        recordButton.center = self.view.center
        recordButton.progressColor = .red
        recordButton.closeWhenFinished = false
        
        recordButton.addTarget(self, action: #selector(self.startRecording), for: .touchDown)
//        recordButton.addTarget(self, action: #selector(self.stop), for: UIControlEvents.touchUpInside)
//
        recordButton.center.x = self.view.center.x
        
        view.addSubview(recordButton)
        
        super.viewDidLoad()
    }
    
    @IBAction func toggleCameraPressed(_ sender: Any) {
        self.changeCamera()
    }
    
    func startRecording() {
//        self.toggleMovieRecording()
        
//        isRecording = !isRecording
    }
    
    func openSendToFriend(_ sender: Any) {
        let sendToFriendViewController = UIStoryboard(name: "SendToFriend", bundle: nil).instantiateViewController(withIdentifier: "SendToFriend") as! SendToFriendViewController
        
        self.present(sendToFriendViewController, animated: true, completion: nil)
    }
}


// MARK: - APPLCameraViewControllerDelegate
extension CameraCaptureViewController: APPLCameraViewControllerDelegate {
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
    
    // MARK: - Post to firebase
    func didFinishRecordingToOutputFileAt(outputUrl: URL) {
        // Show the camera view controller
//        let sendToFriendViewController = UIStoryboard(name: "SendToFriend", bundle: nil).instantiateViewController(withIdentifier: "SendToFriend") as! SendToFriendViewController
//        
//        sendToFriendViewController.urlOfVideo = outputUrl
//        
//        self.present(sendToFriendViewController, animated: true, completion: nil)
//        
    }
}

