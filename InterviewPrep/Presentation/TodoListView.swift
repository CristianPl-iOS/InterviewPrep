//
//  TodoListView.swift
//  InterviewPrep
//
//  Created by Cristian Plascencia on 08/09/26.
//

import SwiftUI

struct TodoListView: View {
    
    @StateObject private var viewModel: TodoListViewModel
    
    init(repository: any TodoRepositoryProtocol) {
        _viewModel = StateObject(
            wrappedValue: TodoListViewModel(
                repository: repository
            )
        )
    }
    
    var body: some View {
        
        NavigationStack {
            
            Group {
                
                if viewModel.isLoading {
                    
                    ProgressView("Loading...")
                    
                } else {
                    
                    List(viewModel.todos) { todo in
                        
                        HStack {
                            
                            Image(
                                systemName:
                                    todo.completed
                                    ? "checkmark.circle.fill"
                                    : "circle"
                            )
                            
                            Text(todo.title)
                        }
                        
                    }
                    .refreshable {
                        await viewModel.refresh()
                    }
                    
                }
                
            }
            .navigationTitle(viewModel.user?.name ?? "Task")
            
        }
        .task {
            await viewModel.load()
        }
        .alert(
            "Error",
            isPresented:
                Binding(
                    get: {
                        viewModel.errorMessage != nil
                    },
                    set: { newValue in
                        
                        if !newValue {
                            // en preduccion expondrias
                            // un dismissError()
                        }
                        
                    }
                )
        ) {
            Button("OK") {}
        } message: {
            
            Text(viewModel.errorMessage ?? "")
            
        }
        
    }
    
}

#Preview {
    let apiClient = APIClient()
    let remote = RemoteTodoDataSource(apiClient: apiClient)
    let local = TodoLocalStore()
    TodoListView(
        repository: DefaultTodoRepository(
            remote: remote,
            local: local
        )
    )
}
