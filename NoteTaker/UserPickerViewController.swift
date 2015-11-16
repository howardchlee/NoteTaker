//
//  UserPickerViewController.swift
//  NoteTaker
//
//  Created by howard.lee on 11/15/15.
//  Copyright © 2015 howard.lee. All rights reserved.
//

import Foundation
import UIKit

class UserPickerViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var allUsers: [User] {
        get {
            return appDelegate.allUsers
        }
        set {
            appDelegate.allUsers = newValue
        }
    }

    func createUserWithName(name: String) {
        let newUser = User(name: name, context: CoreDataStackManager.sharedInstance().managedObjectContext)
        CoreDataStackManager.sharedInstance().saveContext()
        
        allUsers.append(newUser)
        tableView.reloadData()
    }
}

extension UserPickerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        if row < allUsers.count {
            // this is an actual user cell
            let cell = tableView.dequeueReusableCellWithIdentifier("user_cell") as! UserPickerTableViewCell
            cell.name = allUsers[row].name
            cell.count = allUsers[row].notes.count
            return cell
        } else {
            // this is the add user cell
            let cell = tableView.dequeueReusableCellWithIdentifier("add_user_cell")!
            return cell
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsers.count + 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        if row < allUsers.count {
            // this is a user cell
            appDelegate.currentUser = allUsers[row]
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            // this is the add user cell
            let alert = UIAlertController(title: "New User", message: "Name the user", preferredStyle: .Alert)

            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            let okAction = UIAlertAction(title: "Done", style: .Default, handler: { (_) -> Void in
                let nameField = alert.textFields![0] as UITextField
                self.createUserWithName(nameField.text!)
            })
            
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                textField.placeholder = "Enter name here"
                NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue(), usingBlock: { (_) -> Void in
                    okAction.enabled = textField.text != ""
                })
            })

            alert.addAction(cancelAction)
            alert.addAction(okAction)

            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

}
