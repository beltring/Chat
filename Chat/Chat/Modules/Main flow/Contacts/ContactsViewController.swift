//
//  ContactsViewController.swift
//  Chat
//
//  Created by User on 8/25/21.
//

import TDLib
import UIKit

class ContactsViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private var dataSource = [User]()
    private var currentUser: User!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.navigationItem.title = "Contacts"
        setupTablewView()
        prepareDataSource()
        setupCurrentUser()
    }

    // MARK: - Setup
    private func setupTablewView() {
        tableView.delegate = self
        tableView.dataSource = self
        ContactTableViewCell.registerCellNib(in: tableView)
    }
    
    private func setupCurrentUser() {
        TDManager.shared.getCurrentUser { [weak self] result in
            switch result {
            case .success(let user):
                self?.currentUser = user
            case .failure(let error):
                self?.presentAlert(title: "Error Get current user", message: error.localizedDescription)
            }
        }
    }
    
    private func prepareDataSource() {
        TDManager.shared.getContacts { [weak self] result in
            switch result {
            case .success(let users):
                for id in users.userIds {
                    TDManager.shared.getUser(id: id) { [weak self] res in
                        switch res {
                        case .success(let user):
                            DispatchQueue.main.async {
                                self?.dataSource.append(user)
                                self?.tableView.reloadData()
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - Extensions
// MARK: - UITableViewDelegate&UITableViewDataSource
extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ContactTableViewCell.dequeueReusableCell(in: tableView, for: indexPath)
        
        let user = dataSource[indexPath.row]
        let name = "\(user.firstName) \(user.lastName)"
        let status = String(describing: user.status)
        var profileImg: UIImage?

        if let fileId = user.profilePhoto?.small.id {
            TDManager.shared.downloadFile(id: fileId) { [weak self] result in
                switch result {
                case .success(let file):
                    profileImg = UIImage(contentsOfFile: file.local.path)
                    cell.configure(name: name, status: status, profileImage: profileImg)
                case .failure(let error):
                    self?.presentAlert(title: "Error Download", message: error.localizedDescription)
                }
            }
        } else {
            cell.configure(name: name, status: status, profileImage: UIImage(named: "imgNoImage"))
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = dataSource[indexPath.row]
        
        TDManager.shared.createPrivateChat(userId: user.id) { [weak self] result in
            switch result {
            case .success(let chat):
                print(chat)
                TDManager.shared.getChatHistory(chatId: chat.id) { [weak self] result in
                    switch result {
                    case .success(let messages):
                        print(messages)
                        let id = chat.id
                        let title = chat.title
                        let vc = ChatViewController.initial()
                        vc.chat = Chat(id: id, title: title, messages: messages.convertToArrayMessages())
                        vc.user = self?.currentUser
                        self?.tabBarController?.navigationController?.pushViewController(vc, animated: true)
                    case .failure(let error):
                        self?.presentAlert(title: "Error Get chat history", message: error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
