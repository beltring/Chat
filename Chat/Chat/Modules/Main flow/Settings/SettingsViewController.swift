//
//  SettingsViewController.swift
//  Chat
//
//  Created by User on 8/24/21.
//

import UIKit

class SettingsViewController: UIViewController {

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Actions
    @IBAction func tappedLogOut(_ sender: UIButton) {
        TDManager.shared.logOut { [weak self] result in
            switch result {
            case .success:
                AuthorizeData.shared.isAuthorized = false
                guard let nav = self?.navigationController as? RootNavigationViewController else { return }
                nav.setRootController()
            case .failure(let error):
                self?.presentAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}
