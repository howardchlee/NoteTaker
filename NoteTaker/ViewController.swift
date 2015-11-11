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
            return (UIApplication.sharedApplication().delegate as! AppDelegate).allNotes
        }
        set {
            (UIApplication.sharedApplication().delegate as! AppDelegate).allNotes = newValue
        }
    }
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem:
            UIBarButtonSystemItem.Add, target: self, action: "addButtonTapped")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
        navigationController?.pushViewController(noteEditorController, animated: true)
        
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
}

