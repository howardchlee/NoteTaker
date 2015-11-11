//
//  AppDelegate.swift
//  NoteTaker
//
//  Created by howard.lee on 11/9/15.
//  Copyright © 2015 howard.lee. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var allNotes: [Note]!

    func fetchAllNotes() -> [Note] {
        let fetchRequest = NSFetchRequest(entityName: "Note")
        do {
            return try CoreDataStackManager.sharedInstance().managedObjectContext.executeFetchRequest(fetchRequest) as! [Note]
        } catch let error as NSError {
            print("Error in fetchAllNotes(): \(error)")
            return [Note]()
        }
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        allNotes = fetchAllNotes()
        return true
    }
}

