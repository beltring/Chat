//
//  ChatsViewController.swift
//  Chat
//
//  Created by User on 8/24/21.
//

import TDLib
import UIKit

class ChatsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource = [TDLib.Chat]()
    private var currentUser: User!
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupNavigationItem()
        prepareDataSource()
        setupCurrentUser()
        setupRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationController?.setNavigationBarHidden(true, animated: animated)
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
    
    private func setupNavigationItem() {
        navigationItem.title = "Chats"
    }
    
    private func setupCurrentUser() {
        TDManager.shared.getCurrentUser { [weak self] result in
            switch result {
            case .success(let user):
                self?.currentUser = user
            case .failure(let error):
                self?.presentAlert(title: "Error", message: error.localizedDescription)
            }
        }
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
                            DispatchQueue.main.async {
                                self?.dataSource.append(chat)
                                self?.tableView.reloadData()
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                    self?.refreshControl.endRefreshing()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Actions    
    @objc private func refreshChats(_ sender: Any) {
        prepareDataSource()
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
        cell.configure(name: title, lastMessagesDate: date)
        
        return cell
    }
}

// MARK: - UITableViewDataSource&UITableViewDelegate
extension ChatsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chatId = dataSource[indexPath.row].id
        let title = dataSource[indexPath.row].title
        TDManager.shared.getChatHistory(chatId: chatId) { [weak self] result in
            switch result {
            case .success(let messages):
                print(messages)
                let vc = ChatViewController.initial()
                vc.chat = Chat(id: chatId, title: title, messages: messages.convertToArrayMessages())
                vc.user = self?.currentUser
                self?.tabBarController?.navigationController?.pushViewController(vc, animated: true)
            case .failure(let error):
                self?.presentAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}
