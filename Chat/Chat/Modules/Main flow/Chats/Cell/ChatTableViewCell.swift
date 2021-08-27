//
//  ChatTableViewCell.swift
//  Chat
//
//  Created by User on 8/24/21.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var chatImage: UIImageView!
    @IBOutlet weak var chatNameLabel: UILabel!
    @IBOutlet weak var chatTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(name: String, lastMessagesDate: String) {
        chatNameLabel.text = name
        chatImage.image = UIImage(named: "icNoImage")
        chatTypeLabel.text = lastMessagesDate
    }
}
