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
                var description = ""
                var image: UIImage?
                switch item.content {
                case .messageText(text: let text, webPage: nil):
                    content = text.text ?? "default"
                case .messagePhoto(photo: let photo, caption: let caption, isSecret: false):
                    description = caption.text ?? ""
//                    print(photo)
                    let path = photo.sizes.first { $0.type == "m" || $0.type == "s" || $0.type == "i"}?.photo.local.path
                    
                    if path != "" {
                        image = UIImage(contentsOfFile: path!)
                    } else {
                        let photoId = photo.sizes.first { $0.type == "m" || $0.type == "s"}?.photo.id
                        TDManager.shared.downloadFile(id: photoId) { result in
                            switch result {
                            case .success(let file):
                                image = UIImage(contentsOfFile: file.local.path)
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                    }
                case .messageSticker(sticker: let sticker):
                    content = sticker.emoji
                default:
                    print("Content: \(item.content)")
                }
                let date = item.date
                let id = item.id
                let sender = Sender(senderId: userId, displayName: "Test")
                if description != "" {
                    let descriptionMessage = Message(id: id, sender: sender, content: description, date: date)
                    messages.append(descriptionMessage)
                }
                let message = Message(id: id, sender: sender, content: content, date: date, image: image)
                messages.append(message)
            }
            return messages.reversed()
        } else {
            return messages
        }
    }
}
