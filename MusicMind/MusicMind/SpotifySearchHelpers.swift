//
//  SpotifySearchHelpers.swift
//  MusicMind
//
//  Created by Rich Ruais on 5/21/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import Foundation

class SpotifySearchHelpers {
    
    func parseAlbumData(JSONData: Data) -> [album] {
        var tempArr = [album]()
        do {
            var readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! [String : AnyObject]
            if let albums = readableJSON["albums"] as? [String : AnyObject]{
                if let items = albums["items"] as? NSArray {
                    for i in 0..<items.count  {
                        let item = items[i] as! [String : Any]
                        let albumName = item["name"] as? String
                        let id = item["id"] as? String
                        if let images = item["images"] as? [[String : AnyObject]] {
                            let largeImage = images[0]
                            let largeImageURL = URL(string:largeImage["url"] as! String)
                            let largeImageData = NSData(contentsOf: largeImageURL!)
                            let largeAlbumImage = UIImage(data: largeImageData! as Data)
                            let smallImage = images[2]
                            let smallImageURL = URL(string:smallImage["url"] as! String)
                            let smallImageData = NSData(contentsOf: smallImageURL!)
                            let smallAlbumImage = UIImage(data: smallImageData! as Data)
                            if let artists = item["artists"] as? [[String : AnyObject]] {
                                let artist0 = artists[0]
                                let artistName = artist0["name"] as! String
                                let newAlbum = album.init(name: albumName, smallImage: smallAlbumImage, largeImage: largeAlbumImage, artistName: artistName, id: id)
                                tempArr.append(newAlbum)
                            }
                        }
                    }
                }
            }
            
        } catch {
            print(error)
        }
        return tempArr
    }
    
    func parseTrackData(JSONData : Data) -> [track] {
        var tempArr = [track]()
        do {
            var readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! [String : AnyObject]
            if let tracks = readableJSON["tracks"] as? [String : AnyObject]{
                if let items = tracks["items"] as? NSArray {
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
                                    let newTrack = track.init(artist: artistName, songTitle: songTitle, largeAlbumImage: largeAlbumImage, smallAlbumImage: smallAlbumImage, albumName: albumName, uri: trackURI, duration: duration)
                                    tempArr.append(newTrack)
                                }
                            }
                        }
                    }
                }
            }
        } catch {
            print(error)
        }
        return tempArr
    }
    
    func parseAlbumTrackData(JSONData : Data) -> [track] {
        var tempArr = [track]()
        do {
            var readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! [String : AnyObject]
                if let items = readableJSON["items"] as? NSArray {
                    print("items********  \(items)")
                    for i in 0..<items.count  {
                        let item = items[i] as! [String : Any]
                        let songTitle = item["name"] as! String
                        let trackURI = item["uri"] as? String
                        let duration = item["duration_ms"] as? Int
                            if let artist = item["artists"] as? [[String: Any]] {
                                let artistName = (artist[0]["name"] as? String)!
                                    let newTrack = track.init(artist: artistName, songTitle: songTitle, largeAlbumImage: nil, smallAlbumImage: nil, albumName: nil, uri: trackURI, duration: duration)
                                    tempArr.append(newTrack)
                                }
                    }
                }
        } catch {
            print(error)
        }
        return tempArr
    }
    
    func parseUserPlaylists(JSONData: Data) -> [playlist] {
        var tempArr = [playlist]()
        do {
            var readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! [String : AnyObject]
            if let items = readableJSON["items"] as? NSArray {
                for i in 0..<items.count  {
                    let item = items[i] as! [String : Any]
                    let name = item["name"] as! String
                    let id = item["id"] as! String
                    let tracks = item["tracks"] as! [String : Any]
                    let trackCountInt = tracks["total"] as! Int
                    let trackCount = String(trackCountInt)
                    if let images = item["images"] as? [[String : AnyObject]] {
                        let largeImage = images[0]
                        let largeImageURL = URL(string:largeImage["url"] as! String)
                        let largeImageData = NSData(contentsOf: largeImageURL!)
                        let LargePlaylistImage = UIImage(data: largeImageData! as Data)
                        let newPlaylist = playlist.init(name: name , trackCount: trackCount, largeImage: LargePlaylistImage, id: id)
                        tempArr.append(newPlaylist)
                    }
                }
            }
        } catch {
            print(error)
        }
        return tempArr
    }
    
    func parseUserPlaylistTracks(JSONData : Data) -> [track] {
        var tempArr = [track]()
        do {
            var readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! [String : AnyObject]
            let items = readableJSON["items"] as! NSArray
            for i in 0..<items.count {
                let item = items[i] as! [String : Any]
                if let addedBy = item["added_by"] as? [String : Any] {
                    _ = addedBy["id"]
                    if let tracks = item["track"] as? [String : Any] {
                        if let album = tracks["album"] as? [String : AnyObject] {
                            if let artist = album["artists"] as? [[String: Any]] {
                                let artistName = (artist[0]["name"] as? String)!
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
                                    let newTrack = track.init(artist: artistName, songTitle: songTitle, largeAlbumImage: largeAlbumImage, smallAlbumImage: smallAlbumImage, albumName: albumName, uri: trackURI, duration: duration)
                                    tempArr.append(newTrack)
                                }
                            }
                        }
                    }
                }
                
            }
        } catch {
            print(error)
        }
        return tempArr
    }
    
}// End Spotify Search Helpers
