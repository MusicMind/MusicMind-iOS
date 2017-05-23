//
//  PlaylistTracksViewController.swift
//  MusicMind
//
//  Created by Rich Ruais on 5/18/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit
import Alamofire

var playlistTracksTableView = UITableView()

class PlaylistTracksViewController: UIViewController {
    
    var playlistName = String()
    var playlistTrackCount = String()
    var playlistImage = UIImage()
    var backgroundImage = UIImage()
    var playlistId = String()
    let ssh = SpotifySearchHelpers()
    
    @IBOutlet weak var playlistImageView: UIImageView!
    @IBOutlet weak var playlistNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playlistTracksTableView = tableView
        tableView.delegate = self
        tableView.dataSource = self
        
        playlistImageView.image = playlistImage
        playlistNameLabel.text = playlistName
        let playlistTracksUrl = "https://api.spotify.com/v1/users/\(currentSpotifyUser.id!)/playlists/\(playlistId)/tracks"
        print("URL*************************        \(playlistTracksUrl)")
        getPlaylistTracks(url: playlistTracksUrl)
    }
    
    @IBAction func back(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    
    
    func getPlaylistTracks(url: String) {
        Alamofire.request(url, headers: ["Authorization": "Bearer " + spotifyAuth.session.accessToken]).responseJSON(completionHandler: {
            response in
            self.parseUserPlaylistTracks(JSONData: response.data!)
        })
    }
    
    func parseUserPlaylistTracks(JSONData: Data) {
        currentTracksInQueue.removeAll()
        playerQueue.removeAll()
        let tempArr = ssh.parseUserPlaylistTracks(JSONData: JSONData)
        for i in 0..<tempArr.count {
            currentTracksInQueue.append(tempArr[i])
        }
        playerQueue = currentTracksInQueue
        self.tableView.reloadData()
    }

    
   
} // End Class

extension PlaylistTracksViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentTracksInQueue.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playlistTrackCell", for: indexPath)
        let songLabel = cell.viewWithTag(2) as! UILabel
        songLabel.text = currentTracksInQueue[indexPath.row].songTitle
        let artistLabel = cell.viewWithTag(1) as! UILabel
        artistLabel.text = currentTracksInQueue[indexPath.row].artist
        let backgroundImage = cell.viewWithTag(4) as! UIImageView
        backgroundImage.image = currentTracksInQueue[indexPath.row].largeAlbumImage
        let mainImage = cell.viewWithTag(3) as! UIImageView
        mainImage.image = currentTracksInQueue[indexPath.row].largeAlbumImage

        return cell
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
        var count = 0
        for i in indexPath.row..<playerQueue.count {
            let index = playerQueue[i]
            playerQueue.remove(at: i)
            playerQueue.insert(index, at: count)
            count += 1
        }
        let spotifyPlayer = SpotifyPlayerViewController()
        spotifyPlayer.playSpotify(uri: uri!)
    }


}
