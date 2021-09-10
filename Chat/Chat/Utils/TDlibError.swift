//
//  TDlibError.swift
//  Chat
//
//  Created by User on 8/23/21.
//

import Foundation

enum TDlibError: Error {
    case invalidPhoneNumber
    case invalidCode
    case sampleError
    case invalidUser
}

extension TDlibError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidPhoneNumber:
            return "Invalid phone number."
        case .invalidCode:
            return "Invalid code." 
        case .sampleError:
            return "Error"
        case .invalidUser:
            return "The user was not received"
        }
    }
}
