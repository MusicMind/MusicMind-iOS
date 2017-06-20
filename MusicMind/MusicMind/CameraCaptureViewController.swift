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
import Firebase

fileprivate enum CurrentCamera {
    case front
    case back
}

final class CameraCaptureViewController: UIViewController {
    
    @IBOutlet private weak var cameraPreviewView: UIView!
    @IBOutlet private weak var libraryButton: UIButton!
    @IBOutlet private weak var recordButton: RecordButton!
    fileprivate let newMovieFileUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("movie.mov")
    private var recordingProgressTimer: Timer?
    var recordingProgressFraction: CGFloat! = 0
    
    // AV capturing objects
    fileprivate var currentCamera = CurrentCamera.front
    let session = AVCaptureSession()
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var cameraCaptureOutput: AVCaptureMovieFileOutput?
    var cameraCapturePicture: AVCapturePhotoOutput?
    var backCameraDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) // default is always back camera
    var backCameraInput: AVCaptureDeviceInput?
    var frontCameraDevice: AVCaptureDevice?
    var frontCameraInput: AVCaptureDeviceInput?
    var microphoneAudioDevice: AVCaptureDevice?
    var microphoneAudioInput: AVCaptureDeviceInput?

    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup gesture recognizer
        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(CameraCaptureViewController.edgeGestureAction(sender:)))
        edgeGesture.edges = UIRectEdge.left
        view.addGestureRecognizer(edgeGesture)
       
        // Setup record button
        recordButton.buttonColor = .white
        recordButton.progressColor = .red
        recordButton.closeWhenFinished = false
        recordButton.addTarget(self, action: #selector(self.startRecordingVideo), for: .touchDown)
        recordButton.addTarget(self, action: #selector(self.stopRecordingVideo), for: UIControlEvents.touchUpInside)
        recordButton.addTarget(self, action: #selector(self.stopRecordingVideo), for: UIControlEvents.touchDragExit)
        self.view.addSubview(recordButton)
        
        // Other setups
        setupCaptureSession()
        setupNavigationBar(theme: .light)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopRecordingVideo()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func edgeGestureAction(sender: UIScreenEdgePanGestureRecognizer) {
        switch sender.state {
        case .began:
            performSegue(withIdentifier: "showMusicSearchViewContoller", sender: self)
        default:
            // pass down for the interaction controller to handle the rest of these cases
           break
        }
    }
    
    
    // MARK: - AV Capturing

    func setupCaptureSession() {
        session.sessionPreset = AVCaptureSessionPresetHigh
        
        // Get front camera device and inputs
        let cameraDeviceDiscoverySession = AVCaptureDeviceDiscoverySession(deviceTypes: [AVCaptureDeviceType.builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: AVCaptureDevicePosition.front)
        
        let cameraDevices = cameraDeviceDiscoverySession?.devices
        
        if let unwrappedDevices = cameraDevices {
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
        
        // Get microphone devices

        let microphoneDeviceDiscoberySession = AVCaptureDeviceDiscoverySession(deviceTypes: [AVCaptureDeviceType.builtInMicrophone], mediaType: AVMediaTypeAudio, position: AVCaptureDevicePosition.unspecified)
        
        let microphoneDevices = microphoneDeviceDiscoberySession?.devices
        
        if let unwrappedMicrophoneDevices = microphoneDevices {
            if !unwrappedMicrophoneDevices.isEmpty {
                microphoneAudioDevice = unwrappedMicrophoneDevices[0]
                
                do {
                    try microphoneAudioInput = AVCaptureDeviceInput(device: microphoneAudioDevice)
                    
                    if let unwrappedMicrophoneAudioInput = microphoneAudioInput {
                        if session.canAddInput(unwrappedMicrophoneAudioInput) {
                            session.addInput(unwrappedMicrophoneAudioInput)
                        }
                    }
                } catch {
                    print(error.localizedDescription)
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
                if session.canAddInput(frontCameraInput) {
                    session.addInput(frontCameraInput)
                }
            case .back:
                if session.canAddInput(backCameraInput) {
                    session.addInput(backCameraInput)
                }
            }
        }

        cameraCaptureOutput = AVCaptureMovieFileOutput()
        session.addOutput(cameraCaptureOutput)
        cameraCapturePicture = AVCapturePhotoOutput()
        session.addOutput(cameraCapturePicture)
        setupPreviewLayer()
        
        session.startRunning()
    }
    
    func setupPreviewLayer() {
        cameraPreviewView.layer.sublayers = nil
        
        if !UIApplication.isRunningOnSimulator {
            cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
            cameraPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            cameraPreviewLayer?.frame = cameraPreviewView.bounds
            cameraPreviewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.portrait
            
            cameraPreviewView.layer.addSublayer(cameraPreviewLayer!)
        }
    }
    
    // MARK: - Camera interaction
    
    @IBAction func flipCamera(_ sender: Any) {
        session.beginConfiguration()
        
        if frontCameraInput != nil && backCameraInput != nil {
            switch currentCamera {
            case .back:
                session.removeInput(backCameraInput)

                if session.canAddInput(frontCameraInput) {
                    session.addInput(frontCameraInput)
                    currentCamera = .front
                }
            case .front:
                session.removeInput(frontCameraInput)

                if session.canAddInput(backCameraInput) {
                    session.addInput(backCameraInput)
                    currentCamera = .back
                }
            }
        }
        
        setupPreviewLayer()

        session.commitConfiguration()
    }
    
    func recordingInProgressUpdater() {
        
        let maxDuration = CGFloat(14.9) // Max duration of the recordButton
        
        recordingProgressFraction = recordingProgressFraction + (CGFloat(0.05) / maxDuration)
        recordButton.setProgress(recordingProgressFraction)
        
        if recordingProgressFraction >= 1 {
            stopRecordingVideo()
        }
        
    }
    
    func startRecordingVideo() {
        recordingProgressFraction = 0.0
        recordButton.setProgress(recordingProgressFraction)
        
        cameraCaptureOutput?.startRecording(toOutputFileURL: newMovieFileUrl, recordingDelegate: self)
        
        recordingProgressTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.recordingInProgressUpdater), userInfo: nil, repeats: true)
    }
    
    func stopRecordingVideo() {
        if cameraCaptureOutput!.recordedDuration.seconds < 1.0 {
            let settings = AVCapturePhotoSettings()
            cameraCapturePicture?.capturePhoto(with: settings, delegate: self)
            session.removeOutput(cameraCaptureOutput)
        } else {
            session.removeOutput(cameraCapturePicture)
        }
        if let cameraCaptureOutput = cameraCaptureOutput {
            if cameraCaptureOutput.isRecording {
                cameraCaptureOutput.stopRecording()
            }
        }
        self.recordingProgressTimer?.invalidate()
        recordingProgressFraction = 0.0
        recordButton.setProgress(recordingProgressFraction)
        recordButton.buttonState = .idle
    }
    
    // MARK: - Navigation
    
    fileprivate func navigateToPostProcessingViewController(movieURL: URL) {
        let postProcessingViewController = UIStoryboard(name: "PostProcessing", bundle: nil).instantiateViewController(withIdentifier: "PostProcessingViewController") as! PostProcessingViewController
        
        postProcessingViewController.useImage = false
        postProcessingViewController.localUrlOfOriginalVideo = movieURL
        
        self.navigationController?.pushViewController(postProcessingViewController, animated: true)
    }
    
    fileprivate func navigateToPostProcessingViewController(photo: UIImage) {
    let postProcessingViewController = UIStoryboard(name: "PostProcessing", bundle: nil).instantiateViewController(withIdentifier: "PostProcessingViewController") as! PostProcessingViewController

        postProcessingViewController.useImage = true
        postProcessingViewController.localUrlOfOriginalImage = photo
        self.navigationController?.pushViewController(postProcessingViewController, animated: true)
    }
    
    @IBAction func presentSelectFromLibraryViewController(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeMovie as String, kUTTypeImage as String]
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
}
extension CameraCaptureViewController: AVCaptureFileOutputRecordingDelegate, AVCapturePhotoCaptureDelegate {
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        navigateToPostProcessingViewController(movieURL: newMovieFileUrl)
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        navigateToPostProcessingViewController(photo: UIImage(data: AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer)!)!)
    }

}

extension CameraCaptureViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let urlForMovie = info[UIImagePickerControllerMediaURL] as? URL {
            navigateToPostProcessingViewController(movieURL: urlForMovie)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}







