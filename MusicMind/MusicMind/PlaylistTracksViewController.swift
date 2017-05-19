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
        print("URL*************************\(playlistTracksUrl)")
        getPlaylistTracks(url: playlistTracksUrl)
    }
    
    @IBAction func back(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }
    
    
    func getPlaylistTracks(url: String) {
        Alamofire.request(url, headers: ["Authorization": "Bearer " + spotifyAuth.session.accessToken]).responseJSON(completionHandler: {
            response in
            self.parseData(JSONData: response.data!)
        })
    }
    
    func parseData(JSONData : Data) {
        do {
            var readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! [String : AnyObject]
            let items = readableJSON["items"] as! NSArray
//            print("Items          \(items)")
            currentTracksInQueue.removeAll()
            for i in 0..<items.count {
                let item = items[i] as! [String : Any]
                if let addedBy = item["added_by"] as? [String : Any] {
                    let playlistCreatedBy = addedBy["id"]
                    print("Added_By Id            \(playlistCreatedBy!)")
                    if let tracks = item["track"] as? [String : Any] {
                        print("Track      \(tracks)")
                        if let album = tracks["album"] as? [String : AnyObject] {
                            print("Album     \(album)")
                            if let artist = album["artists"] as? [[String: Any]] {
                                let artistName = (artist[0]["name"] as? String)!
                                print("ArtistName      \(artistName)")
                                let songTitle = tracks["name"] as! String
                                let trackURI = tracks["uri"] as? String
                                let duration = tracks["duration_ms"] as? Int
                                let albumName = album["name"] as! String
                                if let images = album["images"] as? [[String : AnyObject]] {
                                    let largeImage = images[0]
                                    let largeImageURL = URL(string:largeImage["url"] as! String)
                                    let largeImageData = NSData(contentsOf: largeImageURL!)
                                    let largeAlbumImage = UIImage(data: largeImageData! as Data)
                                    let smallImage = images[2]
                                    let smallImageURL = URL(string:smallImage["url"] as! String)
                                    let smallImageData = NSData(contentsOf: smallImageURL!)
                                    let smallAlbumImage = UIImage(data: smallImageData! as Data)
                                    var newTrack = track.init(artist: artistName, songTitle: songTitle, largeAlbumImage: largeAlbumImage, smallAlbumImage: smallAlbumImage, albumName: albumName, uri: trackURI, duration: duration)
                                    currentTracksInQueue.append(newTrack)
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
        print("Tracks In Queue  \(currentTracksInQueue.count)")
        currentTracksInQueue.remove(at: indexPath.row)
        currentTracksInQueue.insert(currentTrackDetails, at: 0)
        print("Tracks In Queue  \(currentTracksInQueue.count)")
        let spotifyPlayer = SpotifyPlayerViewController()
        spotifyPlayer.playSpotify(uri: uri!)
    }


}
