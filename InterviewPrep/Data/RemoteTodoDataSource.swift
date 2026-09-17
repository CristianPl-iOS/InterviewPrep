//
//  RemoteTodoDataSource.swift
//  InterviewPrep
//
//  Created by Cristian Plascencia on 08/09/26.
//

import Foundation

private struct TodoDTO: Decodable, Sendable {
    
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
    
}

private struct UserDTO: Decodable, Sendable {
    
    let id: Int
    let name: String
    let email: String
    
}

struct RemoteTodoDataSource: Sendable {
    
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func fetchTodos(userId: Int) async throws -> [Todo] {
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos?userId=\(userId)")!
        
        let response = try await apiClient.get([TodoDTO].self, from: url)
        
        return response.map {
            Todo(id: $0.id, userId: $0.userId, title: $0.title, completed: $0.completed)
        }
    }
    
    func fetchUser(id: Int) async throws -> User {
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/users/\(id)")!
        
        let response = try await apiClient.get(UserDTO.self, from: url)
        
        return User(id: response.id, name: response.name, email: response.email)
        
    }
}
