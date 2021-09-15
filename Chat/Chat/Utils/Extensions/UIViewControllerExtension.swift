//
//  UIViewControllerExtension.swift
//  Chat
//
//  Created by User on 8/23/21.
//

import Foundation
import SafariServices
import UIKit

// MARK: - Initial
extension UIViewController {
    static func initial() -> Self {
        let className = String(describing: self)
        
        let name = className.replacingOccurrences(of: "ViewController", with: "").replacingOccurrences(of: "Controller", with: "")
        
        let storyboard = UIStoryboard(name: name, bundle: nil)
        return instanceInitial(from: storyboard)
    }

    // MARK: - Private
    private class func instanceInitial<T: UIViewController>(from storyboard: UIStoryboard) -> T {
        return (storyboard.instantiateInitialViewController() as? T)!
    }
}

// MARK: - Alert
extension UIViewController {
    func presentAlert(title: String? = nil,
                      message: String? = nil,
                      preferredStyle: UIAlertController.Style = .alert,
                      cancelTitle: String = NSLocalizedString("Cancel", comment: ""),
                      cancelStyle: UIAlertAction.Style = .cancel,
                      cancelHandler: ((UIAlertAction) -> Void)? = nil,
                      otherActions: [UIAlertAction]? = nil,
                      animated: Bool = true,
                      completion: (() -> Void)? = nil) {
            
        DispatchQueue.main.async { [weak self] in
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
            
            alert.addAction(UIAlertAction(title: cancelTitle, style: cancelStyle, handler: cancelHandler))
            otherActions?.forEach { alert.addAction($0) }
            
            self?.present(alert, animated: animated, completion: completion)
        }
    }
}

// MARK: - SafariViewController
extension UIViewController {
    func presentSafariViewController(url: URL?) {
        guard let url = url else {
            return
        }
        
        let vc = self.makeSafariViewController(url: url)
        self.present(vc, animated: true)
    }

    func makeSafariViewController(url: URL) -> SFSafariViewController {
        let vc = SFSafariViewController(url: url)
        vc.delegate = UIViewController.safariDelegate
        
        return vc
    }
    
    private static let safariDelegate = WebViewControllerDelegate()
}

fileprivate class WebViewControllerDelegate: NSObject, SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
