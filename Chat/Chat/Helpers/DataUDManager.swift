//
//  DataUDManager.swift
//  Chat
//
//  Created by User on 9/1/21.
//

import Foundation

class DataUDManager {
    
    static let shared = DataUDManager()
        
    private struct DefaultsKeys {
        static let appearance = "appearance"
    }
}

extension DataUDManager {
    
    var appearance: String {
        return UserDefaults.standard.object(forKey: DefaultsKeys.appearance) as? String ?? "light"
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: DefaultsKeys.appearance)
    }
}
