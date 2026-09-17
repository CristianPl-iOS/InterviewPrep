//
//  TodoListViewModel.swift
//  InterviewPrep
//
//  Created by Cristian Plascencia on 08/09/26.
//

import Foundation

@MainActor
final class TodoListViewModel: ObservableObject {
    
    @Published private(set) var todos: [Todo] = []
    @Published private(set) var user: User?
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    
    private let repository: any TodoRepositoryProtocol
    
    private var didLoad: Bool = false
    
    init(repository: any TodoRepositoryProtocol) {
        self.repository = repository
    }
    
    func load() async {
        guard !didLoad else {
            return
        }
        
        didLoad = true
        
        do {
            let cached = try await repository.cachedTodos()
            
            if !cached.isEmpty {
                todos = cached
            }
        } catch {
            
            print("Cache error:", error)
            
        }
        
        await refresh()
    }
    
    func refresh() async {

        isLoading = todos.isEmpty
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {

            let dashboard =
                try await repository.refreshDashboard(
                    userId: 1
                )

            try Task.checkCancellation()

            user = dashboard.user
            todos = dashboard.todos

        } catch is CancellationError {

            // Cancellation isn't normally
            // a user-facing error.
            return

        } catch {

            errorMessage =
                error.localizedDescription
        }
    }
}
