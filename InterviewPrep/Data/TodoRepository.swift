//
//  TodoRepository.swift
//  InterviewPrep
//
//  Created by Cristian Plascencia on 08/09/26.
//

import Foundation

protocol TodoRepositoryProtocol: Sendable {
    
    func cachedTodos() async throws -> [Todo]
    func refreshDashboard(userId: Int) async throws -> Dashboard
    
}

actor DefaultTodoRepository: TodoRepositoryProtocol {
    
    private let remote: RemoteTodoDataSource
    private let local: TodoLocalStore
    
    init(
        remote: RemoteTodoDataSource,
        local: TodoLocalStore
    ) {
        self.remote = remote
        self.local = local
    }
    
    func cachedTodos() async throws -> [Todo] {
        try await local.fetchTodos()
    }
    
    func refreshDashboard(
        userId: Int
    ) async throws -> Dashboard {
        
        async let user = remote.fetchUser(id: userId)
        
        async let todos =
            remote.fetchTodos(userId: userId)
        
        let (loadedUser, loadedTodos) =
            try await (user, todos)
        
        try Task.checkCancellation()
        
        try await local.replaceTodos(loadedTodos)
        
        return Dashboard(
            user: loadedUser,
            todos: loadedTodos
        )
        
    }
    
}
