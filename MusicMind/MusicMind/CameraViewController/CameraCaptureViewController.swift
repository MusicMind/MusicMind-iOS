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

class CameraCaptureViewController: UIViewController {
    
    @IBOutlet weak var previewView: PreviewView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var recordButtonContainer: UIView!
    
    var recordButton: RecordButton!
    
    // AV Foundation Capture objects
    let session = AVCaptureSession()
    var camera: AVCaptureDevice?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var cameraCaptureOutput: AVCaptureVideoDataOutput?

    
    override func viewDidLoad() {

        setupCaptureSession()
        
        
        // Set up the record button
        recordButton = RecordButton(frame: CGRect(x: 0,y: 0,width: 70,height: 70))
        
        recordButton.center = recordButtonContainer.center
        
        recordButton.buttonColor = .white
        recordButton.progressColor = .red
        recordButton.closeWhenFinished = false
        
        recordButton.addTarget(self, action: #selector(self.startRecording), for: .touchDown)
        recordButton.addTarget(self, action: #selector(self.stopRecording), for: UIControlEvents.touchUpInside)
        recordButton.addTarget(self, action: #selector(self.stopRecording), for: UIControlEvents.touchDragExit)
        
        
        self.view.addSubview(recordButton)
        
        super.viewDidLoad()
    }
    
    func setupCaptureSession() {
        session.sessionPreset = AVCaptureSessionPresetHigh
        
        camera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let cameraCaptureInput = try AVCaptureDeviceInput(device: camera)
            
            cameraCaptureOutput = AVCaptureVideoDataOutput()
            
            session.addInput(cameraCaptureInput)
            session.addOutput(cameraCaptureOutput)
        } catch {
            print(error.localizedDescription)
        }
        
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraPreviewLayer?.frame = previewView.bounds
        cameraPreviewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.portrait
        
        previewView.layer.addSublayer(cameraPreviewLayer!)
        
        session.startRunning()
    }
    
    @IBAction func toggleCameraPressed(_ sender: Any) {
        
    }
    
    func startRecording() {

        
    }
    
    func stopRecording() {
        
    }
    
    func openSendToFriend(_ sender: Any) {
        let sendToFriendViewController = UIStoryboard(name: "SendToFriend", bundle: nil).instantiateViewController(withIdentifier: "SendToFriend") as! SendToFriendViewController
        
        self.present(sendToFriendViewController, animated: true, completion: nil)
    }
}

