import Foundation
import os

@MainActor
final class QuestionListViewModel: ObservableObject {
    @Published private(set) var questions: [InterviewQuestion] = []
    @Published var searchText = ""
    @Published var selectedCategory: QuestionCategory?
    @Published var selectedDifficulty: Difficulty?
    @Published var showingFavoritesOnly = false
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let repository: any QuestionRepositoryProtocol
    private var didLoad = false
    private let logger = Logger(subsystem: "CristianPl-iOS.InterviewPrep", category: "questions")

    init(repository: any QuestionRepositoryProtocol) { self.repository = repository }

    var filteredQuestions: [InterviewQuestion] {
        questions.filter { question in
            let normalizedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            return (normalizedSearch.isEmpty || question.searchableText.contains(normalizedSearch))
                && (selectedCategory == nil || question.category == selectedCategory)
                && (selectedDifficulty == nil || question.difficulty == selectedDifficulty)
                && (!showingFavoritesOnly || question.isFavorite)
        }
    }

    func load() async {
        guard !didLoad else { return }
        didLoad = true
        do { questions = try await repository.cachedQuestions() }
        catch { logger.error("Cache load failed: \\(error.localizedDescription, privacy: .public)") }
        await refresh()
    }

    func refresh() async {
        isLoading = questions.isEmpty
        errorMessage = nil
        defer { isLoading = false }
        do { questions = try await repository.refreshQuestions() }
        catch is CancellationError { return }
        catch {
            errorMessage = "No se pudo actualizar. Se muestran los datos guardados."
            logger.error("Refresh failed: \\(error.localizedDescription, privacy: .public)")
        }
    }

    func toggleFavorite(_ question: InterviewQuestion) async {
        do {
            try await repository.toggleFavorite(id: question.id)
            if let index = questions.firstIndex(where: { $0.id == question.id }) {
                questions[index].isFavorite.toggle()
            }
        } catch { errorMessage = "No se pudo guardar el favorito." }
    }

    func dismissError() { errorMessage = nil }
}
