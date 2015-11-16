//
//  NotePickerViewController.swift
//  NoteTaker
//
//  Created by howard.lee on 11/9/15.
//  Copyright © 2015 howard.lee. All rights reserved.
//

import UIKit

class NotePickerViewController: UIViewController {

    var allNotes: [Note] {
        get {
            if let notes = appDelegate.currentUser?.notes {
                return notes
            } else {
                return [Note]()
            }
        }
        set {
            appDelegate.currentUser?.notes = allNotes
        }
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loginMessageLabel: UILabel!
    @IBOutlet weak var changeUserButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonSystemItem.Compose, target: self, action: "addButtonTapped")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if appDelegate.currentUser == nil {
            loginMessageLabel.text = ""
            changeUserButton.hidden = true
            openUserPicker()
        } else {
            loginMessageLabel.text = "User: \(appDelegate.currentUser!.name)"
            changeUserButton.hidden = false
        }
        tableView.reloadData()
    }

    func addButtonTapped() {
        openNoteEditor(nil)
    }

    @IBAction func changeUserButtonTapped(sender: UIButton) {
        openUserPicker()
    }

    func openNoteEditor(noteId: Int?) {
        guard let noteEditorController = self.storyboard?.instantiateViewControllerWithIdentifier("editor") as? NoteEditorController else {
            return
        }

        noteEditorController.noteId = noteId
        presentViewController(noteEditorController, animated: true, completion: nil)
    }

    func openUserPicker() {
        guard let userPicker = self.storyboard?.instantiateViewControllerWithIdentifier("user_picker") as? UserPickerViewController else {
            return
        }
        presentViewController(userPicker, animated: true, completion: nil)
    }
}

extension NotePickerViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell()
        cell.textLabel?.text = allNotes[indexPath.row].noteTitle
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allNotes.count
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let noteId = indexPath.row
        openNoteEditor(noteId)
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let noteId = indexPath.row
            let note = allNotes[noteId]
            note.user = nil
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)

            CoreDataStackManager.sharedInstance().saveContext()
        }
    }
}

