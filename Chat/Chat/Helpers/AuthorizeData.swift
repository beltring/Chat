//
//  AuthorizeData.swift
//  Chat
//
//  Created by User on 8/24/21.
//

import Foundation
import KeychainSwift

class AuthorizeData {
    static let shared = AuthorizeData()
    private let keychain = KeychainSwift()
    
    private init() {}
    
    var isAuthorized: Bool {
        get {
            return keychain.getBool("auth") ?? false
        }
        set {
            keychain.set(newValue, forKey: "auth")
        }
    }
    
    func resetData() {
        keychain.clear()
    }
}
