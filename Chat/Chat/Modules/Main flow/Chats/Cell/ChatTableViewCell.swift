//
//  ChatTableViewCell.swift
//  Chat
//
//  Created by User on 8/24/21.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var chatImage: UIImageView!
    @IBOutlet private weak var chatNameLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        chatImage.layer.cornerRadius = chatImage.frame.height / 2.0
    }
    
    // MARK: - Setup
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
