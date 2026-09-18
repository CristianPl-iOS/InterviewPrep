import CoreData
import Foundation

actor QuestionLocalStore {
    private let container: NSPersistentContainer
    private var isLoaded = false

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "InterviewPrep")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
    }

    private func prepareIfNeeded() async throws {
        guard !isLoaded else { return }
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            container.loadPersistentStores { _, error in
                if let error { continuation.resume(throwing: error) }
                else { continuation.resume() }
            }
        }
        isLoaded = true
    }

    func fetchQuestions() async throws -> [InterviewQuestion] {
        try await prepareIfNeeded()
        let context = container.newBackgroundContext()
        return try await context.perform {
            let request = NSFetchRequest<NSManagedObject>(entityName: "QuestionEntity")
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            return try context.fetch(request).compactMap(Self.map)
        }
    }

    func saveQuestions(_ questions: [InterviewQuestion]) async throws {
        try await prepareIfNeeded()
        let context = container.newBackgroundContext()
        try await context.perform {
            let request = NSFetchRequest<NSManagedObject>(entityName: "QuestionEntity")
            let existing = try context.fetch(request)
            let byID = Dictionary(uniqueKeysWithValues: existing.compactMap { object -> (UUID, NSManagedObject)? in
                guard let rawID = object.value(forKey: "id") as? String,
                      let id = UUID(uuidString: rawID) else { return nil }
                return (id, object)
            })
            for question in questions {
                let object = byID[question.id] ?? NSEntityDescription.insertNewObject(forEntityName: "QuestionEntity", into: context)
                object.setValue(question.id.uuidString, forKey: "id")
                object.setValue(question.title, forKey: "title")
                object.setValue(question.answer, forKey: "answer")
                object.setValue(question.category.rawValue, forKey: "category")
                object.setValue(question.difficulty.rawValue, forKey: "difficulty")
                object.setValue(question.tags.joined(separator: "|"), forKey: "tags")
                object.setValue(question.isFavorite, forKey: "isFavorite")
            }
            if context.hasChanges { try context.save() }
        }
    }

    func toggleFavorite(id: UUID) async throws {
        try await prepareIfNeeded()
        let context = container.newBackgroundContext()
        try await context.perform {
            let request = NSFetchRequest<NSManagedObject>(entityName: "QuestionEntity")
            request.fetchLimit = 1
            request.predicate = NSPredicate(format: "id == %@", id.uuidString)
            guard let object = try context.fetch(request).first else { return }
            let favorite = object.value(forKey: "isFavorite") as? Bool ?? false
            object.setValue(!favorite, forKey: "isFavorite")
            try context.save()
        }
    }

    private static func map(_ object: NSManagedObject) -> InterviewQuestion? {
        guard
            let rawID = object.value(forKey: "id") as? String,
            let id = UUID(uuidString: rawID),
            let title = object.value(forKey: "title") as? String,
            let answer = object.value(forKey: "answer") as? String,
            let categoryRaw = object.value(forKey: "category") as? String,
            let category = QuestionCategory(rawValue: categoryRaw),
            let difficultyRaw = object.value(forKey: "difficulty") as? String,
            let difficulty = Difficulty(rawValue: difficultyRaw)
        else { return nil }
        let tags = (object.value(forKey: "tags") as? String ?? "").split(separator: "|").map(String.init)
        return InterviewQuestion(id: id, title: title, answer: answer, category: category, difficulty: difficulty, tags: tags, isFavorite: object.value(forKey: "isFavorite") as? Bool ?? false)
    }
}
