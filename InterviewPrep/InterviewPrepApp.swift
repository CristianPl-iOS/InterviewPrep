//
//  InterviewPrepApp.swift
//  InterviewPrep
//
//  Created by Cristian Plascencia on 08/09/26.
//

import SwiftUI

@main
struct InterviewPrepApp: App {
    
    private let repository: DefaultTodoRepository
    
    init() {
        
        //
        let apiClient = APIClient()
        
        // un remote data source con un api client
        let remote = RemoteTodoDataSource(apiClient: apiClient)
        
        // Un local store nuevo
        let local = TodoLocalStore()
        
        self.repository = DefaultTodoRepository(
            remote: remote,
            local: local
        )
    }
    
    var body: some Scene {
        
        WindowGroup {
            TodoListView(repository: repository)
        }
        
    }
    
}
