//
//  Conversation+CoreDataProperties.swift
//  MusicMind
//
//  Created by Alec Arshavsky on 5/8/17.
//  Copyright © 2017 Alec Arshavsky. All rights reserved.
//

import Foundation
import CoreData


extension Conversation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Conversation> {
        return NSFetchRequest<Conversation>(entityName: "Conversation");
    }

    @NSManaged public var partnerName: String?
    @NSManaged public var partnerID: String?
    @NSManaged public var timeStamp: Int64
    @NSManaged public var messageNum: Int16
    @NSManaged public var conversationID: Int64
    @NSManaged public var messageIDs: [MessageIDs]
    @NSManaged public var messages: [Message]

}

// MARK: Generated accessors for messageIDs
extension Conversation {

    @objc(addMessageIDsObject:)
    @NSManaged public func addToMessageIDs(_ value: MessageIDs)

    @objc(removeMessageIDsObject:)
    @NSManaged public func removeFromMessageIDs(_ value: MessageIDs)

    @objc(addMessageIDs:)
    @NSManaged public func addToMessageIDs(_ values: NSSet)

    @objc(removeMessageIDs:)
    @NSManaged public func removeFromMessageIDs(_ values: NSSet)

}

// MARK: Generated accessors for messages
extension Conversation {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: Message)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: Message)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}
