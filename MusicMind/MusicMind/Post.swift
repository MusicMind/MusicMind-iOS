//
//  Post.swift
//  MusicMind
//
//  Created by Wesley Van der Klomp on 5/10/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import Foundation
import Firebase

struct Post: FirebaseConvertable {

    var dateTimeCreated: Date?
    var postTitle: String?
    var authorId: String?
    var recipients: [String]?
    var videoDownloadUrl: URL?
    var numberOfPlays: Int?
    
//    In the future posts will have stuff like the following:
//    var associatedTracks: [Track]?
//    var comments: [Comment]?
//    var tags: [String]?
//    var postingLocation: CLLocation?
//    var likesFromUsers: [String]?
    
    var asDictionary: [String : Any] {
        return [:]
    }
    
    init(withSnapshot snapshot: FIRDataSnapshot) {
        
    }
}
