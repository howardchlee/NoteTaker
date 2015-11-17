//
//  NoteEditorController.swift
//  NoteTaker
//
//  Created by howard.lee on 11/9/15.
//  Copyright © 2015 howard.lee. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NoteEditorController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    var noteId: Int?
    @IBOutlet weak var saveButton: UIButton!
    
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
    
    var currentUser: User {
        return appDelegate.currentUser!
    }

    var managedObjectContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.enabled = false

        titleTextField.layer.borderWidth = 2.0
        titleTextField.layer.borderColor = UIColor(colorLiteralRed: 26, green: 61, blue: 76, alpha: 1).CGColor
        bodyTextView.layer.borderWidth = 2.0
        bodyTextView.layer.borderColor = UIColor(colorLiteralRed: 26, green: 61, blue: 76, alpha: 1).CGColor
        if let noteId = noteId {
            let note = allNotes[noteId]
            titleTextField.text = note.noteTitle
            bodyTextView.text = note.noteBody
        }
    }

    @IBAction func saveTapped(sender: UIButton) {
        let noteTitle = titleTextField.text ?? ""
        let noteBody = bodyTextView.text ?? ""
        let dateNow = NSDate(timeIntervalSinceNow: 0)
        
        if noteId == nil {
            noteId = allNotes.count
            let _ = Note(title: "", body: "", dateCreated: NSDate(timeIntervalSinceNow: 0), dateUpdated: NSDate(timeIntervalSinceNow: 0), user: currentUser, context: managedObjectContext)
        }
        
        let note = allNotes[noteId!]
        note.noteTitle = noteTitle
        note.noteBody = noteBody
        note.dateUpdated = dateNow
        
        CoreDataStackManager.sharedInstance().saveContext()
        saveButton.enabled = false
    }

    @IBAction func cancelTapped(sender: UIButton) {
        if saveButton.enabled {
            // there is save to be commited
            let alert = UIAlertController(title: "Exiting Editor", message: "You have unsaved changes to this note.  Are you sure you want to discard the unsaved changes and exit?", preferredStyle: .Alert)

            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            let discardAction = UIAlertAction(title: "Discard Changes", style: .Destructive, handler: {[unowned self] (_) in
                self.dismissViewControllerAnimated(true, completion: nil)
            })

            alert.addAction(cancelAction)
            alert.addAction(discardAction)

            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }

    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == titleTextField {
            bodyTextView.becomeFirstResponder()
            return false
        }
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        saveButton.enabled = true
        return true
    }
    
    // MARK: UITextViewDelegate

    func textViewDidChange(textView: UITextView) {
        saveButton.enabled = true
    }
}
