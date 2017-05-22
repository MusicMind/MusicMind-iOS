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
    var artist: String!
    var songTitle: String!
    var largeAlbumImage: UIImage!
    var smallAlbumImage: UIImage!
    var albumName: String!
    var uri: String!
    var duration: Int!
}

struct album {
    let name: String!
    let smallImage: UIImage!
    let largeImage: UIImage!
    let artistName: String!
    let id: String!
}

var currentTrackDetails: track!
var currentTracksInQueue = [track]()
var playerQueue = [track]()
var albumList = [album]()

class MusicSearchViewController: UIViewController {
    
    var searchResults = [String: Any]()
    var backgroundImage = UIImage()
    var currentSearchWords: String = ""
    var scrollToRefreshCount = 10
    var spotifyTableView = UITableView()
    let ssh = SpotifySearchHelpers()
    var currentAlbumDetails: album!
    
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
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.black
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
        let searchTrackURL = "https://api.spotify.com/v1/search?q=\(finalKeywords!)&type=track&limit=4"
        let searchAlbumURL = "https://api.spotify.com/v1/search?q=\(self.currentSearchWords)&type=album&limit=4"
        searchTrack(url: searchTrackURL)
        searchAlbum(url: searchAlbumURL)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if spotifyStreamingController.loggedIn {
        }
      
    }

    func searchTrack(url: String) {
        Alamofire.request(url).responseJSON(completionHandler: {
            response in
            self.parseTrackData(JSONData: response.data!)
        })
    }
    
    func parseTrackData(JSONData : Data) {
        let tempArr = ssh.parseTrackData(JSONData: JSONData)
        print(tempArr)
        for i in 0..<tempArr.count {
            currentTracksInQueue.append(tempArr[i])
        }
        self.tableView.reloadData()
    }
    
    func searchAlbum(url: String) {
        Alamofire.request(url).responseJSON(completionHandler: {
            response in
            self.parseAlbumData(JSONData: response.data!)
        })
    }
    
    func parseAlbumData(JSONData: Data) {
        let tempArr = ssh.parseAlbumData(JSONData: JSONData)
        print(tempArr)
        for i in 0..<tempArr.count {
            albumList.append(tempArr[i])
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row < currentTracksInQueue.count {
                let songTitle = currentTracksInQueue[indexPath.row].songTitle
                let artist = currentTracksInQueue[indexPath.row].artist
                let largeAlbumImage = currentTracksInQueue[indexPath.row].largeAlbumImage
                let uri = currentTracksInQueue[indexPath.row].uri
                let smallAlbumImage = currentTracksInQueue[indexPath.row].smallAlbumImage
                let albumName = currentTracksInQueue[indexPath.row].albumName
                let duration = currentTracksInQueue[indexPath.row].duration
            
                let newTrack = track.init(artist: artist, songTitle: songTitle, largeAlbumImage: largeAlbumImage, smallAlbumImage: smallAlbumImage, albumName: albumName, uri: uri, duration: duration)
                
                currentTrackDetails = newTrack
                playerQueue = currentTracksInQueue
                playerQueue.remove(at: indexPath.row)
                playerQueue.insert(currentTrackDetails, at: 0)
                
                let spotifyPlayer = SpotifyPlayerViewController()
                spotifyPlayer.playSpotify(uri: uri!)
                self.tableView.reloadData()

            }
        } else if indexPath.section == 1 {
            self.performSegue(withIdentifier: "allSongsSegue", sender: indexPath);
        } else if indexPath.section == 2 {
            if indexPath.row < albumList.count {
        }
        } else if indexPath.section == 3 {
             self.performSegue(withIdentifier: "allAlbumsSegue", sender: indexPath);
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = tableView.dequeueReusableCell(withIdentifier: "songsHeader")!
            return header.contentView
        } else if section == 2 {
            let header = tableView.dequeueReusableCell(withIdentifier: "albumsHeader")!
            return header.contentView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 45
        }
        if section == 1 {
            return 0.0001
        }
        if section == 2 {
            return 45
        }
        if section == 3 {
            return 0.0001
        }
            return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return currentTracksInQueue.count
        }
        if section == 1 {
            return 1
        }
        if section == 2 {
            return albumList.count
        }
        if section == 3 {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row < currentTracksInQueue.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                let songLabel = cell.viewWithTag(4) as! UILabel
                songLabel.text = currentTracksInQueue[indexPath.row].songTitle
                let artistAlbumLabel = cell.viewWithTag(3) as! UILabel
                artistAlbumLabel.text = "\(currentTracksInQueue[indexPath.row].artist!) * \(currentTracksInQueue[indexPath.row].albumName!)"
                return cell
            }
        }
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "viewAllSongs", for: indexPath)
            return cell
        }
        if indexPath.section == 2 {
            if indexPath.row < albumList.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "album", for: indexPath)
                let albumImage = cell.viewWithTag(1) as! UIImageView
                albumImage.image  = albumList[indexPath.row].smallImage
                let artistName = cell.viewWithTag(2) as! UILabel
                artistName.text = albumList[indexPath.row].artistName
                let albumName = cell.viewWithTag(3) as! UILabel
                albumName.text = albumList[indexPath.row].name
                return cell
            }
        }
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "viewAllAlbums", for: indexPath)
            return cell
        }
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 55
        }
        if indexPath.section == 1 {
            return 55
        }
        return 60
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "allSongsSegue" {
            let vc = segue.destination
                as! AllSongsViewController
            vc.search = currentSearchWords
        }
        if segue.identifier == "allAlbumsSegue" {
            let vc = segue.destination
                as! AlbumsCollectionViewController
            vc.search = currentSearchWords
        }
        if segue.identifier == "showAlbumTracks" {
            let vc = segue.destination
                as! AlbumTracksViewController
            let indexPath = self.tableView.indexPathForSelectedRow!
            let name = albumList[indexPath.row].name
            let smallImage = albumList[indexPath.row].smallImage
            let largeImage = albumList[indexPath.row].largeImage
            let artistName = albumList[indexPath.row].artistName
            let id = albumList[indexPath.row].id
            let newAlbum = album.init(name: name, smallImage: smallImage, largeImage: largeImage, artistName: artistName, id: id)
            vc.currentAlbumDetails = newAlbum
        }
    }
}
