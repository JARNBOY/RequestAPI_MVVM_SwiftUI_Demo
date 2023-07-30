//
//  APIManager.swift
//  RequestAPI_MVVM_SwiftUI_Demo
//
//  Created by Papon Supamongkonchai on 30/7/2566 BE.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

class APIManager {
    static let shared = APIManager()
    
    func request(endpoint: String, method: HTTPMethod , headers: [String: String]?, body: Data?) async throws -> Data {
        guard let url = URL(string: endpoint) else {
            throw ContentViewModel.UserError.failedInvalid
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let headers = headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let body = body {
            request.httpBody = body
        }
        
        let session = URLSession.shared
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ContentViewModel.UserError.failedToResponse
        }
        
        if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {
            return data
        } else {
            throw ContentViewModel.UserError.failedRequest(httpResponse: httpResponse)
        }
    }
}
