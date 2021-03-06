//
//  ChatsViewController.swift
//  Chat
//
//  Created by User on 8/24/21.
//

import TDLib
import UIKit

class ChatsViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    var activityView: UIView & INavigationBarProgressView = NavigationBarProgressView(
        config: .init(
            interItemSpace: 8,
            regularTitle: "Chats",
            pendingTitle: "Updating...",
            titleFont: .systemFont(ofSize: 16, weight: .medium)
        )
    )
    
    private var dataSource = [TDLib.Chat]()
    private var currentUser: User!
    private let refreshControl = UIRefreshControl()
    private var lastIndexPath = IndexPath(row: 0, section: 0)
    private let activityIndicator = UIActivityIndicatorView(style: .gray)
    private var isPending: Bool = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        prepareDataSource()
        getUser()
        setupRefreshControl()
        self.attach(navigationActivityView: self.activityView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationController?.setNavigationBarHidden(true, animated: animated)
        prepareDataSource()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Setup
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        ChatTableViewCell.registerCellNib(in: tableView)
    }
    
    private func setupRefreshControl() {
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshChats(_:)), for: .valueChanged)
    }
    
    private func prepareDataSource() {
        dataSource = []
        TDManager.shared.getChats { [weak self] result in
            switch result {
            case .success(let chats):
                print(chats.chatIds.count)
                for id in chats.chatIds {
                    TDManager.shared.getChat(chatId: id) { [weak self] res in
                        switch res {
                        case .success(let chat):
                            //                            print(chat)
                            DispatchQueue.main.async {
                                self?.dataSource.append(chat)
                                self?.tableView.reloadData()
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }            
                self?.tableView.reloadData()
                self?.refreshControl.endRefreshing()
                self?.stopNavigationActivity()
                self?.isPending.toggle()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Actions    
    @objc private func refreshChats(_ sender: Any) {
        if isPending {
              stopNavigationActivity()
        } else {
            startNavigationActivity()
        }
        isPending.toggle()
        prepareDataSource()
    }
    
    // MARK: - API calls
    private func getUser() {
        TDManager.shared.getCurrentUser { [weak self] result in
            switch result {
            case .success(let user):
                self?.currentUser = user
            case .failure(let error):
                self?.presentAlert(title: error.localizedDescription)
            }
        }
    }
}

// MARK: - Extensions
// MARK: - UITableViewDataSource
extension ChatsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ChatTableViewCell.dequeueReusableCell(in: tableView, for: indexPath)
        
        let chat = dataSource[indexPath.row]
        let date = DateFormatter().convert(timeInterval: chat.lastMessage?.date)
        let title = chat.title
        var chatImg: UIImage?
        var content = ""
        switch chat.lastMessage?.content {
        case .messageText(text: let text, webPage: nil):
            content = text.text ?? "default"
        case .messagePhoto(photo: _, caption: let formattedText, isSecret: _):
            content = formattedText.text ?? "Photo"
        default:
            content = "Multimedia content"
        }
        
        if let photo = chat.photo {
            if photo.small.local.path != "" {
                chatImg = UIImage(contentsOfFile: photo.small.local.path)
                cell.configure(name: title, content: content, lastMessageTime: date, chatImage: chatImg)
            } else {
                TDManager.shared.downloadFile(id: photo.small.id) { [weak self] result in
                    switch result {
                    case .success(let file):
                        chatImg = UIImage(contentsOfFile: file.local.path)
                        cell.configure(name: title, content: content, lastMessageTime: date, chatImage: chatImg)
                    case .failure(let error):
                        self?.presentAlert(title: "Error Download", message: error.localizedDescription)
                    }
                }
            }
        } else {
            cell.configure(name: title, content: content, lastMessageTime: date, chatImage: UIImage(named: "person.crop.circle.badge.xmark"))
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ChatsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chatTD = dataSource[indexPath.row]
        let chatId = chatTD.id
        let title = chatTD.title
        var isChannel = false
        lastIndexPath = indexPath
        
        switch chatTD.type {
        case .supergroup(supergroupId: _, isChannel: let res):
            isChannel = res
        default:
            isChannel = false
        }
        
        TDManager.shared.getChatHistory(chatId: chatId) { [weak self] result in
            switch result {
            case .success(let messages):
                let vc = ChatViewController.initial()
                vc.chat = Chat(id: chatId, title: title, messages: messages.convertToArrayMessages(), isChannel: isChannel)
                vc.user = self?.currentUser
                self?.tabBarController?.navigationController?.pushViewController(vc, animated: true)
            case .failure(let error):
                self?.presentAlert(title: "Error Get chat history", message: error.localizedDescription)
            }
        }
    }
}

// MARK: - IAttachableNavigationBarProgressContainer
extension ChatsViewController: IAttachableNavigationBarProgressContainer {
  public func attach(navigationActivityView: INavigationBarProgressView & UIView) {
    self.navigationItem.titleView = navigationActivityView
  }
}

// MARK: - INavigationBarProgressContainer
extension ChatsViewController: INavigationBarProgressContainer {
}
