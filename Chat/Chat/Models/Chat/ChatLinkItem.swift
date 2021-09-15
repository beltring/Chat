//
//  ChatLinkItem.swift
//  Chat
//
//  Created by User on 9/14/21.
//

import Foundation
import MessageKit

struct ChatLinkItem: LinkItem {
    var text: String?
    
    var attributedText: NSAttributedString?
    
    var url: URL
    
    var title: String?
    
    var teaser: String
    
    var thumbnailImage: UIImage
    
    
}
