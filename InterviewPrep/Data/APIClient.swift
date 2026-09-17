//
//  APIClient.swift
//  InterviewPrep
//
//  Created by Cristian Plascencia on 08/09/26.
//

import Foundation

enum NetworkError: LocalizedError {
    
    case invalidResponse
    case httpError(Int)
    
    var errorDescription: String? {
        
        switch self {
            
        case .invalidResponse:
            return "Invalid server response"
            
        case .httpError(let code):
            return "Server return status \(code)"
            
        }
        
    }
    
}

actor APIClient {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func get<T>(
        _ type: T.Type,
        from url: URL
    ) async throws -> T
    where T: Decodable & Sendable {
        
        let (data, response) = try await session.data(from: url)
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard 200..<300 ~= response.statusCode else {
            throw NetworkError.httpError(response.statusCode)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
