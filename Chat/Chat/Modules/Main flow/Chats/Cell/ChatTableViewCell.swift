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
        self.layoutIfNeeded()
        chatImage.layer.cornerRadius = chatImage.frame.height / 2.0
        layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        chatImage.image = nil
        chatNameLabel.text = nil
        contentLabel.text = nil
        timeLabel.text = nil
    }
    
    func configure(name: String, content: String, lastMessageTime: String, chatImage: UIImage?) {
        chatNameLabel.text = name
        contentLabel.text = content
        timeLabel.text = lastMessageTime
        guard let img = chatImage else { return }
        self.chatImage.image = img
    }
}
