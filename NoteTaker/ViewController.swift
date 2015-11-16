//
//  ViewController.swift
//  NoteTaker
//
//  Created by howard.lee on 11/9/15.
//  Copyright © 2015 howard.lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonSystemItem.Compose, target: self, action: "addButtonTapped")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if appDelegate.currentUser == nil {
            guard let userPicker = self.storyboard?.instantiateViewControllerWithIdentifier("user_picker") as? UserPickerViewController else {
                return
            }
            presentViewController(userPicker, animated: true, completion: nil)
        }
        tableView.reloadData()
    }

    func addButtonTapped() {
        openNoteEditor(nil)
    }

    func openNoteEditor(noteId: Int?) {
        guard let noteEditorController = self.storyboard?.instantiateViewControllerWithIdentifier("editor") as? NoteEditorController else {
            return
        }

        noteEditorController.noteId = noteId
        presentViewController(noteEditorController, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
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

