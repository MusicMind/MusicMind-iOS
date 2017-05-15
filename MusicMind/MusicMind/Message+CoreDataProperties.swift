//
//  Message+CoreDataProperties.swift
//  MusicMind
//
//  Created by Alec Arshavsky on 5/8/17.
//  Copyright © 2017 Alec Arshavsky. All rights reserved.
//

import Foundation
import CoreData
import Firebase


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message");
    }

    @NSManaged public var text: String?
    @NSManaged public var timeStamp: Int64
    @NSManaged public var status: Int16     // 0 raw received, 1 received and acked, 2 recieved and read
    @NSManaged public var messageID: Int64
    @NSManaged public var sender: String?
    @NSManaged public var conversation: Conversation?
    
    
    
    
    func toJSON() -> Any {
        return [
            "text": self.text ?? "",
            "timeStamp": self.timeStamp,
            "status": self.status,
            "messageID": self.messageID,
            "sender": self.sender ?? FIRAuth.auth()!.currentUser!.uid
        ]
    }

}
