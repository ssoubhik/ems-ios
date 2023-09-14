//
//  APIConstants.swift
//  EMS
//
//  Created by Soubhik Sarkhel on 13/09/23.
//

import Foundation

// MARK: - Static Url Class

class StaticUrl {
    // api constants
    static let apiScheme = "API_SCHEME"
    static let apiBaseUrl = "API_BASE_URL"
    static let apiPort = "API_PORT"
    static let baseUrl = "BaseUrl"
    static let applicationJson = "application/json"
    static let contentType = "Content-Type"
    static let authorization = "Authorization"

    // api paths
    static let employeesPath = "/employees"
    static let salariesPath = "/salaries"
        
    // query items
    static let empNo = "emp_no"
}

// MARK: - Base Url Class

class BaseUrl {
    static let apiBaseUrl = InfoPlistParser.getBaseUrl(forKey: StaticUrl.apiBaseUrl)
    static let apiScheme = InfoPlistParser.getBaseUrl(forKey: StaticUrl.apiScheme)
    static let apiPort = InfoPlistParser.getBaseUrl(forKey: StaticUrl.apiPort)
}

// MARK: - Fetching BaseUrl from Info-Plist

struct InfoPlistParser {
    static func getBaseUrl(forKey key: String) -> String {
        guard let value = Bundle.main.infoDictionary?[StaticUrl.baseUrl] as? [String: String] else { fatalError()
        }

        if let baseUrl = value[key] {
            return baseUrl
        }
        return ""
    }
}
