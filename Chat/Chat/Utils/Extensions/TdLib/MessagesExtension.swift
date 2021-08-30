//
//  MessagesExtension.swift
//  Chat
//
//  Created by User on 8/30/21.
//

import Foundation
import TDLib

extension Messages {
    func convertToArrayMessages() -> [Message] {
        var messages = [Message]()
        
        if totalCount > 0 {
            for item in self.messages! {
                let userId = item.senderUserId
                var content = ""
                switch item.content {
                case .messageText(text: let text, webPage: nil):
                    content = text.text ?? "default"
                default:
                    print("Default")
                }
                let date = item.date
                let id = item.id
                let message = Message(id: id, userId: userId, content: content, displayName: "test", date: date)
                messages.append(message)
            }
            return messages.reversed()
        } else {
            return messages
        }
    }
}
