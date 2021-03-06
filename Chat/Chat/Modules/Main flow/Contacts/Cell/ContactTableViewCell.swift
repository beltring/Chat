//
//  ContactTableViewCell.swift
//  Chat
//
//  Created by User on 8/25/21.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var profileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutIfNeeded()
        profileImage.layer.cornerRadius = profileImage.frame.height / 2.0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = nil
        statusLabel.text = nil
        profileImage.image = nil
    }
    
    func configure(name: String, status: String, profileImage: UIImage?) {
        nameLabel.text = name
        statusLabel.text = status
        if let img = profileImage {
            self.profileImage.image = img
        } else {
            self.profileImage.image = UIImage(named: "ImgNoImage")
        }
    }
}
