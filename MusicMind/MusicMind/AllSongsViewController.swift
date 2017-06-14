//
//  AllSongsViewController.swift
//  MusicMind
//
//  Created by Rich Ruais on 5/20/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//


import UIKit
import Alamofire

class AllSongsViewController: UIViewController {
    
    var search = String()
    var scrollToRefreshCount = 10
    let ssh = SpotifySearchHelpers()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.black
        
        let searchURL = "https://api.spotify.com/v1/search?q=\(search)&type=track&limit=10"
        
        searchTrack(url: searchURL)
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
} // End Class

extension AllSongsViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        playerQueue = currentTracksInQueue
        self.tableView.reloadData()
    }

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
        playerQueue = syncPlayerQueue(arr: playerQueue, index: indexPath.row)
        let spotifyPlayer = SpotifyPlayerViewController()
        spotifyPlayer.playSpotify(uri: uri!)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 55
        }
        return 55
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
        {
            print("Scrolled toEnd")
            let searchURL = "https://api.spotify.com/v1/search?q=\(search)&type=track&limit=10&offset=\(scrollToRefreshCount)"
            searchTrack(url: searchURL)
            tableView.reloadData()
            scrollToRefreshCount += 10
        }
    }
}
