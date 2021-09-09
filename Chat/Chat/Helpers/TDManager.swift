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
        }.catch { _ in
            completion(.failure(.invalidPhoneNumber))
        }
    }
    
    func checkCode(code: String, completion: @escaping (Result<String, TDlibError>) -> Void) {
        coordinator.send(CheckAuthenticationCode(code: code)).done { success in
            completion(.success(code))
        }.catch { _ in
            completion(.failure(.invalidCode))
        }
    }
    
    func getContacts(completion: @escaping (Result<Users, TDlibError>) -> Void) {
        coordinator.send(GetContacts()).done { users in
            completion(.success(users))
        }.catch { _ in
            completion(.failure(.sampleError))
        }
    }

    func getUser(id: Int32, completion: @escaping (Result<User, TDlibError>) -> Void) {
        coordinator.send(GetUser(userId: id)).done { user in
            completion(.success(user))
        }.catch { _ in
            completion(.failure(.sampleError))
        }
    }
    
    func getChats(completion: @escaping (Result<Chats, TDlibError>) -> Void) {
        coordinator.send(GetChats(chatList: .main, offsetOrder: .some("9223372036854775807"), offsetChatId: .zero, limit: 1000)).done { chats in
            completion(.success(chats))
        }.catch { error in
            print(error)
            completion(.failure(.sampleError))
        }
    }
    
    func getChat(chatId: Int64, completion: @escaping (Result<TDLib.Chat, TDlibError>) -> Void) {
        coordinator.send(GetChat(chatId: chatId)).done { chat in
            completion(.success(chat))
        }.catch { error in
            print(error)
            completion(.failure(.sampleError))
        }
    }
    
    func getChatHistory(chatId: Int64, completion: @escaping (Result<Messages, TDlibError>) -> Void) {
        coordinator.send(GetChatHistory(chatId: chatId, fromMessageId: .max, offset: 0, limit: 50, onlyLocal: false)).done { messages in
            completion(.success(messages))
        }.catch { error in
            print(error)
            completion(.failure(.sampleError))
        }
    }
    
    func getChatHistory(chatId: Int64) {
        coordinator.send(GetChatHistory(chatId: chatId, fromMessageId: .max, offset: 0, limit: 50, onlyLocal: false)).done { messages in
            print("Messages count: \(messages.totalCount)")
        }.catch { error in
            print(error)
        }
    }
    
    func createPrivateChat(userId: Int32, completion: @escaping (Result<TDLib.Chat, TDlibError>) -> Void) {
        coordinator.send(CreatePrivateChat(userId: userId, force: false)).done { chat in
            completion(.success(chat))
        }.catch { error in
            print(error)
            completion(.failure(.sampleError))
        }
    }
    
    func getCurrentUser(completion: @escaping (Result<User, TDlibError>) -> Void) {
        coordinator.send(GetMe()).done { user in
            completion(.success(user))
        }.catch { error in
            print(error.localizedDescription)
            completion(.failure(.invalidUser))
        }
    }
    
    func logOut(completion: @escaping (Result<Bool, TDlibError>) -> Void) {
        coordinator.send(LogOut()).done { _ in
            completion(.success(true))
        }.catch { _ in
            completion(.failure(.sampleError))
        }
    }
    
    func sendMessage(id: Int64, content: InputMessageContent, completion: @escaping (Result<Bool, TDlibError>) -> Void) {
        coordinator.send(SendMessage(chatId: id, replyToMessageId: 0, options: .none, replyMarkup: .none, inputMessageContent: content)).done { _ in
            completion(.success(true))
        }.catch { _ in
            completion(.failure(.sampleError))
        }
    }
    
    func downloadFile(id: Int32?, completion: @escaping (Result<File, TDlibError>) -> Void) {
        coordinator.send(DownloadFile(fileId: id, priority: 32, offset: 0, limit: 0, synchronous: true)).done { file in
            completion(.success(file))
        }.catch { _ in
            completion(.failure(.sampleError))
        }
    }
}
