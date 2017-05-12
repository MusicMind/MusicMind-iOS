//
//  ACViewController.swift
//  
//
//  Created by Rich Ruais on 5/10/17.
//
//

import UIKit

class ACViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageBlurred: UIImageView!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var minValueLabel: UILabel!
    @IBOutlet weak var maxValueLabel: UILabel!
    @IBOutlet weak var trackSeekSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageBlurred.image = currentTrackDetails.albumImage
        albumImage.image = currentTrackDetails.albumImage
        songTitle.text = currentTrackDetails.songTitle
        artistName.text = currentTrackDetails.artist
        albumName.text = currentTrackDetails.albumName
        playPauseButton.setTitle("Pause", for: .normal)
        
        let currentTrackPosition = spotifyStreamingController.playbackState.position
        minValueLabel.text = String(describing: currentTrackPosition as? TimeInterval!)
        trackSeekSlider.minimumValue = 0
        trackSeekSlider.maximumValue = Float((spotifyStreamingController.metadata.currentTrack?.duration)!)
        
    }

    @IBAction func closeWindow(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func playSpotify(uri: String) {
        
        spotifyStreamingController.playSpotifyURI(uri, startingWith: 0, startingWithPosition: 0) {
            error in
            if error != nil {
                print(error!.localizedDescription)
                return
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
    

    
    

}
