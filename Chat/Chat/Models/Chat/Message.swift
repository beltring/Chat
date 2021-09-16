//
//  Message.swift
//  Chat
//
//  Created by User on 8/26/21.
//

import Foundation
import MessageKit
import TDLib
import UIKit

struct Message: MessageType {
    let id: String?
    var messageId: String {
        return id ?? UUID().uuidString
    }
    let content: String
    let sentDate: UIKit.Date
    let sender: SenderType
    var image: UIImage?
    var audioItem: Audioitem?
    var videoPath = ""
    var linkItem: LinkItem?
    
    var kind: MessageKind {
        if let image = image {
            let mediaItem = ChatMediaItem(image: image)
            return .photo(mediaItem)
        } else if let audioItem = audioItem {
            return .audio(audioItem)
        } else if videoPath != "" {
            let url = URL(fileURLWithPath: videoPath)
            let mediaItem = ChatMediaItem(url: url)
            return .video(mediaItem)
        } else if let linkItem = linkItem {
            return .linkPreview(linkItem)
        } else {
            return .text(content)
        }
    }
    
    // MARK: - Init
    init(sender: Sender, content: String) {
        self.sender = sender
        self.content = content
        sentDate = Date()
        id = nil
    }
    
    init(sender: Sender, image: UIImage?) {
        self.sender = sender
        self.content = ""
        self.image = image
        sentDate = Date()
        self.id = nil
    }
    
    init(id: String, sender: Sender, date: Int32, content: String = "") {
        self.sender = sender
        self.content = content
        sentDate = UIKit.Date(timeIntervalSince1970: TimeInterval(date))
        self.id = id
    }
    
    init(id: String, sender: Sender, date: Int32, image: UIImage?, content: String = "") {
        self.init(id: id, sender: sender, date: date, content: content)
        self.image = image
    }
    
    init(id: String, sender: Sender, date: Int32, audioItem: Audioitem?, content: String = "") {
        self.init(id: id, sender: sender, date: date, content: content)
        self.audioItem = audioItem
    }
    
    init(id: String, sender: Sender, content: String, date: Int32, videoPath: String) {
        self.init(id: id, sender: sender, date: date, content: content)
        self.videoPath = videoPath
    }
    
    init(id: String, sender: Sender, date: Int32, linkItem: LinkItem?) {
        self.init(id: id, sender: sender, date: date)
        self.linkItem = linkItem
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
