//
//  ChatViewController.swift
//  Chat
//
//  Created by User on 8/26/21.
//

import TDLib
import MessageKit
import InputBarAccessoryView
import UIKit

class ChatViewController: MessagesViewController {
    
    var messages: [Message] = []
    var tdLibMessages: Messages!
    var currentUser = Sender(senderId: "123", displayName: "Pavel Boltromyuk")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
        layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
        layout.textMessageSizeCalculator.incomingAvatarSize = .zero
        }
        
        title = "Test"
        
        messages.append(Message(userId: currentUser.senderId, content: "Hello", displayName: currentUser.displayName))
        messages.append(Message(userId: "2", content: "Hello, How are you?", displayName: "Test"))
        messages.append(Message(userId: currentUser.senderId, content: "I'm fine, thank you", displayName: currentUser.displayName))
        messages.append(Message(userId: "2", content: "How you weekends?", displayName: "Test"))
        messages.append(Message(userId: currentUser.senderId, content: "Good", displayName: currentUser.displayName))
        messages.append(Message(userId: "2", content: "I went to fishing", displayName: "Test"))
    }
}

// MARK: - MessagesDataSource
extension ChatViewController: MessagesDataSource {

    func currentSender() -> SenderType {
        return currentUser
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = "Test"
        return NSAttributedString(
          string: name,
          attributes: [
            .font: UIFont.preferredFont(forTextStyle: .caption1),
            .foregroundColor: UIColor(white: 0.3, alpha: 1)
          ]
        )
      }
}

// MARK: - InputBarAccessoryViewDelegate
extension ChatViewController: InputBarAccessoryViewDelegate {
  func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
    print("Press")
    TDManager.shared.sendMessage(id: 852357644) { result in
        switch result {
        case .success(let result):
            print(result)
        case .failure(let error):
            print(error)
        }
    }
    let message = Message(userId: currentUser.senderId, content: text, displayName: currentUser.displayName)
    messages.append(message)
    inputBar.inputTextView.text = ""
    messagesCollectionView.reloadData()
    self.messagesCollectionView.scrollToLastItem()
  }
}

// MARK: - MessagesDisplayDelegate
extension ChatViewController: MessagesDisplayDelegate {
//  func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
//    return .blue
//  }

  func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool {
    return false
  }

  func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
    avatarView.isHidden = true
  }

  func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
    let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
    return .bubbleTail(corner, .curved)
  }
}

// MARK: - MessagesLayoutDelegate
extension ChatViewController: MessagesLayoutDelegate {
  func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
    return CGSize(width: 0, height: 8)
  }

  func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
    return 20
  }
}
