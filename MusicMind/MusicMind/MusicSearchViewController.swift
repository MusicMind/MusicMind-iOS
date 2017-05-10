//
//  MusicSearchViewController.swift
//  MusicMind
//
//  Created by Ryan Boyd on 3/19/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit
import Alamofire
import AVKit
import AVFoundation

class MusicSearchViewController: UIViewController {
    
    var searchResults = [String: Any]()
    var totalNumberOfSongFromResults: Int = 0
    var audioPlayer = AVAudioPlayer()
    
    
    @IBOutlet weak var playPause: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    

    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup gesture recognizer
        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(MusicSearchViewController.edgeGestureAction(sender:)))
        edgeGesture.edges = UIRectEdge.right
        view.addGestureRecognizer(edgeGesture)
     
        // Other setups
        hideKeyboardWhenTappedAround()
        searchBar.keyboardAppearance = .dark
        
        // Set delegates
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        spotifyStreamingController.delegate = self
    }
    
    deinit {
        spotifyStreamingController.delegate = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let session = spotifyAuth.session {
            if session.isValid() {
                if spotifyStreamingController.loggedIn {
                    print("Already loggedin to spotifyStreamingController")
                } else {
                    spotifyStreamingController.login(withAccessToken: session.accessToken)
                }
            } else {
                presentSpotifyLoginAlert()
            }
        } else {
            presentSpotifyLoginAlert()
        }
    }
    
    private func presentSpotifyLoginAlert() {
        let alert = UIAlertController(title: "Spotify Log In", message: "You need to login with your Spotify Premium account in order to play songs.", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alertAction) in
            self.dismiss(animated: true, completion: nil)
            
        }
        let login = UIAlertAction(title: "Go to Spotify", style: .default) { (alertAction) in
            if let spotifyUrl = SPTAuth.defaultInstance().spotifyWebAuthenticationURL() {
                UIApplication.shared.open(spotifyUrl, options: [:])
            }
        }
        
        alert.addAction(cancel)
        alert.addAction(login)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func edgeGestureAction(sender: UIScreenEdgePanGestureRecognizer) {
        switch sender.state {
        case .began:
            self.dismiss(animated: true, completion: nil)
        default:
            break
        }
    }

    
    // MARK: - Setups and helpers
    
    func convertStringToDictionary(text: String) -> [String:Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
}

//func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//    let keywords = searchBar.text
//    let finalKeywords = keywords?.replacingOccurrences(of: " ", with: "+")
//    searchURL = "https://api.spotify.com/v1/search?q=\(finalKeywords!)&type=track"
//    callAlamo(url: searchURL)
//    self.view.endEditing(true)
//}


extension MusicSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if spotifyStreamingController.loggedIn {
            
        }
        
        let keywords = searchBar.text
        let finalKeywords = keywords?.replacingOccurrences(of: " ", with: "+")
        let searchURL = "https://api.spotify.com/v1/search?q=\(finalKeywords!)&type=track"

        
        Alamofire.request(searchURL).responseString { response in
//            debugPrint(response)
            
            if let json = response.result.value {
                print("JSON: \(json)")
                
                if let dict = self.convertStringToDictionary(text: json ) {
                    self.searchResults = dict
                    
                    if let tracks = self.searchResults["tracks"] as? [String: Any] {
                        if let items = tracks["items"] as? [[String: Any]] {
                            self.totalNumberOfSongFromResults = items.count
                        }
                    }
                    
//                    debugPrint(self.searchResults)
                    
                    self.tableView?.reloadData()
                }
            }
        }
    }
    
}

extension MusicSearchViewController: SPTAudioStreamingDelegate {

    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        //
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didReceiveError error: Error!) {
        print("Audio streaming error: \(error.localizedDescription)")
    }
    
}

extension MusicSearchViewController: UITextViewDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

// MARK: - Table view delegates

extension MusicSearchViewController: UITableViewDelegate, UITableViewDataSource {
 
//    func downloadFileFromURL(url: URL) {
//        print(url)
//        var downloadTask = URLSessionDownloadTask()
//        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: {
//            customURL, response, error in
//            print(customURL)
//            self.play(url: customURL!)
//        })
//        
//        downloadTask.resume()
//    }
//    
//    func play(url: URL) {
//        
//        do {
//            audioPlayer = try AVAudioPlayer(contentsOf: url)
//            audioPlayer.prepareToPlay()
//            audioPlayer.play()
//        }
//        catch {
//            print(error)
//        }
//    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tracks = self.searchResults["tracks"] as? [String: Any] {
            if let items = tracks["items"] as? [[String: Any]] {
                let index = items[indexPath.row]
                let trackURI = index["uri"] as? String
                let preview = index["preview_url"]
           
                
//                self.downloadFileFromURL(url: URL(string: trackURI! as! String)!)
//                    play(url: URL(string: trackURI!)!)
//                playPause.setTitle("Pause", for: .normal)

                spotifyStreamingController.playSpotifyURI(trackURI, startingWith: 0, startingWithPosition: 0) {
                    error in
                    if error != nil {
                        print(error!.localizedDescription)
                        return
                    }
                }
            }
        }
    }
    
    
        @IBAction func playPauseAction(_ sender: Any) {
    
          spotifyStreamingController.setIsPlaying(false, callback: nil)
        }
    
    
  
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalNumberOfSongFromResults
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let tracks = self.searchResults["tracks"] as? [String: Any] {
            if let items = tracks["items"] as? [[String: Any]] {
                let index = items[indexPath.row]
                
                
                let songLabel = cell.viewWithTag(4) as! UILabel
                songLabel.text = index["name"] as? String
                
                if let album = index["album"] as? [String: Any] {
                    
                    if let artist = album["artists"] as? [[String: Any]] {
                        let artistLabel = cell.viewWithTag(3) as! UILabel
                        artistLabel.text = artist[0]["name"] as? String
                    }
                    
                    if let image = album["images"] as? [[String: Any]] {
                        let smallImage = image[2]
                        let urlString = smallImage["url"] as? String
                        
                        if let url  = NSURL(string: urlString!){
                            if let data = NSData(contentsOf: url as URL){
                                
                                let backgroundImage = cell.viewWithTag(1) as! UIImageView
                                backgroundImage.image = UIImage(data: data as Data)
                                
                                let mainImage = cell.viewWithTag(2) as! UIImageView
                                mainImage.image = UIImage(data: data as Data)
                            }
                        }

                    }
                }

            }
        }
        
        return cell
    }

}
