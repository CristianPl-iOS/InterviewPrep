//
//  TodoLocalStore.swift
//  InterviewPrep
//
//  Created by Cristian Plascencia on 08/09/26.
//

import CoreData

actor TodoLocalStore {
    
    private let container: NSPersistentContainer
    private var isLoaded = false
    
    init(inMemory: Bool = false) {
        
        container = NSPersistentContainer(name: "InterviewPrep")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url =
                URL(fileURLWithPath: "/dev/null")
        }
        
    }
    
    private func prepareIfNeeded() async throws {

        guard !isLoaded else {
            return
        }
        
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in

            container.loadPersistentStores { _, error in

                if let error {
                    continuation.resume(
                        throwing: error
                    )
                } else {
                    continuation.resume()
                }
            }
        }

        isLoaded = true
    }
    
    func fetchTodos() async throws -> [Todo] {
        
        try await prepareIfNeeded()
        
        let context = container.newBackgroundContext()
        
        return try await context.perform {
            
            let request = NSFetchRequest<NSManagedObject>(
                entityName: "TodoEntity"
            )
            
            let objects = try context.fetch(request)
            
            return objects.compactMap { object in
                
                guard let title = object.value(
                    forKey: "title"
                ) as? String else {
                    return nil
                }
                
                return Todo(
                    id: Int(
                        object.value(forKey: "id")
                        as? Int64 ?? 0
                    ),
                    userId: Int(
                        object.value(forKey: "userId")
                        as? Int64 ?? 0
                    ),
                    title: title,
                    completed:
                        object.value(forKey: "completed")
                        as? Bool ?? false
                )
                
            }
            
        }
        
    }
    
    func replaceTodos(_ todos: [Todo]) async throws {
        
        try await prepareIfNeeded()
        
        let context = container.newBackgroundContext()
        
        try await context.perform {
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(
                entityName: "TodoEntity"
            )
            
            let deleteRequest = NSBatchDeleteRequest(
                fetchRequest: fetchRequest
            )
            
            try context.execute(deleteRequest)
            
            for todo in todos {
                
                let object = NSEntityDescription.insertNewObject(
                    forEntityName: "TodoEntity",
                    into: context
                )
                
                object.setValue(
                    Int64(todo.id),
                    forKey: "id"
                )
                
                object.setValue(
                    Int64(todo.userId),
                    forKey: "userId"
                )
                
                object.setValue(
                    todo.title,
                    forKey: "title"
                )
                
                object.setValue(
                    todo.completed,
                    forKey: "completed"
                )
            }
            
            if context.hasChanges {
                try context.save()
            }
            
        }
        
    }
    
}

