//
//  ContactTableViewCell.swift
//  Chat
//
//  Created by User on 8/25/21.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(name: String) {
        nameLabel.text = name
    }
}
