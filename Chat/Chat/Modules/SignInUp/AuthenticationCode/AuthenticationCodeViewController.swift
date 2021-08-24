//
//  AuthenticationCodeViewController.swift
//  Chat
//
//  Created by User on 8/23/21.
//

import UIKit

class AuthenticationCodeViewController: UIViewController {

    @IBOutlet weak var codeTextField: UITextField!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
    }

    // MARK: - Setup
    private func setupNavigationBar() {
        navigationItem.title = "Code"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(nextTapped))
    }
    
    // MARK: - Actions
    @objc private func nextTapped() {
        guard let code = codeTextField.text else { return }
        TDManager.shared.checkCode(code: code) { [weak self] result in
            switch result {
            case.success:
                self?.navigationController?.pushViewController(RootTabBarViewController.initial(), animated: true)
            case .failure(let error):
                self?.presentAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}
