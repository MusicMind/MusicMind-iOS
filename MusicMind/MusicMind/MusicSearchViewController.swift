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

struct track {
    let artist: String!
    let songTitle: String!
    let largeAlbumImage: UIImage!
    let smallAlbumImage: UIImage!
    let albumName: String!
    let uri: String!
    let duration: Int!
}

var currentTrackDetails: track!
var currentTracksInQueue = [track]()


class MusicSearchViewController: UIViewController {
    
    var searchResults = [String: Any]()
    var backgroundImage = UIImage()
    var currentSearchWords: String = ""
    var scrollToRefreshCount = 10
    var spotifyTableView = UITableView()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    // MARK: - View controller lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spotifyTableView = tableView
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
    
    // Spotify Alerts
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


extension MusicSearchViewController: UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        currentTracksInQueue.removeAll()
        scrollToRefreshCount = 10
        let keywords = searchBar.text
        let finalKeywords = keywords?.replacingOccurrences(of: " ", with: "+")
        currentSearchWords = finalKeywords!
        let searchURL = "https://api.spotify.com/v1/search?q=\(finalKeywords!)&type=track&limit=10"
        callAlamo(url: searchURL)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if spotifyStreamingController.loggedIn {
        }
      
    }

    func callAlamo(url: String) {
        Alamofire.request(url).responseJSON(completionHandler: {
            response in
            self.parseData(JSONData: response.data!)
        })
    }
    
    func parseData(JSONData : Data) {
        do {
            var readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! [String : AnyObject]
            if let tracks = readableJSON["tracks"] as? [String : AnyObject]{
                if let items = tracks["items"] as? NSArray {
                    currentTracksInQueue.removeAll()
                    for i in 0..<items.count  {
                        let item = items[i] as! [String : Any]
                        let songTitle = item["name"] as! String
                        let trackURI = item["uri"] as? String
                        let duration = item["duration_ms"] as? Int
                        if let album = item["album"] as? [String : AnyObject] {
                            let albumName = album["name"] as? String
                            if let artist = album["artists"] as? [[String: Any]] {
                                let artistName = (artist[0]["name"] as? String)!
                                if let images = album["images"] as? [[String : AnyObject]] {
                                    let largeImage = images[0]
                                    let largeImageURL = URL(string:largeImage["url"] as! String)
                                    let largeImageData = NSData(contentsOf: largeImageURL!)
                                    let largeAlbumImage = UIImage(data: largeImageData! as Data)
                                    let smallImage = images[2]
                                    let smallImageURL = URL(string:smallImage["url"] as! String)
                                    let smallImageData = NSData(contentsOf: smallImageURL!)
                                    let smallAlbumImage = UIImage(data: smallImageData! as Data)
                                    currentTracksInQueue.append(track.init(artist: artistName, songTitle: songTitle, largeAlbumImage: largeAlbumImage, smallAlbumImage: smallAlbumImage, albumName: albumName, uri: trackURI, duration: duration))
                                      self.tableView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let songTitle = currentTracksInQueue[indexPath.row].songTitle
        let artist = currentTracksInQueue[indexPath.row].artist
        let largeAlbumImage = currentTracksInQueue[indexPath.row].largeAlbumImage
        let uri = currentTracksInQueue[indexPath.row].uri
        let smallAlbumImage = currentTracksInQueue[indexPath.row].smallAlbumImage
        let albumName = currentTracksInQueue[indexPath.row].albumName
        let duration = currentTracksInQueue[indexPath.row].duration
        
        let newTrack = track.init(artist: artist, songTitle: songTitle, largeAlbumImage: largeAlbumImage, smallAlbumImage: smallAlbumImage, albumName: albumName, uri: uri, duration: duration)

        currentTrackDetails = newTrack
        print("Tracks In Queue  \(currentTracksInQueue.count)")
        currentTracksInQueue.remove(at: indexPath.row)
        currentTracksInQueue.insert(currentTrackDetails, at: 0)
        print("Tracks In Queue  \(currentTracksInQueue.count)")
        let spotifyPlayer = SpotifyPlayerViewController()
        spotifyPlayer.playSpotify(uri: uri!)

    }
    
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentTracksInQueue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let songLabel = cell.viewWithTag(4) as! UILabel
        songLabel.text = currentTracksInQueue[indexPath.row].songTitle
        let artistLabel = cell.viewWithTag(3) as! UILabel
        artistLabel.text = currentTracksInQueue[indexPath.row].artist
        let backgroundImage = cell.viewWithTag(1) as! UIImageView
        backgroundImage.image = currentTracksInQueue[indexPath.row].largeAlbumImage
        let mainImage = cell.viewWithTag(2) as! UIImageView
        mainImage.image = currentTracksInQueue[indexPath.row].largeAlbumImage

        return cell
    }
   
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
        {
            print("Scrolled toEnd")
            let searchURL = "https://api.spotify.com/v1/search?q=\(currentSearchWords)&type=track&limit=10&offset=\(scrollToRefreshCount)"
            callAlamo(url: searchURL)
            tableView.reloadData()
            scrollToRefreshCount += 10
        }
    }

}
