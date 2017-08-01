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
    var breakFromVideo: Bool?
    var backCameraDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) // default is always back camera
    var backCameraInput: AVCaptureDeviceInput?
    var frontCameraDevice: AVCaptureDevice?
    var frontCameraInput: AVCaptureDeviceInput?
    var microphoneAudioDevice: AVCaptureDevice?
    var microphoneAudioInput: AVCaptureDeviceInput?
    var counter: Int?
    var counter1: Int?
    var counter2: Int?
    var duration: Double?
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!

    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup gesture recognizer
//        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(CameraCaptureViewController.edgeGestureAction(sender:)))
//        edgeGesture.edges = UIRectEdge.left
//        view.addGestureRecognizer(edgeGesture)
       
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
        let sess = AVAudioSession.sharedInstance()
        if sess.isOtherAudioPlaying {
            _ = try? sess.setCategory(AVAudioSessionCategoryAmbient, with: .duckOthers)
            _ = try? sess.setActive(true, with: [])
        }
        setupMicCaptureSession()

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
    
//    func edgeGestureAction(sender: UIScreenEdgePanGestureRecognizer) {
//        switch sender.state {
//        case .began:
//            performSegue(withIdentifier: "showMusicSearchViewContoller", sender: self)
//        default:
//            // pass down for the interaction controller to handle the rest of these cases
//           break
//        }
//    }
    
    func configureDevice() {
        if let device = captureDevice {
            device.lockForConfiguration(nil)
            device.focusMode = .Locked
            device.unlockForConfiguration()
        }
    }
    // Get microphone devices
    func setupMicCaptureSession() {
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
        counter = 0
        counter1 = 0
        counter2 = 0
        breakFromVideo = false
        recordButton.setProgress(recordingProgressFraction)
        setupMicCaptureSession()
        cameraCaptureOutput?.startRecording(toOutputFileURL: newMovieFileUrl, recordingDelegate: self)
        
        recordingProgressTimer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(self.recordingInProgressUpdater), userInfo: nil, repeats: true)
    }
    
    func stopRecordingVideo() {
        if counter2 == 0 {
            duration = cameraCaptureOutput!.recordedDuration.seconds
            counter2! += 1
        }
        print(cameraCaptureOutput!.recordedDuration.seconds)
        if let cameraCaptureOutput = cameraCaptureOutput {
            if cameraCaptureOutput.isRecording {
                cameraCaptureOutput.stopRecording()
            }
        }
        if duration! < 0.50 && duration! > 0.0 {
            //session.removeOutput(cameraCaptureOutput)
            //if counter1! == 0 {
                let settings = AVCapturePhotoSettings()
                breakFromVideo = true
                cameraCapturePicture?.capturePhoto(with: settings, delegate: self)
            //}
            //counter! += 1
        } else {
            //session.removeOutput(cameraCapturePicture)
        }
        self.recordingProgressTimer?.invalidate()
        recordingProgressFraction = 0.0
        recordButton.setProgress(recordingProgressFraction)
        recordButton.buttonState = .idle
    }
    
    // MARK: - Navigation
    
    fileprivate func navigateToPostProcessingViewController(movieURL: URL) {
        print(breakFromVideo!)
        if breakFromVideo! {
            return
        }
        let postProcessingViewController = UIStoryboard(name: "PostProcessing", bundle: nil).instantiateViewController(withIdentifier: "PostProcessingViewController") as! PostProcessingViewController
        
        postProcessingViewController.useImage = false
        postProcessingViewController.localUrlOfOriginalVideo = movieURL
        postProcessingViewController.localUrlOfOriginalImage = nil
        
        self.navigationController?.pushViewController(postProcessingViewController, animated: true)
    }
    
    fileprivate func navigateToPostProcessingViewController(photo: UIImage) {
    let postProcessingViewController = UIStoryboard(name: "PostProcessing", bundle: nil).instantiateViewController(withIdentifier: "PostProcessingViewController") as! PostProcessingViewController

        postProcessingViewController.useImage = true
        postProcessingViewController.localUrlOfOriginalImage = photo
        postProcessingViewController.localUrlOfOriginalVideo = nil
        
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

func rotateCameraImageToProperOrientation(imageSource : UIImage, maxResolution : CGFloat) -> UIImage {
    
    guard let imgRef = imageSource.cgImage else {
        return imageSource
    }
    
    let width = CGFloat(imgRef.width);
    let height = CGFloat(imgRef.height);
    
    var bounds = CGRect(x: 0, y: 0, width: width, height: height)
    
    var scaleRatio : CGFloat = 1
    if (width > maxResolution || height > maxResolution) {
        
        scaleRatio = min(maxResolution / bounds.size.width, maxResolution / bounds.size.height)
        bounds.size.height = bounds.size.height * scaleRatio
        bounds.size.width = bounds.size.width * scaleRatio
    }
    
    var transform = CGAffineTransform.identity
    let orient = imageSource.imageOrientation
    let imageSize = CGSize(width: CGFloat(imgRef.width), height: CGFloat(imgRef.height))
    
    
    switch(imageSource.imageOrientation) {
    case .up :
        transform = CGAffineTransform.identity
        
    case .upMirrored :
        transform = CGAffineTransform(translationX: imageSize.width, y: 0.0)
        transform = transform.scaledBy(x: -1.0, y: 1.0)
        
    case .down :
        transform = CGAffineTransform(translationX: imageSize.width, y: imageSize.height)
        transform = transform.rotated(by: CGFloat(M_PI))
        
    case .downMirrored :
        transform = CGAffineTransform(translationX: 0.0, y: imageSize.height)
        transform = transform.scaledBy(x: 1.0, y: -1.0)
        
    case .left :
        let storedHeight = bounds.size.height
        bounds.size.height = bounds.size.width
        bounds.size.width = storedHeight
        transform = CGAffineTransform(translationX: 0.0, y: imageSize.width)
        transform = transform.rotated(by: 3.0 * CGFloat(M_PI) / 2.0)
        
    case .leftMirrored :
        let storedHeight = bounds.size.height
        bounds.size.height = bounds.size.width
        bounds.size.width = storedHeight
        transform = CGAffineTransform(translationX: imageSize.height, y: imageSize.width)
        transform = transform.scaledBy(x: -1.0, y: 1.0)
        transform = transform.rotated(by: 3.0 * CGFloat(M_PI) / 2.0)
        
    case .right :
        let storedHeight = bounds.size.height
        bounds.size.height = bounds.size.width
        bounds.size.width = storedHeight
        transform = CGAffineTransform(translationX: imageSize.height, y: 0.0)
        transform = transform.rotated(by: CGFloat(M_PI) / 2.0)
        
    case .rightMirrored :
        let storedHeight = bounds.size.height
        bounds.size.height = bounds.size.width
        bounds.size.width = storedHeight
        transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        transform = transform.rotated(by: CGFloat(M_PI) / 2.0)
    }
    
    UIGraphicsBeginImageContext(bounds.size)
    guard let context = UIGraphicsGetCurrentContext() else {
        return imageSource
    }
    
    if orient == .right || orient == .left {
        context.scaleBy(x: -scaleRatio, y: scaleRatio)
        context.translateBy(x: -height, y: 0)
    } else {
        context.scaleBy(x: scaleRatio, y: -scaleRatio)
        context.translateBy(x: 0, y: -height)
    }
    
    context.concatenate(transform);
    context.draw(imgRef, in: CGRect(x: 0, y: 0, width: width, height: height))
    
    guard let imageCopy = UIGraphicsGetImageFromCurrentImageContext() else {
        return imageSource
    }
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

extension CameraCaptureViewController: AVCaptureFileOutputRecordingDelegate, AVCapturePhotoCaptureDelegate {
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAt outputFileURL: URL!, fromConnections connections: [Any]!, error: Error!) {
        print(breakFromVideo)
        if !breakFromVideo! {
            if counter == 0 {
                counter! += 1
                navigateToPostProcessingViewController(movieURL: newMovieFileUrl)
            }
        }
    }
    
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if counter == 0 {
            counter! += 1
            navigateToPostProcessingViewController(photo: UIImage(data: AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer)!)!)
        }
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







