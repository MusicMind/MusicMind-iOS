//
//  ACViewController.swift
//  
//
//  Created by Rich Ruais on 5/10/17.
//
//

import UIKit
import Alamofire

class SpotifyPlayerViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageBlurred: UIImageView!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var minValueLabel: UILabel!
    @IBOutlet weak var maxValueLabel: UILabel!
    @IBOutlet weak var trackSeekSlider: UISlider!
    
    var timer: Timer!
    var pageIndex: Int = 0
    var bckImage: UIImage!
    var albumImagelrg: UIImage!
    var artist: String!
    var sngTitle: String!
    var album: String!
    var duration: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageBlurred.image = bckImage
        albumImage.image = albumImagelrg
        songTitle.text = sngTitle
        artistName.text = artist
        albumName.text = album
        let durationSeconds = duration / 1000
        let durationInterval = TimeInterval(durationSeconds)
        maxValueLabel.text = durationInterval.toMM_SS()
        self.trackSeekSlider.minimumValue = 0.00
        self.trackSeekSlider.maximumValue = Float(durationInterval)
        self.maxValueLabel.text = durationInterval.toMM_SS()
        
        
        playPauseButton.setTitle("Pause", for: .normal)

        if currentTrackDetails == nil {
            currentTrackDetails = currentTracksInQueue[0]
        }
        
        if (spotifyStreamingController.playbackState != nil) {
            if spotifyStreamingController.playbackState.isPlaying {
                timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
            }
        }
    }

    @IBAction func closeWindow(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

    func updateTime() {
        let currentTime = TimeInterval(spotifyStreamingController.playbackState.position)
        let convertedTime = currentTime.toMM_SS()
        minValueLabel.text = convertedTime
        trackSeekSlider.value = Float(currentTime)
    }
    

    func playSpotify(uri: String) {
        
        spotifyStreamingController.playSpotifyURI(uri, startingWith: 0, startingWithPosition: 0) {
            error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
    @IBAction func trackSeekStart(_ sender: UISlider) {
        spotifyPlayPause()
    }
    
    @IBAction func trackSeek(_ sender: UISlider) {
        spotifyStreamingController.seek(to: TimeInterval(sender.value)) {
            error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
        }
        spotifyPlayPause()
    }
    
    @IBAction func playPauseAction(_ sender: Any) {
        spotifyPlayPause()
    }
    
    func spotifyPlayPause() {
        if (spotifyStreamingController.playbackState != nil) {
            if spotifyStreamingController.playbackState.isPlaying == true {
                spotifyStreamingController.setIsPlaying(false) {
                    error in
                    if error != nil {
                        print(error!.localizedDescription)
                        return
                    }
                }
                playPauseButton.setTitle("Play", for: .normal)
                
            } else {
                spotifyStreamingController.setIsPlaying(true) {
                    error in
                    if error != nil {
                        print(error!.localizedDescription)
                        return
                    }
                }
                playPauseButton.setTitle("Pause", for: .normal)
            }
        }
    }
    
    @IBAction func fastForward(_ sender: UIButton) {
        spotifySeekForward()
    }
    
    func spotifySeekForward() {
        let currentPosition = spotifyStreamingController.playbackState.position
        spotifyStreamingController.seek(to: currentPosition + 1) {
            error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
        }
    }
    
    @IBAction func rewind(_ sender: UIButton) {
        spotifySeekRewind()
    }
    
    func spotifySeekRewind() {
        let currentPosition = spotifyStreamingController.playbackState.position
        spotifyStreamingController.seek(to: currentPosition - 1) {
            error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
        }
    }

    @IBAction func spotifyVolume(_ sender: UISlider) {
        let currentValue = Float(sender.value)
        spotifyStreamingController.setVolume(SPTVolume(currentValue)) {
            error in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
        }
    }
    

}// End ACViewController

extension TimeInterval {
    func toMM_SS() -> String {
        let interval = self
        let componentFormatter = DateComponentsFormatter()
        componentFormatter.unitsStyle = .positional
        componentFormatter.zeroFormattingBehavior = .pad
        componentFormatter.allowedUnits = [.minute, .second]
        return componentFormatter.string(from: interval) ?? ""
    }
}


