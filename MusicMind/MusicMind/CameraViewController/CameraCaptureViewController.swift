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
    
    enum CurrentCamera {
        case front
        case back
    }
    
    var currentCamera = CurrentCamera.front
    let session = AVCaptureSession()
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var cameraCaptureOutput: AVCaptureMovieFileOutput?
    var backCameraDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) // default is always back camera
    var backCameraInput: AVCaptureDeviceInput?
    var frontCameraDevice: AVCaptureDevice?
    var frontCameraInput: AVCaptureDeviceInput?

    func setupCaptureSession() {
        session.sessionPreset = AVCaptureSessionPresetHigh
        
        // Get front camera device and inputs
        let deviceDiscoverySession = AVCaptureDeviceDiscoverySession(deviceTypes: [AVCaptureDeviceType.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: AVCaptureDevicePosition.front)
        
        let devices = deviceDiscoverySession?.devices
        
        if let unwrappedDevices = devices {
            if !unwrappedDevices.isEmpty {
                frontCameraDevice = unwrappedDevices[0]
                
                if frontCameraDevice != nil {
                    do {
                        frontCameraInput = try AVCaptureDeviceInput(device: frontCameraDevice)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            
        }
        
        // Get back camera input ready
        do {
            backCameraInput = try AVCaptureDeviceInput(device: backCameraDevice)
        } catch {
            print(error.localizedDescription)
        }
        
        // Add camera input to session
        if frontCameraInput != nil && backCameraInput != nil {
            switch currentCamera {
            case .front:
                session.addInput(frontCameraInput)
            case .back:
                session.addInput(backCameraInput)
            }
        }

        cameraCaptureOutput = AVCaptureMovieFileOutput()
        session.addOutput(cameraCaptureOutput)
        
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
        
        if frontCameraInput != nil && backCameraInput != nil {
            switch currentCamera {
            case .back:
                session.removeInput(backCameraInput)
                session.addInput(frontCameraInput)
                currentCamera = .front
            case .front:
                session.removeInput(frontCameraInput)
                session.addInput(backCameraInput)
                currentCamera = .back
            }
        }
        
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







