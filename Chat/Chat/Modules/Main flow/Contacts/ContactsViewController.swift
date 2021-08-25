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
        TDManager.shared.getContacts { result in
            switch result {
            case .success(let users):
                print("Count: \(users.totalCount)")
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
        cell.configure(name: user.username)
        
        return cell
    }
}
