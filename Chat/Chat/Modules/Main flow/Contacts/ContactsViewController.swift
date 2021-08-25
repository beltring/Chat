//
//  ContactsViewController.swift
//  Chat
//
//  Created by User on 8/25/21.
//

import UIKit

class ContactsViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Setup
    private func setupTablewView() {
        tableView.delegate = self
        tableView.dataSource = self
        ContactTableViewCell.registerCellNib(in: tableView)
    }
}

// MARK: - Extensions
// MARK: - UITableViewDelegate&UITableViewDataSource
extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ContactTableViewCell.dequeueReusableCell(in: tableView, for: indexPath)
        
        return cell
    }
    
    
}
