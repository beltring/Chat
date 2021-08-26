//
//  ChatViewController.swift
//  Chat
//
//  Created by User on 8/26/21.
//

import MessageKit
import UIKit

class ChatViewController: MessagesViewController {

    let sender = Sender(senderId: "any_unique_id", displayName: "Steven")
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarController?.navigationItem.title = "TEST"
        messages.append(Message(userId: "1233333", content: "test message", displayName: "Valery"))
        TDManager.shared.getChats { result in
            switch result {
            case .success(let chats):
                print(chats.chatIds.count)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

// MARK: - MessagesDataSource
extension ChatViewController: MessagesDataSource {

    func currentSender() -> SenderType {
        return Sender(senderId: "1234", displayName: "Steven")
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
}

// MARK: - MessagesDisplayDelegate&MessagesLayoutDelegate
extension ChatViewController: MessagesDisplayDelegate, MessagesLayoutDelegate {}
