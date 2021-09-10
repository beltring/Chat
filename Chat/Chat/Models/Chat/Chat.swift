//
//  Chat.swift
//  Chat
//
//  Created by User on 8/30/21.
//

import Foundation

struct Chat {
    let id: Int64
    let title: String
    let isChannel: Bool
    var messages: [Message]
    
    init(id: Int64, title: String, messages: [Message]) {
        self.id = id
        self.title = title
        self.messages = messages
        self.isChannel = false
    }
    
    init(id: Int64, title: String, messages: [Message], isChannel: Bool) {
        self.id = id
        self.title = title
        self.messages = messages
        self.isChannel = isChannel
    }
}
