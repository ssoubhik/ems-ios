//
//  ErrorResult.swift
//  EMS
//
//  Created by Soubhik Sarkhel on 13/09/23.
//

import Foundation

// MARK: - Error Result Model

struct ErrorResult: Codable {
    let message: String?
}

// MARK: - Error Result Extension

extension ErrorResult {
    static var new: ErrorResult {
        ErrorResult(message: nil)
    }
}
