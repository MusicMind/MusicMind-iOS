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

final class CameraCaptureViewController: UIViewController {
    
    @IBOutlet private weak var cameraPreviewView: PreviewView!
    @IBOutlet private weak var recordButtonContainer: UIView!
    private var recordButton: RecordButton!
    private let newMovieFileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("movie.mov")
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        setupCaptureSession()
        
        setupNavigationBar(theme: .light)
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - AV Capturing
    
    let session = AVCaptureSession()
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var cameraCaptureOutput: AVCaptureMovieFileOutput?

    func setupCaptureSession() {
        session.sessionPreset = AVCaptureSessionPresetHigh
        
        let cameraDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            let cameraInput = try AVCaptureDeviceInput(device: cameraDevice)
            
            cameraCaptureOutput = AVCaptureMovieFileOutput()
            
            session.addInput(cameraInput)
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
        
        let discoverySession = AVCaptureDeviceDiscoverySession(deviceTypes: [AVCaptureDeviceType.builtInDualCamera], mediaType: AVMediaTypeVideo, position: AVCaptureDevicePosition.unspecified)
        
        print(discoverySession!.devices.description)
        
//        camera = AVCaptureDevice.defaultDevice(withDeviceType: AVCaptureDeviceType.builtInDualCamera, mediaType: AVMediaTypeVideo, position: AVCaptureDevicePosition.front)
    }
    
    func startRecordingVideo() {
        cameraCaptureOutput?.startRecording(toOutputFileURL: newMovieFileUrl, recordingDelegate: self)
    }
    
    func stopRecordingVideo() {
        cameraCaptureOutput?.stopRecording()
    }
    
    // MARK: - Navigation
    
    fileprivate func navigateToSendToFriendViewController(_ sender: Any) {
        let sendToFriendViewController = UIStoryboard(name: "SendToFriend", bundle: nil).instantiateViewController(withIdentifier: "SendToFriendViewController") as! SendToFriendViewController
        
//        sendToFriendViewController.urlOfVideo
        
        self.navigationController?.pushViewController(sendToFriendViewController, animated: true)
    }
}
extension CameraCaptureViewController: AVCaptureFileOutputRecordingDelegate {
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        navigateToSendToFriendViewController(self)
    }

}







