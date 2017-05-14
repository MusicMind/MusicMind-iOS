//
//  MessageIDs+CoreDataProperties.swift
//  MusicMind
//
//  Created by Alec Arshavsky on 5/8/17.
//  Copyright © 2017 Alec Arshavsky. All rights reserved.
//

import Foundation
import CoreData


extension MessageIDs {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageIDs> {
        return NSFetchRequest<MessageIDs>(entityName: "MessageIDs");
    }

    @NSManaged public var messageID: Int64
    @NSManaged public var conversation: Conversation?

}
