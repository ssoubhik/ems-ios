//
//  APIError.swift
//  EMS
//
//  Created by Soubhik Sarkhel on 13/09/23.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case failedToDecode
    case invalidStatusCode
    case invalidToken

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "invalid url"
        case .failedToDecode:
            return "failed to decode"
        case .invalidStatusCode:
            return "invalid status code"
        case .invalidToken:
            return "invalid token"
        }
    }
}
