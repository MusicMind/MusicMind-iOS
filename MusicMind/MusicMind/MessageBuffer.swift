//
//  MessageBuffer.swift
//  MusicMind
//
//  Created by Alec on 5/15/17.
//  Copyright © 2017 MusicMind. All rights reserved.
//

import Foundation
import Firebase

struct MessageBuffer {
    
    
    let text: String?
    let timeStamp: Int64
    let status: Int16     // 0 raw received, 1 received and acked, 2 recieved and read
    let messageID: Int64
    let sender: String?
    
    
    
    
    init(snapshot: FIRDataSnapshot) {
        let snapshotValue = snapshot.value as! [String: Any]
        self.text = snapshotValue["text"] as? String
        self.timeStamp = snapshotValue["timeStamp"] as! Int64
        self.status = snapshotValue["status"] as! Int16
        self.messageID = snapshotValue["messageID"] as! Int64
        self.sender = snapshotValue["sender"] as? String
    }
    
}
    
