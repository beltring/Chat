//
//  TDManager.swift
//  Chat
//
//  Created by User on 8/23/21.
//

import Foundation
import TDLib

class TDManager {
    static let shared = TDManager(apiId: 7811316, apiHash: "0ca4e32ee19e9ad700b9d882f123c2a3")
    
    let coordinator: Coordinator
    
    private init(apiId: Int32, apiHash: String) {
        coordinator = Coordinator(client: TDJsonClient(), apiId: apiId, apiHash: apiHash)
    }
    
    func setPhoneNumber(number: String, completion: @escaping (Result<String, TDlibError>) -> Void ) {
        coordinator.send(SetAuthenticationPhoneNumber(phoneNumber: number, settings: .none)).done { success in
            completion(.success(number))
        }.catch{ error in
            completion(.failure(.invalidPhoneNumber))
        }
    }
    
    func checkCode(code: String, completion: @escaping (Result<String, TDlibError>) -> Void) {
        coordinator.send(CheckAuthenticationCode(code: code)).done { success in
            completion(.success(code))
        }.catch{ error in
            completion(.failure(.invalidCode))
        }
    }
}
