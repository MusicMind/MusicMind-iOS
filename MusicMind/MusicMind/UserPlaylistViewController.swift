//
//  UserPlaylistViewController.swift
//  MusicMind
//
//  Created by Rich Ruais on 5/16/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit
import Alamofire

struct playlist {
    let name: String!
    let trackCount: String!
    let largeImage: UIImage!
}

var userPlaylists = [playlist]()
var playlistTableView = UITableView()

class UserPlaylistViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
  override func viewDidLoad() {
        super.viewDidLoad()
        
        playlistTableView = tableView
        tableView.delegate = self
        tableView.dataSource = self

        getUserInfo()
    }
    
}

extension UserPlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func getUserInfo() {
        Alamofire.request("https://api.spotify.com/v1/me/playlists", headers: ["Authorization": "Bearer " + spotifyAuth.session.accessToken]).responseJSON(completionHandler: {
            response in
            self.parseUserInfo(JSONData: response.data!)
        })
    }
    
    func parseUserInfo(JSONData: Data) {
        do {
            var readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! [String : AnyObject]
            //                print(readableJSON)
            if let items = readableJSON["items"] as? NSArray {
                for i in 0..<items.count  {
                    let item = items[i] as! [String : Any]
                    let name = item["name"] as! String
                    let tracks = item["tracks"] as! [String : Any]
                    let trackCountInt = tracks["total"] as! Int
                    let trackCount = String(trackCountInt)
                    if let images = item["images"] as? [[String : AnyObject]] {
                        let largeImage = images[0]
                        let largeImageURL = URL(string:largeImage["url"] as! String)
                        let largeImageData = NSData(contentsOf: largeImageURL!)
                        let LargePlaylistImage = UIImage(data: largeImageData! as Data)
                        let newPlaylist = playlist.init(name: name , trackCount: trackCount, largeImage: LargePlaylistImage)
                        userPlaylists.append(newPlaylist)
                    }
                    self.tableView.reloadData()
                }
            }
            
        } catch {
            print(error)
        }
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPlaylists.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "playlistCell", for: indexPath)
        let playlistName = cell.viewWithTag(1) as! UILabel
        playlistName.text = userPlaylists[indexPath.row].name
        let playlistTrackCount = cell.viewWithTag(2) as! UILabel
        playlistTrackCount.text = userPlaylists[indexPath.row].trackCount
        let playlistImage = cell.viewWithTag(3) as! UIImageView
        playlistImage.image = userPlaylists[indexPath.row].largeImage
        let backgroundImage = cell.viewWithTag(4) as! UIImageView
        backgroundImage.image = userPlaylists[indexPath.row].largeImage
    
        return cell
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

}
