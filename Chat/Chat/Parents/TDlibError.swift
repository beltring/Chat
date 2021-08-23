//
//  TDlibError.swift
//  Chat
//
//  Created by User on 8/23/21.
//

import Foundation

enum NetworkError: Error {
    case invalidPhoneNumber
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidPhoneNumber:
            return "Invalid phone number."
        }
    }
}
