//
//  ACViewController.swift
//  
//
//  Created by Rich Ruais on 5/10/17.
//
//

import UIKit

class ACViewController: UIViewController {
    
    var backgroundImage = UIImage()
    var mainImage = UIImage()
    var mainSongTitle = String()
    var mainArtistName = String()

    @IBOutlet weak var backgroundImageBlurred: UIImageView!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var playPauseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageBlurred.image = backgroundImage
        albumImage.image = mainImage
        songTitle.text = mainSongTitle
        artistName.text = mainArtistName
        
        playPauseButton.setTitle("Pause", for: .normal)
        
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
    
    @IBAction func playPauseAction(_ sender: Any) {
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
