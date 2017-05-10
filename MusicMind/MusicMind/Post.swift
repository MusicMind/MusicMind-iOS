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

    var id: String?
    var dateTimeCreated: Date?
    var authorId: String?
    var recipients: [String]?
    var videoDownloadUrl: URL?
    var numberOfViews: Int?
    private let dateFormatter = DateFormatter()
    var asDictionary: [String : Any] {
        var dict: [String: Any] = [:]
        
        if let dateTimeCreated = dateTimeCreated { dict["dateTimeCreated"] = dateFormatter.string(from: dateTimeCreated) }
        if let authorId = authorId { dict["authorId"] = authorId }
        if let recipients = recipients { dict["recipients"] = recipients }
        if let videoDownloadUrl = videoDownloadUrl { dict["videoDownloadUrl"] = videoDownloadUrl.absoluteString }
        if let numberOfViews = numberOfViews { dict["numberOfViews"] = numberOfViews }
        
        return dict
    }
    
    //    In the future posts will have stuff like the following:
    //    var associatedTracks: [Track]?
    //    var postTitle: String?
    //    var postType: String?
    //    var comments: [Comment]?
    //    var tags: [String]?
    //    var postingLocation: CLLocation?
    //    var likesFromUsers: [String]?
    
    init() {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    }
    
    init(withSnapshot snapshot: FIRDataSnapshot) {
        self.init()
        
        self.id = snapshot.key
        
        if let postData = snapshot.value as? [String: Any] {
         
            if let dateTimeCreatedString = postData["dateTimeCreated"] as? String { dateTimeCreated = dateFormatter.date(from: dateTimeCreatedString) }
        }

    }
}
