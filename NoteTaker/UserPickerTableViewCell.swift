//
//  UserPickerTableViewCell.swift
//  NoteTaker
//
//  Created by howard.lee on 11/15/15.
//  Copyright © 2015 howard.lee. All rights reserved.
//

import Foundation
import UIKit

class UserPickerTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!

    var name: String = "" {
        didSet {
            nameLabel.text = name
        }
    }

    var count: Int = 0 {
        didSet {
            countLabel.text = "\(count) notes"
        }
    }
}
