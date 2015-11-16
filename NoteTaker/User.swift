//
//  User.swift
//  NoteTaker
//
//  Created by howard.lee on 11/15/15.
//  Copyright © 2015 howard.lee. All rights reserved.
//

import Foundation
import CoreData

class User: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var notes: [Note]
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(name: String, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.name = name
    }
}