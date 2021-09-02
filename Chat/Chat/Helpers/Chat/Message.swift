//
//  Message.swift
//  Chat
//
//  Created by User on 8/26/21.
//

import Foundation
import TDLib
import MessageKit
import UIKit

struct Message: MessageType {
    let id: String?
    var messageId: String {
        return id ?? UUID().uuidString
    }
    let content: String
    let sentDate: UIKit.Date
    let sender: SenderType
    var kind: MessageKind {
        if let image = image {
          let mediaItem = ImageMediaItem(image: image)
          return .photo(mediaItem)
        } else {
          return .text(content)
        }
    }
    
    var image: UIImage?
    var downloadURL: URL?
    
    init(user: User, content: String, displayName: String) {
        let userId = String(user.id)
        sender = Sender(senderId: userId, displayName: displayName)
        self.content = content
        sentDate = Date()
        id = nil
    }
    
    init(userId: String, content: String, displayName: String) {
        sender = Sender(senderId: userId, displayName: displayName)
        self.content = content
        sentDate = Date()
        id = nil
    }
    
    init(sender: Sender, content: String, image: UIImage) {
        self.sender = sender
        self.content = content
        self.image = image
        sentDate = Date()
        self.id = nil
    }
    
    init(id: Int64, sender: Sender, content: String, date: Int32, image: UIImage? = nil) {
        self.sender = sender
        self.content = content
        sentDate = UIKit.Date(timeIntervalSince1970: TimeInterval(date))
        self.id = String(id)
        guard let img = image else { return }
        self.image = img
    }
}

// MARK: - Comparable
extension Message: Comparable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
}
