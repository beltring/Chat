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
        return .text(content)
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
    
//    init(user: User, image: UIImage) {
//        let userId = String(user.id)
//        sender = Sender(senderId: userId, displayName: displayName)
//        self.image = image
//        content = ""
//        sentDate = Date()
//        id = nil
//    }
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
