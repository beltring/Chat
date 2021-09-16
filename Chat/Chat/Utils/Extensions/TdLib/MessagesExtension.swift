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
                var videoPath = ""
                var linkItem: ChatLinkItem?
                switch item.content {
                case .messageText(text: let text, webPage: let page):
                    content = text.text ?? "default"
                    if let webPage = page {
                        let url = URL(string: webPage.url)
                        
                        let path = webPage.photo?.sizes.first { $0.type == "m"}?.photo.local.path
                        if path != nil && path != "" {
                            let image = UIImage(contentsOfFile: path!)
                            linkItem = ChatLinkItem(text: text.text, attributedText: .none, url: url!, title: webPage.title, teaser: webPage.description, thumbnailImage: image!)
                        } else {
                            let photoId = webPage.photo?.sizes.first { $0.type == "m" }?.photo.id
                            TDManager.shared.downloadFile(id: photoId) { result in
                                switch result {
                                case .success(let file):
                                    let image = UIImage(contentsOfFile: file.local.path)
                                    linkItem = ChatLinkItem(text: text.text, attributedText: .none, url: url!, title: webPage.title, teaser: webPage.description, thumbnailImage: image!)
                                case .failure(let error):
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    }
                case .messageVideo(video: let video, caption: let caption, isSecret: _):
                    description = caption.text ?? ""
                    let path = video.video.local.path
                    if path != "" {
                        videoPath = path
                    } else {
                        let videoId = video.video.id
                        TDManager.shared.downloadFile(id: videoId) { result in
                            switch result {
                            case .success(let file):
                                videoPath = file.local.path
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                    }
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
                let id = String(item.id)
                let sender = Sender(senderId: userId, displayName: "Test")
                let message = Message(id: id, sender: sender, date: date, image: image, content: content)
                messages.append(message)
                if description != "" {
                    let descriptionMessage = Message(id: id, sender: sender, date: date, content: description)
                    messages.append(descriptionMessage)
                } else if videoPath != "" {
                    let videoMessage = Message(id: id, sender: sender, content: content, date: date, videoPath: videoPath)
                    messages.append(videoMessage)
                } else if let chatLinkItem = linkItem {
                    messages.removeLast()
                    let linkItem = Message(id: id, sender: sender, date: date, linkItem: chatLinkItem)
                    messages.append(linkItem)
                } else if let audioItem = audioItem {
                    let audioMessage = Message(id: id, sender: sender, date: date, audioItem: audioItem, content: content)
                    messages.append(audioMessage)
                }
                
            }
            return messages.reversed()
        } else {
            return messages
        }
    }
}
