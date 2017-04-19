//
//  MusicSearchViewController.swift
//  MusicMind
//
//  Created by Ryan Boyd on 3/19/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit
import Alamofire

class MusicSearchViewController: UIViewController {
    
    var searchResults = [String: Any]()
    var totalNumberOfSongFromResults: Int = 0
    weak var audioPlayer = SPTAudioStreamingController.sharedInstance()
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
        createAudioPlayer()
        hideKeyboardWhenTappedAround()
        
        searchBar.keyboardAppearance = .dark
        
        // Set delegates
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        presentSpotifyLoginAlert()
    }
    
    func presentSpotifyLoginAlert() {
        let alert = UIAlertController(title: "Spotify Log In", message: "You need to login with your Spotify Premium account in order to play songs.", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let login = UIAlertAction(title: "Go to Spotify", style: .default) { (alertAction) in
            self.loginToSpotify()
        }
        
        alert.addAction(cancel)
        alert.addAction(login)
        
        present(alert, animated: true, completion: nil)
    }
    
    func loginToSpotify() {
        if let auth = SPTAuth.defaultInstance() {
            auth.clientID = "3b7f66602b9c45b78f4aa55de8efd046"
            auth.redirectURL = URL(string: "musicmind://returnAfterSpotify")
            auth.requestedScopes = [SPTAuthStreamingScope]
            
            //TODO rethink this first conditional
            if auth.session != nil {
                //TODO Store session in UserDefaults
                print(auth.session.accessToken)
                
                if !auth.session.isValid(){
                    print("session not valid")
                }
                
                print(auth.session.canonicalUsername)
            }
            else {
                if let spotifyUrl = auth.spotifyWebAuthenticationURL() {
                    UIApplication.shared.open(spotifyUrl, options: [:])
                }
            }
        }
    }
    
    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func edgeGestureAction(sender: UIScreenEdgePanGestureRecognizer) {
        switch sender.state {
        case .began:
            self.dismiss(animated: true, completion: nil)
        default:
            // pass down for the interaction controller to handle the rest of these cases
            break
        }
    }

    
    // MARK: - Setups and helpers
    
    private func createAudioPlayer() {
        audioPlayer?.playbackDelegate = self
        audioPlayer?.delegate = self
        
        do {
            try audioPlayer?.start(withClientId: "3b7f66602b9c45b78f4aa55de8efd046")
        } catch {
            print(error.localizedDescription)
        }
        
//        audioPlayer?.login(withAccessToken: user.spotifyToken)
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
}

extension MusicSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        Alamofire.request("https://api.spotify.com/v1/search?q=\(searchText)&type=track").responseString { response in
            debugPrint(response)
            
            if let json = response.result.value {
                print("JSON: \(json)")
                
                if let dict = self.convertStringToDictionary(text: json ) {
                    
                    self.searchResults = dict
                    
                    if let tracks = self.searchResults["tracks"] as? [String: Any] {
                        
                        if let items = tracks["items"] as? [[String: Any]] {
                            
                            self.totalNumberOfSongFromResults = items.count
                            
                        }
                        
                    }
                    
                    debugPrint(self.searchResults)
                    
                    self.tableView?.reloadData()
                }
            }
        }
    }
    
}

extension MusicSearchViewController: UITextViewDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

extension MusicSearchViewController: SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {
    
    
    // MARK: - Audio steaming
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        print(audioStreaming)
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didReceiveError error: Error!) {
        print(error)
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didStartPlayingTrack trackUri: String!) {
        print(trackUri)
    }

}

/// Table view delegate and data source methods
extension MusicSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: - Table view delegate 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tracks = self.searchResults["tracks"] as? [String: Any] {
            if let items = tracks["items"] as? [[String: Any]] {
                let row = indexPath.row
                let index = items[row]
                let trackURI = index["uri"] as? String

                self.audioPlayer?.playSpotifyURI(trackURI, startingWith: 0, startingWithPosition: 0, callback: { error in
                    if (error != nil) {
                        print(error!.localizedDescription)
                        return
                }})
            }
        }
        
    }
    
    // UIApplication.shared().open(url, options: [:])
    

    // MARK: - Table view data source
    
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
                if let index = items[indexPath.row] as? [String: Any] {
                    
                    cell.textLabel?.text = index["name"] as? String
                    
                    if let album = index["album"] as? [String: Any] {
                        
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

}
