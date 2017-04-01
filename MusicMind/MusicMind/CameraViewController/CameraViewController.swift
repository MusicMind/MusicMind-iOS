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
    
    var isRecording: Bool = false
    
    @IBAction func textOverlay(_ sender: Any) {
        let vc = UIStoryboard(name: "TextOverlayCreation", bundle: nil).instantiateViewController(withIdentifier: "textOverlay") as! TextOverlayCreationViewController
                
        self.present(vc, animated: true, completion: nil)

    }
    
    @IBAction func openSendToFriend(_ sender: Any) {
        let sendToFriendViewController = UIStoryboard(name: "SendToFriend", bundle: nil).instantiateViewController(withIdentifier: "SendToFriend") as! SendToFriendViewController
        
        self.modalPresentationStyle = UIModalPresentationStyle.currentContext
        
        self.present(sendToFriendViewController, animated: true, completion: nil)
    }
    
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
        isRecording = !isRecording
        
        if isRecording {
            recordButton.setTitle("stop recording", for: .normal)
        } else {
            recordButton.setTitle("Record Video", for: .normal)
        }
        
    }
    
    
    @IBAction func photoToolBarButtonPressed(_ sender: Any) {
        toggleCaptureMode(.photo)
        recordButton.setTitle("Take Photo", for: .normal)
        
        photoToolBarItem.tintColor = UIColor.black
        videoToolBarItem.tintColor = UIColor.blue
        
    }
    
    @IBAction func videoToolBarItemPressed(_ sender: Any) {
        toggleCaptureMode(.movie)
        recordButton.setTitle("Record Video", for: .normal)
        photoToolBarItem.tintColor = UIColor.blue
        videoToolBarItem.tintColor = UIColor.black
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "textOverlay" {
            let vc = segue.destination as! TextOverlayCreationViewController
            
            vc.cameraVC = self
            vc.modalPresentationStyle = UIModalPresentationStyle.custom
            
        }
        
    }
}


// MARK: - APPLCameraViewControllerDelegate
extension CameraViewController: APPLCameraViewControllerDelegate {
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

