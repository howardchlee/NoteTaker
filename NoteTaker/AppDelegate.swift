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
    var allUsers: [User]!
    var currentUser: User?
    
    func fetchAllUsers() -> [User] {
        let fetchRequest = NSFetchRequest(entityName: "User")
        do {
            return try CoreDataStackManager.sharedInstance().managedObjectContext.executeFetchRequest(fetchRequest) as! [User]
        } catch let error as NSError {
            print("Error in fetchAllUsers(): \(error)")
            return [User]()
        }
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        allUsers = fetchAllUsers()
        return true
    }
}

extension UIViewController {
    var appDelegate :AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
}
