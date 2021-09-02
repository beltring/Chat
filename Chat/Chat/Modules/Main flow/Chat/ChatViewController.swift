//
//  ChatViewController.swift
//  Chat
//
//  Created by User on 8/26/21.
//

import TDLib
import MessageKit
import InputBarAccessoryView
import Photos
import UIKit

class ChatViewController: MessagesViewController {
    
    var chat: Chat!
    var user: User!
    
    private var messages: [Message] = []
    private var currentUser: Sender!
    private var sendPhotoUrl: String = ""
    private var isSendingPhoto = false {
        didSet {
            messageInputBar.leftStackViewItems.forEach { item in
                guard let item = item as? InputBarButtonItem else {
                    return
                }
                item.isEnabled = !self.isSendingPhoto
            }
        }
    }
    
    // MARK: - Lifecycle
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
        
        title = chat.title
        prepareDataSource()
        addCameraBarButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.messagesCollectionView.scrollToLastItem()
    }
    
    // MARK: - Setup
    private func prepareDataSource() {
        messages = chat.messages
    }
    
    private func addCameraBarButton() {
        // 1
        let cameraItem = InputBarButtonItem(type: .system)
        cameraItem.tintColor = .darkGray
        cameraItem.image = UIImage(named: "camera")
        
        // 2
        cameraItem.addTarget(
            self,
            action: #selector(cameraButtonPressed),
            for: .primaryActionTriggered)
        cameraItem.setSize(CGSize(width: 60, height: 30), animated: false)
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
        
        // 3
        messageInputBar
            .setStackViewItems([cameraItem], forStack: .left, animated: false)
    }
    
    // MARK: - Actions
    @objc private func cameraButtonPressed() {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true)
    }
    
    // MARK: - Logic
    private func sendPhoto(_ image: UIImage) {
        isSendingPhoto = true
        
        let content: InputMessageContent = .inputMessagePhoto(photo: InputFile.local(path: sendPhotoUrl), thumbnail: InputThumbnail(thumbnail: .none, width: .none, height: .none), addedStickerFileIds: [], width: 100, height: 100, caption: FormattedText(text: "test", entities: .none), ttl: 0)
        TDManager.shared.sendMessage(id: chat.id, content: content) { result in
            switch result {
            case .success(let result):
                print(result)
            case .failure(let error):
                print(error)
            }
        }
        let message = Message(sender: currentUser, content: "test photo message", image: UIImage(contentsOfFile: sendPhotoUrl)!)
        messages.append(message)
        self.chat.messages.append(message)

        messagesCollectionView.reloadData()
        self.messagesCollectionView.scrollToLastItem()
    }
}

// MARK: - MessagesDataSource
extension ChatViewController: MessagesDataSource {
    
    func currentSender() -> SenderType {
        let name = "\(user.firstName) \(user.lastName))"
        let senderId = String(user.id)
        currentUser = Sender(senderId: senderId, displayName: name)
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
        let content: InputMessageContent = .inputMessageText(text: FormattedText(text: text, entities: .none), disableWebPagePreview: false, clearDraft: false)
        TDManager.shared.sendMessage(id: chat.id, content: content) { result in
            switch result {
            case .success(let result):
                print(result)
            case .failure(let error):
                print(error)
            }
        }
        let message = Message(userId: currentUser.senderId, content: text, displayName: currentUser.displayName)
        messages.append(message)
        self.chat.messages.append(message)
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

// MARK: - UIImagePickerControllerDelegate&UINavigationControllerDelegate
extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        picker.dismiss(animated: true)
        
        if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            let imgName = imgUrl.lastPathComponent
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let localPath = documentDirectory?.appending(imgName)
            
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            let data = image.pngData()! as NSData
            data.write(toFile: localPath!, atomically: true)
            //let imageData = NSData(contentsOfFile: localPath!)!
//            let photoURL = URL.init(fileURLWithPath: localPath!)//NSURL(fileURLWithPath: localPath!)
            sendPhotoUrl = localPath!
        }
        
        //        // 1
        //        if let asset = info[.phAsset] as? PHAsset {
        //            let size = CGSize(width: 500, height: 500)
        //            PHImageManager.default().requestImage(
        //                for: asset,
        //                targetSize: size,
        //                contentMode: .aspectFit,
        //                options: nil
        //            ) { result, _ in
        //                guard let image = result else {
        //                    return
        //                }
        //                print(image)
        //                //          self.sendPhoto(image)
        //            }
        //
        //            // 2
        //        } else if let image = info[.originalImage] as? UIImage {
        //            //            sendPhoto(image)
        //            print(image)
        //        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
