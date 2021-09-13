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
                var audioItem: Audioitem?
                var pathImage: String = ""
                switch item.content {
                case .messageText(text: let text, webPage: nil):
                    content = text.text ?? "default"
                case .messagePhoto(photo: let photo, caption: let caption, isSecret: false):
                    description = caption.text ?? ""
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
                case .messageVoiceNote(voiceNote: let voiceNote, caption: _, isListened: _):
                    let voiceId = voiceNote.voice.id
                    let duration = Float(voiceNote.duration)
                    if voiceNote.voice.local.path == "" {
                        TDManager.shared.downloadFile(id: voiceId) { result in
                            switch result {
                            case .success(let result):
                                let url = URL(fileURLWithPath: voiceNote.voice.local.path)
                                audioItem = Audioitem(url: url, duration: duration, size: .init(width: 150, height: 40))
                                print(result)
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                    } else {
                        let url = URL(fileURLWithPath: voiceNote.voice.local.path)
                        audioItem = Audioitem(url: url, duration: duration, size: .init(width: 150, height: 40))
                    }
                    
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
                let message = Message(id: id, sender: sender, content: content, date: date, image: image, audioItem: audioItem)
                messages.append(message)
            }
            return messages.reversed()
        } else {
            return messages
        }
    }
}
