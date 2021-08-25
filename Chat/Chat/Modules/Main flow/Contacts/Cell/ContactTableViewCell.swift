//
//  ContactTableViewCell.swift
//  Chat
//
//  Created by User on 8/25/21.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet private weak var profileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(name: String, status: String) {
        nameLabel.text = name
        statusLabel.text = status
    }
}
