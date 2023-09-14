//
//  RestAPIClient.swift
//  EMS
//
//  Created by Soubhik Sarkhel on 13/09/23.
//

import Foundation

// MARK: - REST API Client Protocol

protocol RestAPIClient {
    func callAPI<T: Codable>(path: String, method: APIMethods, queryItems: [URLQueryItem], params: [String: Any]) async throws -> T
}

// MARK: - REST API Client Protocol Extension

extension RestAPIClient {
    // generic http fetch method
    func callAPI<T: Codable>(path: String, method: APIMethods, queryItems: [URLQueryItem] = [], params: [String: Any] = [:]) async throws -> T {
        // setup url components
        var components = URLComponents()
        components.scheme = BaseUrl.apiScheme
        components.host = BaseUrl.apiBaseUrl
        components.path = path
        components.queryItems = queryItems

        // setup url
        guard let url = components.url else { throw APIError.invalidURL }

        // url session
        let session = URLSession.shared
        
        // setup url request
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(StaticUrl.applicationJson, forHTTPHeaderField: StaticUrl.contentType)
        urlRequest.httpMethod = method.rawValue
        
        // set request body if any
        if !params.isEmpty {
            let body = try? JSONSerialization.data(withJSONObject: params)
            urlRequest.httpBody = body
        }
        
        // get data & response
        let (data, _) = try await session.data(for: urlRequest)

        if let stringData = String(data: data, encoding: .utf8) {
            print("\(path) stringData 🟢🔴", stringData)
        }

        // setup decoder
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        // decode data
        guard let decodedData = try? decoder.decode(T.self, from: data) else {
            if let stringData = String(data: data, encoding: .utf8), (stringData.contains("Invalid Token") || stringData.contains("Unauthorized")) {
                throw APIError.invalidToken
            }
            
            throw APIError.failedToDecode
        }
        
        return decodedData
    }
}
