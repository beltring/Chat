//
//  ChatViewController.swift
//  Chat
//
//  Created by User on 8/26/21.
//

import AVKit
import TDLib
import InputBarAccessoryView
import MessageKit
import Photos
import UIKit

class ChatViewController: MessagesViewController {
    
    var chat: Chat!
    var user: User!
    
    private var messages: [Message] = []
    private var currentUser: Sender!
    private var sendPhotoUrl: String = ""
    private var timer: Timer?
    private lazy var audioController = BasicAudioController(messageCollectionView: messagesCollectionView)
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
        
        title = chat.title
        setupMessageCollectionView()
        prepareDataSource()
        addCameraBarButton()
        setupMessageInputBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        messagesCollectionView.scrollToLastItem()
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(getMessages), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
        timer = nil
        audioController.stopAnyOngoingPlaying()
    }
    
    // MARK: - Setup
    private func prepareDataSource() {
        messages = chat.messages
    }
    
    private func setupMessageCollectionView() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        scrollsToLastItemOnKeyboardBeginsEditing = true
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
            layout.photoMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.photoMessageSizeCalculator.incomingAvatarSize = .zero
        }
        
    }
    
    private func setupMessageInputBar() {
        if chat.isChannel {
            messageInputBar.isHidden = true
        }
    }
    
    private func addCameraBarButton() {
        let cameraItem = InputBarButtonItem(type: .system)
        cameraItem.tintColor = .darkGray
        cameraItem.image = UIImage(named: "camera")
        
        cameraItem.addTarget(
            self,
            action: #selector(cameraButtonPressed),
            for: .primaryActionTriggered)
        cameraItem.setSize(CGSize(width: 60, height: 30), animated: false)
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
        
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
    private func sendPhoto() {
        isSendingPhoto = true
        
        let inputThumbnail = InputThumbnail(thumbnail: .none, width: .none, height: .none)
        let text = FormattedText(text: .none, entities: .none)
        let photo = InputFile.local(path: sendPhotoUrl)
        let content: InputMessageContent = .inputMessagePhoto(photo: photo, thumbnail: inputThumbnail, addedStickerFileIds: [], width: 250, height: 250, caption: text, ttl: 0)
        TDManager.shared.sendMessage(id: chat.id, content: content) { [weak self] result in
            switch result {
            case .success(let result):
                print(result)
            case .failure:
                self?.presentAlert(title: "Error", message: "The image size is large")
            }
        }
        let message = Message(sender: currentUser, content: "test photo message", image: UIImage(contentsOfFile: sendPhotoUrl)!)
        messages.append(message)
        self.chat.messages.append(message)
        
        messagesCollectionView.reloadData()
        self.messagesCollectionView.scrollToLastItem()
    }
    
    // MARK: - API calls
    @objc private func getMessages() {
        TDManager.shared.getChatHistory(chatId: chat.id) { [weak self] result in
            switch result {
            case .success(let messages):
                guard let self = self else { return }
                let newMessages = messages.convertToArrayMessages()
                if self.messages.count != newMessages.count {
                    self.messages = newMessages
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToLastItem(at: .bottom, animated: false)
                    AudioServicesPlaySystemSound(1022)
                }
            case .failure(let error):
                self?.presentAlert(title: "Error Get chat history", message: error.localizedDescription)
            }
        }
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
        return 5
    }
}

extension ChatViewController: MessageCellDelegate {
    func didTapMessage(in cell: MessageCollectionViewCell) {
        if let indexPath = messagesCollectionView.indexPath(for: cell) {
            let message = messages[indexPath.section]
            
            switch message.kind {
            case .video(let videoItem):
                if let videoUrl = videoItem.url {
                    let player = AVPlayer(url: videoUrl)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    present(playerViewController, animated: true) {
                        playerViewController.player!.play()
                    }
                }
            default:
                break
            }
        }
    }
    
    func didTapImage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else { return }
        guard let messagesDataSource = messagesCollectionView.messagesDataSource else { return }
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        let vc = PhotoViewController.initial()
        switch message.kind {
        case .photo(let photoItem):
            if let image = photoItem.image {
                vc.photoImage = image
                present(vc, animated: true, completion: nil)
            }
        case .video(let videoItem):
            if let videoUrl = videoItem.url {
                let player = AVPlayer(url: videoUrl)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                present(playerViewController, animated: true) {
                    playerViewController.player!.play()
                }
            }
        default:
            break
        }
        
    }
    
    func didTapPlayButton(in cell: AudioMessageCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell),
              let message = messagesCollectionView.messagesDataSource?.messageForItem(at: indexPath, in: messagesCollectionView) else {
            print("Failed to identify message when audio cell receive tap gesture")
            return
        }
        guard audioController.state != .stopped else {
            // There is no audio sound playing - prepare to start playing for given audio message
            audioController.playSound(for: message, in: cell)
            return
        }
        if audioController.playingMessage?.messageId == message.messageId {
            // tap occur in the current cell that is playing audio sound
            if audioController.state == .playing {
                audioController.pauseSound(for: message, in: cell)
            } else {
                audioController.resumeSound()
            }
        } else {
            // tap occur in a difference cell that the one is currently playing sound. First stop currently playing and start the sound for given message
            audioController.stopAnyOngoingPlaying()
            audioController.playSound(for: message, in: cell)
        }
    }
    
    func didStartAudio(in cell: AudioMessageCell) {
        print("Did start playing audio sound")
    }
    
    func didPauseAudio(in cell: AudioMessageCell) {
        print("Did pause audio sound")
    }
    
    func didStopAudio(in cell: AudioMessageCell) {
        print("Did stop audio sound")
    }
    
}

// MARK: - UIImagePickerControllerDelegate&UINavigationControllerDelegate
extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        picker.dismiss(animated: true)
        
        if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            let imgName = imgUrl.lastPathComponent
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let localPath = documentDirectory?.appending(imgName)
            
            let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            guard let img = image else { return }
            let data = img.pngData()! as NSData
            data.write(toFile: localPath!, atomically: true)
            sendPhotoUrl = localPath!
            sendPhoto()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
