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
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    
    var allNotes: [Note] {
        get {
            return (UIApplication.sharedApplication().delegate as! AppDelegate).allNotes
        }
        set {
            (UIApplication.sharedApplication().delegate as! AppDelegate).allNotes = newValue
        }
    }

    var managedObjectContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveBarButtonItem.enabled = false

        if let noteId = noteId {
            let note = allNotes[noteId]
            titleTextField.text = note.noteTitle
            bodyTextView.text = note.noteBody
        }
    }

    @IBAction func saveTapped(sender: UIBarButtonItem) {
        let noteTitle = titleTextField.text ?? ""
        let noteBody = bodyTextView.text ?? ""
        let dateNow = NSDate(timeIntervalSinceNow: 0)
        
        if noteId == nil {
            let newNote = Note(title: "", body: "", dateCreated: NSDate(timeIntervalSinceNow: 0), dateUpdated: NSDate(timeIntervalSinceNow: 0), context: managedObjectContext)
            noteId = allNotes.count
            allNotes.append(newNote)
        }
        
        let note = allNotes[noteId!]
        note.noteTitle = noteTitle
        note.noteBody = noteBody
        note.dateUpdated = dateNow
        
        CoreDataStackManager.sharedInstance().saveContext()
        saveBarButtonItem.enabled = false
    }

    @IBAction func cancelTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
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
        saveBarButtonItem.enabled = true
        return true
    }
    
    // MARK: UITextViewDelegate

    func textViewDidChange(textView: UITextView) {
        saveBarButtonItem.enabled = true
    }
}
