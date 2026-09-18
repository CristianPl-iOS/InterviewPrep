import SwiftUI

struct QuestionListView: View {
    @StateObject private var viewModel: QuestionListViewModel

    init(repository: any QuestionRepositoryProtocol) {
        _viewModel = StateObject(wrappedValue: QuestionListViewModel(repository: repository))
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Cargando preguntas…")
                } else if viewModel.filteredQuestions.isEmpty {
                    ContentUnavailableView("Sin resultados", systemImage: "magnifyingglass", description: Text("Prueba otro texto o cambia los filtros."))
                } else {
                    List(viewModel.filteredQuestions) { question in
                        NavigationLink(value: question.id) {
                            QuestionRow(question: question) {
                                Task { await viewModel.toggleFavorite(question) }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    .refreshable { await viewModel.refresh() }
                }
            }
            .navigationTitle("Interview Prep")
            .navigationDestination(for: UUID.self) { id in
                if let question = viewModel.questions.first(where: { $0.id == id }) {
                    QuestionDetailView(question: question) {
                        Task { await viewModel.toggleFavorite(question) }
                    }
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Buscar preguntas")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Categoría", selection: $viewModel.selectedCategory) {
                            Text("Todas").tag(QuestionCategory?.none)
                            ForEach(QuestionCategory.allCases, id: \.self) { Text($0.title).tag(Optional($0)) }
                        }
                        Picker("Dificultad", selection: $viewModel.selectedDifficulty) {
                            Text("Todas").tag(Difficulty?.none)
                            ForEach(Difficulty.allCases, id: \.self) { Text($0.title).tag(Optional($0)) }
                        }
                        Toggle("Solo favoritas", isOn: $viewModel.showingFavoritesOnly)
                    } label: { Label("Filtros", systemImage: "line.3.horizontal.decrease.circle") }
                }
            }
        }
        .task { await viewModel.load() }
        .alert("Aviso", isPresented: Binding(get: { viewModel.errorMessage != nil }, set: { if !$0 { viewModel.errorMessage = nil } })) {
            Button("OK", role: .cancel) { viewModel.errorMessage = nil }
        } message: { Text(viewModel.errorMessage ?? "") }
    }
}

private struct QuestionRow: View {
    let question: InterviewQuestion
    let onFavorite: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(question.title).font(.headline)
                HStack {
                    Text(question.category.title)
                    Text("•")
                    Text(question.difficulty.title)
                }
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            Spacer()
            Button(action: onFavorite) {
                Image(systemName: question.isFavorite ? "star.fill" : "star")
                    .foregroundStyle(question.isFavorite ? .yellow : .secondary)
            }
            .buttonStyle(.borderless)
            .accessibilityLabel(question.isFavorite ? "Quitar de favoritos" : "Agregar a favoritos")
        }
        .padding(.vertical, 4)
    }
}
