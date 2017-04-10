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
    
    @IBOutlet weak var cameraPreviewView: PreviewView!
    @IBOutlet weak var recordButtonContainer: UIView!
    var recordButton: RecordButton!
    
    let newMovieFileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("movie.mov")
    
    // AV Foundation Capture objects
    let session = AVCaptureSession()
    var camera: AVCaptureDevice?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var cameraCaptureOutput: AVCaptureMovieFileOutput?

    
    override func viewDidLoad() {

        setupCaptureSession()
        
        
        // Set up the record button
        recordButton = RecordButton(frame: CGRect(x: 0,y: 0,width: 70,height: 70))
        
        recordButton.center = recordButtonContainer.center
        
        recordButton.buttonColor = .white
        recordButton.progressColor = .red
        recordButton.closeWhenFinished = false
        
        recordButton.addTarget(self, action: #selector(self.startRecordingVideo), for: .touchDown)
        recordButton.addTarget(self, action: #selector(self.stopRecordingVideo), for: UIControlEvents.touchUpInside)
        recordButton.addTarget(self, action: #selector(self.stopRecordingVideo), for: UIControlEvents.touchDragExit)
        
        
        self.view.addSubview(recordButton)
        
        super.viewDidLoad()
    }
    
    func setupCaptureSession() {
        session.sessionPreset = AVCaptureSessionPresetHigh
        
        camera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let cameraCaptureInput = try AVCaptureDeviceInput(device: camera)
            
            cameraCaptureOutput = AVCaptureMovieFileOutput()
            
            session.addInput(cameraCaptureInput)
            session.addOutput(cameraCaptureOutput)
        } catch {
            print(error.localizedDescription)
        }
        
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraPreviewLayer?.frame = cameraPreviewView.bounds
        cameraPreviewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.portrait
        
        cameraPreviewView.layer.addSublayer(cameraPreviewLayer!)
        
        session.startRunning()
    }
    
    @IBAction func flipCameras(_ sender: Any) {

    }
    
    func startRecordingVideo() {

        cameraCaptureOutput?.startRecording(toOutputFileURL: newMovieFileUrl, recordingDelegate: self)
    }
    
    func stopRecordingVideo() {
        cameraCaptureOutput?.stopRecording()
    }
    
    func openSendToFriend(_ sender: Any) {
        let sendToFriendViewController = UIStoryboard(name: "SendToFriend", bundle: nil).instantiateViewController(withIdentifier: "SendToFriend") as! SendToFriendViewController
        
        self.present(sendToFriendViewController, animated: true, completion: nil)
    }
}

extension CameraCaptureViewController: AVCaptureFileOutputRecordingDelegate {
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        // code
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        // code
    }
}







