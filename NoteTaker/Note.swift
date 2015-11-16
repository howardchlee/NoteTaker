//
//  Note.swift
//  NoteTaker
//
//  Created by howard.lee on 11/9/15.
//  Copyright © 2015 howard.lee. All rights reserved.
//

import Foundation
import CoreData

class Note :NSManagedObject {
    @NSManaged var noteTitle: String
    @NSManaged var noteBody: String
    @NSManaged var dateCreated: NSDate
    @NSManaged var dateUpdated: NSDate
    @NSManaged var user: User?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(title: String, body: String, dateCreated: NSDate, dateUpdated:NSDate, user: User, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Note", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)

        self.noteTitle = title
        self.noteBody = body
        self.dateCreated = dateCreated
        self.dateUpdated = dateUpdated
        self.user = user
    }
}