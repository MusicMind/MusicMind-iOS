//
//  Message+CoreDataProperties.swift
//  MusicMind
//
//  Created by Alec Arshavsky on 5/8/17.
//  Copyright © 2017 Alec Arshavsky. All rights reserved.
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message");
    }

    @NSManaged public var text: String?
    @NSManaged public var timeStamp: Int64
    @NSManaged public var status: Int16
    @NSManaged public var messageID: Int64
    @NSManaged public var sender: String?
    @NSManaged public var conversation: Conversation?

}
