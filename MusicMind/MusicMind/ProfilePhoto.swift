//
//  ProfilePhoto.swift
//  MusicMind
//
//  Created by david samuel on 5/24/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import Foundation
import Firebase

struct ProfilePhoto {
    
    var id: String?
    var dateTimeCreated: Date?
    var authorId: String?
    var profilePhotoDownloadUrl: URL?
    fileprivate let dateFormatter = DateFormatter()
    
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
    
}

extension ProfilePhoto: FirebaseConvertable {
    
    var asDictionary: [String: Any] {
        var dict: [String: Any] = [:]
        
        if let dateTimeCreated = dateTimeCreated { dict["dateTimeCreated"] = dateFormatter.string(from: dateTimeCreated) }
        if let authorId = authorId { dict["authorId"] = authorId }
        if let profilePhotoDownloadUrl = profilePhotoDownloadUrl { dict["profilePhotoDownloadUrl"] = profilePhotoDownloadUrl.absoluteString }
        
        return dict
    }
    
    init(withSnapshot snapshot: FIRDataSnapshot) {
        self.init()
        
        self.id = snapshot.key
        
        if let postData = snapshot.value as? [String: Any] {
            if let dateTimeCreatedString = postData["dateTimeCreated"] as? String { dateTimeCreated = dateFormatter.date(from: dateTimeCreatedString) }
            if let authorId = postData["authorId"] as? String { self.authorId = authorId }

            if let profilePhotoDownloadUrlString = postData["profilePhotoDownloadUrl"] as? String { self.profilePhotoDownloadUrl = URL(string: profilePhotoDownloadUrlString) }

        }
    }
    
}
