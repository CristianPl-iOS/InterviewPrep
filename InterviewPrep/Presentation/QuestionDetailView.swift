import SwiftUI

struct QuestionDetailView: View {
    let question: InterviewQuestion
    let onFavorite: () -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text(question.title).font(.largeTitle.bold())
                HStack {
                    Label(question.category.title, systemImage: "tag")
                    Label(question.difficulty.title, systemImage: "chart.bar")
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
                Divider()
                Text("Respuesta").font(.title2.bold())
                Text(question.answer).font(.body).textSelection(.enabled)
                if !question.tags.isEmpty {
                    Text(question.tags.map { "#\($0)" }.joined(separator: "  "))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle("Detalle")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: onFavorite) {
                    Image(systemName: question.isFavorite ? "star.fill" : "star")
                }
                .accessibilityLabel(question.isFavorite ? "Quitar de favoritos" : "Agregar a favoritos")
            }
        }
    }
}
