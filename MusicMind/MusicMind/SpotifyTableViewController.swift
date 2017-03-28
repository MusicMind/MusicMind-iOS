//
//  SpotifyTableViewController.swift
//  MusicMind
//
//  Created by Ryan Boyd on 3/19/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit
import Alamofire

class SpotifyTableViewController: UITableViewController, UISearchBarDelegate, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {
    
    var arr = [String:Any]()
    var arrCount: Int = 0
    var audioPlayer: SPTAudioStreamingController?
    var isSongPlaying: Bool?
    let searchBar = UISearchBar()
    
    func createSearchBar(){
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.frame.size.width = self.view.frame.size.width - 160
        searchBar.placeholder = "search"
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = searchItem
        //searchBar.enablesReturnKeyAutomatically = true
        searchBar.showsSearchResultsButton = true

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func createAudioPlayer(){
        self.audioPlayer = SPTAudioStreamingController.sharedInstance()
        self.audioPlayer?.playbackDelegate = self
        self.audioPlayer?.delegate = self
        do {
            try self.audioPlayer?.start(withClientId: "85374bf3879843d6a7b6fd4e62030d97")
        }
        catch {
            print("Audio Player already started")
        }
        
        self.audioPlayer!.login(withAccessToken: user.spotifyToken)
    }
    
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        Alamofire.request("https://api.spotify.com/v1/search?q=\(searchText)&type=track").responseString { response in
            debugPrint(response)
            
            if let json = response.result.value {
                print("JSON: \(json)")
                if let dict = self.convertStringToDictionary(text: json ) {
                    self.arr = dict
                    if let tracks = self.arr["tracks"] as? [String: Any] {
                        if let items = tracks["items"] as? [[String: Any]] {
                            self.arrCount = items.count
                        }
                    }
                    debugPrint(self.arr)
                    self.tableView?.reloadData()
                    //debugPrint((self.arr["tracks"] as! [String: AnyObject])["items"] as! [String: AnyObject])
                }
            }
        }
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        print(audioStreaming)
    }
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didReceiveError error: Error!) {
        print(error)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSearchBar()
        self.createAudioPlayer()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.arrCount
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

         //Configure the cell...
        if let tracks = self.arr["tracks"] as? [String: Any] {
            if let items = tracks["items"] as? [[String: Any]] {
                if let index = items[indexPath.row] as? [String: Any] {
                    
                    cell.textLabel?.text = index["name"] as? String
                    
                    if let album = index["album"] as? [String: Any] {
                        
                        //cell.textLabel?.text = album["name"] as? String
                        
                        if let artist = album["artists"] as? [[String: Any]] {
                            cell.detailTextLabel?.text = artist[0]["name"] as? String
                            print(artist[0]["name"] as? String)
                        }
                        
                        if let image = album["images"] as? [[String: Any]]{
                            if let smallImage = image[2] as? [String: Any]{
                                let urlString = smallImage["url"] as? String
                                if let url  = NSURL(string: urlString!){
                                    if let data = NSData(contentsOf: url as URL){
                                        cell.imageView?.image = UIImage(data: data as Data)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        return cell
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStartPlayingTrack trackUri: String!) {
        print(trackUri)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tracks = self.arr["tracks"] as? [String: Any] {
            if let items = tracks["items"] as? [[String: Any]] {
                if let index = items[indexPath.row] as? [String: Any] {
                    let trackURI = index["uri"] as? String
                    self.audioPlayer?.playSpotifyURI(trackURI, startingWith: 0, startingWithPosition: 0, callback: { error in
                        if (error != nil) {
                            print(error)
                            return;
                        }})
                    
                }
            }
        }

    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didChangePlaybackStatus isPlaying: Bool) {
        print(isPlaying)
        self.isSongPlaying = isPlaying
        
    }
    
    func onPlayPress(){
        if let isPlaying = self.isSongPlaying {
            if isPlaying {
                self.audioPlayer?.setIsPlaying(false, callback: { error in
                    if error != nil {
                        print(error)
                    }
                })
            }
            else {
                self.audioPlayer?.setIsPlaying(true, callback: { error in
                    if error != nil {
                        print(error)
                    }
                })
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 80))
        footerView.backgroundColor = UIColor.black
        print(UIScreen.main.bounds.width)
        print(UIScreen.main.bounds.midX)
        print(UIScreen.main.bounds.maxX)
        let button = UIButton(frame: CGRect(x: UIScreen.main.bounds.width/3, y: 0, width: 150, height: 50))
        button.setTitle("Play/Pause", for: .normal)
        button.addTarget(self, action: #selector(SpotifyTableViewController.onPlayPress), for: .touchUpInside)
        footerView.addSubview(button)
        
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80.0
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

}


/* extension SpotifyTableViewController: UITextViewDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        self.view.endEditing(true)
        searchBar.resignFirstResponder()
    }
} */
