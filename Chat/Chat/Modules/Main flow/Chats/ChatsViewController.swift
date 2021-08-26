//
//  ChatsViewController.swift
//  Chat
//
//  Created by User on 8/24/21.
//

import UIKit

class ChatsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var dataSource = [Int64]()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        tabBarController?.navigationItem.title = "Chats"
        setupNavigationItem()
        prepareDataSource()
    }
    
    // MARK: - Setup
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        ChatTableViewCell.registerCellNib(in: tableView)
    }
    
    private func setupNavigationItem() {
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(tappedUpdate))
    }
    
    private func prepareDataSource() {
        TDManager.shared.getChats { [weak self] result in
            switch result {
            case .success(let chats):
                print(chats.chatIds.count)
                self?.dataSource = chats.chatIds
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func tappedUpdate() {
        prepareDataSource()
    }
}

// MARK: - Extensions
// MARK: - UITableViewDataSource&UITableViewDelegate
extension ChatsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ChatTableViewCell.dequeueReusableCell(in: tableView, for: indexPath)
        
        return cell
    }
}
