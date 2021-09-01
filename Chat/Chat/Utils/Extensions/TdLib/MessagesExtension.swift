//
//  MessagesExtension.swift
//  Chat
//
//  Created by User on 8/30/21.
//

import Foundation
import TDLib
import UIKit

extension Messages {
    func convertToArrayMessages() -> [Message] {
        var messages = [Message]()
        
        if totalCount > 0 {
            for item in self.messages! {
                let userId = String(item.senderUserId)
                var content = ""
                var image: UIImage?
                switch item.content {
                case .messageText(text: let text, webPage: nil):
                    content = text.text ?? "default"
                case .messagePhoto(photo: let photo, caption: let caption, isSecret: false):
                    content = caption.text ?? ""
                    if let data = photo.minithumbnail?.data {
                        image = UIImage(data: data)
                    }
                case .messageSticker(sticker: let sticker):
                    content = sticker.emoji
                default:
                    print("Content: \(item.content)")
                }
                let date = item.date
                let id = item.id
                let sender = Sender(senderId: userId, displayName: "Test")
                let message = Message(id: id, sender: sender, content: content, date: date, image: image)
                messages.append(message)
            }
            return messages.reversed()
        } else {
            return messages
        }
    }
}
