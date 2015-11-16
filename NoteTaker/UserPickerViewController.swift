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

    let maximumUserNameLength = 16
    
    @IBOutlet weak var tableView: UITableView!
    
    var allUsers: [User] {
        get {
            return appDelegate.allUsers
        }
        set {
            appDelegate.allUsers = newValue
        }
    }

    func showNameAlertWithTitle(title: String, message: String, handler: (String -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let okAction = UIAlertAction(title: "Confirm", style: .Default, handler: { (_) -> Void in
            let newName = alert.textFields![0].text!
            handler(newName)
        })
        
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "Enter name here"
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification) -> Void in
                
                // Restrict the name of the strength
                let text = textField.text!
                if text.characters.count > self.maximumUserNameLength {
                    textField.text = text.substringToIndex(text.startIndex.advancedBy(self.maximumUserNameLength))
                }

                // Set done button to enabled if text has been entered
                okAction.enabled = textField.text != ""
            })
        })
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
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
            showNameAlertWithTitle("New User", message: "Enter the name of the user below", handler: { [unowned self] (name) -> Void in
                self.createUserWithName(name)
            })
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // all rows except the edit cell are editable
        return indexPath.row < allUsers.count
    }

    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .Destructive, title: "Delete") { [unowned self] (_, indexPath) -> Void in
            let row = indexPath.row
            let user = self.allUsers[row]
            CoreDataStackManager.sharedInstance().managedObjectContext.deleteObject(user)
            CoreDataStackManager.sharedInstance().saveContext()

            self.allUsers.removeAtIndex(row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Bottom)
        }

        let editAction = UITableViewRowAction(style: .Default, title: "Rename") { [unowned self] (_, indexPath) -> Void in
            self.showNameAlertWithTitle("Rename User", message: "Enter the user's new name below", handler: { (name) -> Void in
                self.allUsers[indexPath.row].name = name
                CoreDataStackManager.sharedInstance().saveContext()
                (tableView.cellForRowAtIndexPath(indexPath) as! UserPickerTableViewCell).name = name
                tableView.setEditing(false, animated: true)
            })
        }
        editAction.backgroundColor = UIColor.blueColor()

        return [deleteAction, editAction]
    }

}
