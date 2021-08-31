//
//  Hud.swift
//  Chat
//
//  Created by User on 8/31/21.
//

import Foundation
import SVProgressHUD

struct Hud {
    static func show() {
        SVProgressHUD.show()
    }
    
    static func showSuccess(with title: String) {
        SVProgressHUD.showSuccess(withStatus: title)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            SVProgressHUD.dismiss()
        }
    }
    
    static func hide(completion: (() -> Void)? = nil) {
        SVProgressHUD.dismiss {
            completion?()
        }
    }
}
