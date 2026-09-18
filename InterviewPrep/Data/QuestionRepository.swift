import Foundation

protocol QuestionRepositoryProtocol: Sendable {
    func cachedQuestions() async throws -> [InterviewQuestion]
    func refreshQuestions() async throws -> [InterviewQuestion]
    func toggleFavorite(id: UUID) async throws
}

actor DefaultQuestionRepository: QuestionRepositoryProtocol {
    private let local: QuestionLocalStore
    private let seed: [InterviewQuestion]

    init(local: QuestionLocalStore, seed: [InterviewQuestion] = QuestionSeedData.questions) {
        self.local = local
        self.seed = seed
    }

    func cachedQuestions() async throws -> [InterviewQuestion] {
        let cached = try await local.fetchQuestions()
        if cached.isEmpty {
            try await local.saveQuestions(seed)
            return seed
        }
        return cached
    }

    func refreshQuestions() async throws -> [InterviewQuestion] {
        // Este punto está preparado para conectar una API real más adelante.
        // La semilla local permite que la app funcione sin red desde el primer arranque.
        try Task.checkCancellation()
        try await local.saveQuestions(seed)
        return try await local.fetchQuestions()
    }

    func toggleFavorite(id: UUID) async throws {
        try await local.toggleFavorite(id: id)
    }
}
