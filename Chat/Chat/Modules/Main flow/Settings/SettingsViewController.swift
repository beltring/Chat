//
//  SettingsViewController.swift
//  Chat
//
//  Created by User on 8/24/21.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var appearanceStackView: UIStackView!
    @IBOutlet weak var switchTheme: UISwitch!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarController?.navigationItem.title = "Settings"
        prepareUI()
    }
    
    // MARK: - Setup
    private func prepareUI() {
        if DataUDManager.shared.appearance == "dark" {
            switchTheme.setOn(true, animated: false)
        }
        
        if #available(iOS 13, *) {
            appearanceStackView.isHidden = false
        }
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
    
    @IBAction private func tappedSwitchTheme(_ sender: UISwitch) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        if sender.isOn {
            UserDefaults.standard.set("dark", forKey: "appearance")
            appDelegate.changeTheme()
        } else {
            UserDefaults.standard.set("light", forKey: "appearance")
            appDelegate.changeTheme()
        }
    }
}
