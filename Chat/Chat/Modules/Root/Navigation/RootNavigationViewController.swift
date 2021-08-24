//
//  RootNavigationViewController.swift
//  Chat
//
//  Created by User on 8/23/21.
//

import UIKit

class RootNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Setup
    func setRootController() {
        let vc: UIViewController
        
        if AuthorizeData.shared.isAuthorized {
            vc = RootTabBarViewController.initial()
        } else {
            vc = PhoneNumberViewController.initial()
        }

        setViewControllers([vc], animated: false)
    }

}
