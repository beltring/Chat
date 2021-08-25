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
    
    func getContacts(completion: @escaping (Result<Users, TDlibError>) -> Void) {
        coordinator.send(GetContacts()).done { users in
            completion(.success(users))
        }.catch{ error in
            completion(.failure(.sampleError))
        }
    }

    func getUser(id: Int32, completion: @escaping (Result<User, TDlibError>) -> Void) {
        coordinator.send(GetUser(userId: id)).done { user in
            completion(.success(user))
        }.catch{ error in
            completion(.failure(.sampleError))
        }
    }
    
    func getChats(completion: @escaping (Result<Chats, TDlibError>) -> Void) {
        coordinator.send(GetChats(chatList: nil, offsetOrder: nil, offsetChatId: nil, limit: 100)).done { chats in
            completion(.success(chats))
        }.catch { error in
            completion(.failure(.sampleError))
        }
    }
    
    func createPrivateChat(userId: Int32, completion: @escaping (Result<Chat, TDlibError>) -> Void) {
        coordinator.send(CreatePrivateChat(userId: userId, force: false)).done { chat in
            completion(.success(chat))
        }.catch { error in
            completion(.failure(.sampleError))
        }
    }
}
