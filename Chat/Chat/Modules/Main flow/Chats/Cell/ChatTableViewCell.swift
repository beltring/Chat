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
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(name: String, content: String, lastMessageTime: String) {
        chatNameLabel.text = name
        chatImage.image = UIImage(named: "icNoImage")
        contentLabel.text = content
        timeLabel.text = lastMessageTime
    }
}
