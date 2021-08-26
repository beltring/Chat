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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.navigationItem.title = "Contacts"
        setupTablewView()
        prepareDataSource()
    }

    // MARK: - Setup
    private func setupTablewView() {
        tableView.delegate = self
        tableView.dataSource = self
        ContactTableViewCell.registerCellNib(in: tableView)
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
        cell.configure(name: name, status: status)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = dataSource[indexPath.row]
        
        TDManager.shared.createPrivateChat(userId: user.id) { [weak self] result in
            switch result {
            case .success(let chat):
                print(chat)
                let vc = ChatViewController.initial()
                self?.tabBarController?.navigationController?.pushViewController(vc, animated: true)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
