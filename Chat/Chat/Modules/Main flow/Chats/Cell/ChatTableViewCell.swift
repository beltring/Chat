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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
