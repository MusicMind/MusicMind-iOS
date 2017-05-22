//
//  AlbumTracksViewController.swift
//  MusicMind
//
//  Created by Rich Ruais on 5/21/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit

import UIKit
import Alamofire

var albumTracksTableView = UITableView()

class AlbumTracksViewController: UIViewController {
    
    let ssh = SpotifySearchHelpers()
    var currentAlbumDetails: album!
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        albumTracksTableView = tableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.black
        albumImageView.image = currentAlbumDetails.largeImage
        albumNameLabel.text = currentAlbumDetails.name
        artistNameLabel.text = currentAlbumDetails.artistName
        let albumTracksUrl = "https://api.spotify.com/v1/albums/\(currentAlbumDetails.id!)/tracks"
        getAlbumTracks(url: albumTracksUrl)
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func getAlbumTracks(url: String) {
        Alamofire.request(url, headers: ["Authorization": "Bearer " + spotifyAuth.session.accessToken]).responseJSON(completionHandler: {
            response in
            self.parseAlbumTracks(JSONData: response.data!)
        })
    }
    
    func parseAlbumTracks(JSONData: Data) {
        currentTracksInQueue.removeAll()
        var tempArr = ssh.parseAlbumTrackData(JSONData: JSONData)
        for i in 0..<tempArr.count {
            tempArr[i].largeAlbumImage = currentAlbumDetails.largeImage
            tempArr[i].smallAlbumImage = currentAlbumDetails.smallImage
            tempArr[i].albumName = currentAlbumDetails.name
            currentTracksInQueue.append(tempArr[i])
        }
        self.tableView.reloadData()
    }
    
    
    
} // End Class

extension AlbumTracksViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source
    
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
        let artistAlbumLabel = cell.viewWithTag(3) as! UILabel
        artistAlbumLabel.text = "\(currentTracksInQueue[indexPath.row].artist!) * \(currentTracksInQueue[indexPath.row].albumName!)"
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 55
        }
        return 50
    }
    
    
}
