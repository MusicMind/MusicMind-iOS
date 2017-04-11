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
import MobileCoreServices

final class CameraCaptureViewController: UIViewController {
    
    @IBOutlet private weak var cameraPreviewView: PreviewView!
    @IBOutlet private weak var recordButtonContainer: UIView!
    @IBOutlet private weak var libraryButton: UIButton!
    private var recordButton: RecordButton!
    fileprivate let newMovieFileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("movie.mov")
    
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setups
        setupCaptureSession()
        setupNavigationBar(theme: .light)
        
        // Position the library button
        libraryButton.center = CGPoint(x: recordButtonContainer.center.x - 110, y: recordButtonContainer.center.y)
        
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    // MARK: - AV Capturing
    
    let session = AVCaptureSession()
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var cameraCaptureOutput: AVCaptureMovieFileOutput?
    let cameraDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)

    func setupCaptureSession() {
        session.sessionPreset = AVCaptureSessionPresetHigh
        
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
    
    // MARK: - Camera interaction
    
    @IBAction func flipCameras(_ sender: Any) {
        session.beginConfiguration()
        
        
        let devices = AVCaptureDevice.devices()

//        let deviceDiscoverySession = AVCaptureDeviceDiscoverySession(deviceTypes: <#T##[AVCaptureDeviceType]!#>, mediaType: <#T##String!#>, position: <#T##AVCaptureDevicePosition#>)


        session.commitConfiguration()
    }
    
    func startRecordingVideo() {
        cameraCaptureOutput?.startRecording(toOutputFileURL: newMovieFileUrl, recordingDelegate: self)
    }
    
    func stopRecordingVideo() {
        cameraCaptureOutput?.stopRecording()
    }
    
    // MARK: - Navigation
    
    fileprivate func navigateToSendToFriendViewController(movieURL: URL) {
        let sendToFriendViewController = UIStoryboard(name: "SendToFriend", bundle: nil).instantiateViewController(withIdentifier: "SendToFriendViewController") as! SendToFriendViewController
        
        sendToFriendViewController.urlOfVideo = movieURL
        
        self.navigationController?.pushViewController(sendToFriendViewController, animated: true)
    }
    
    @IBAction func presentSelectFromLibraryViewController(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeMovie as String]
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
}
extension CameraCaptureViewController: AVCaptureFileOutputRecordingDelegate {
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        navigateToSendToFriendViewController(movieURL: newMovieFileUrl)
    }

}

extension CameraCaptureViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let urlForMovie = info[UIImagePickerControllerMediaURL] as? URL {
            navigateToSendToFriendViewController(movieURL: urlForMovie)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}







