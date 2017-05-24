//
//  AlbumsCollectionViewController.swift
//  MusicMind
//
//  Created by Rich Ruais on 5/20/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import UIKit
import Alamofire

private let reuseIdentifier = "album"

class AlbumsCollectionViewController: UIViewController {
    
    var search = String()
    let ssh = SpotifySearchHelpers()
    var scrollToRefreshCount = 6

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        albumList.removeAll()
        let searchURL = "https://api.spotify.com/v1/search?q=\(self.search)&type=album&limit=6"
        searchAlbum(url: searchURL)
        print("AlbumList      \(albumList.count)")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "album")

    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

extension AlbumsCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
        collectionView.reloadData()
    }


    

     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAlbumTracks-AC" {
            let vc = segue.destination
                as! AlbumTracksViewController
            let cell = sender as? UICollectionViewCell
            let indexPath = collectionView.indexPath(for: cell!)
            let name = albumList[(indexPath?.row)!].name
            let smallImage = albumList[(indexPath?.row)!].smallImage
            let largeImage = albumList[(indexPath?.row)!].largeImage
            let artistName = albumList[(indexPath?.row)!].artistName
            let id = albumList[(indexPath?.row)!].id
            let newAlbum = album.init(name: name, smallImage: smallImage, largeImage: largeImage, artistName: artistName, id: id)
            vc.currentAlbumDetails = newAlbum
        }

     }
 
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "album", for: indexPath)
        
        let backgroundImage = cell.viewWithTag(1) as! UIImageView
        backgroundImage.image  = albumList[indexPath.row].largeImage
        let image = cell.viewWithTag(2) as! UIImageView
        image.image  = albumList[indexPath.row].largeImage
        let artistName = cell.viewWithTag(4) as! UILabel
        artistName.text = albumList[indexPath.row].artistName
        let albumName = cell.viewWithTag(3) as! UILabel
        albumName.text = albumList[indexPath.row].name
        
        return cell
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
        {
            print("Scrolled toEnd")
             let searchURL = "https://api.spotify.com/v1/search?q=\(search)&type=album&limit=6&offset=\(scrollToRefreshCount)"
            searchAlbum(url: searchURL)
            collectionView.reloadData()
            scrollToRefreshCount += 6
        }
    }

    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
}
