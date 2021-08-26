//
//  ChatViewController.swift
//  Chat
//
//  Created by User on 8/26/21.
//

import MessageKit
import UIKit

class ChatViewController: MessagesViewController {

//    private var messages: [Message] = []
//    private var messageListener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}

// MARK: - MessagesDataSource
//extension ChatViewController: MessagesDataSource {
//  // 1
//  func numberOfSections(
//    in messagesCollectionView: MessagesCollectionView
//  ) -> Int {
//    return messages.count
//  }
//
//  // 2
//  func currentSender() -> SenderType {
//    return Sender(senderId: "123", displayName: "Test")
//  }
//
//  // 3
//  func messageForItem(
//    at indexPath: IndexPath,
//    in messagesCollectionView: MessagesCollectionView
//  ) -> MessageType {
//    return messages[indexPath.section]
//  }
//
//  // 4
//  func messageTopLabelAttributedText(
//    for message: MessageType,
//    at indexPath: IndexPath
//  ) -> NSAttributedString? {
//    let name = message.sender.displayName
//    return NSAttributedString(
//      string: name,
//      attributes: [
//        .font: UIFont.preferredFont(forTextStyle: .caption1),
//        .foregroundColor: UIColor(white: 0.3, alpha: 1)
//      ])
//  }
//}
