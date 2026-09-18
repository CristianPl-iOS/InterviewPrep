import Foundation

struct InterviewQuestion: Identifiable, Equatable, Sendable {
    let id: UUID
    let title: String
    let answer: String
    let category: QuestionCategory
    let difficulty: Difficulty
    let tags: [String]
    var isFavorite: Bool

    var searchableText: String {
        ([title, answer, category.title, difficulty.title] + tags).joined(separator: " ").lowercased()
    }
}

enum QuestionCategory: String, CaseIterable, Codable, Sendable {
    case swift
    case swiftUI
    case concurrency
    case architecture
    case networking
    case persistence
    case testing

    var title: String {
        switch self {
        case .swift: "Swift"
        case .swiftUI: "SwiftUI"
        case .concurrency: "Concurrency"
        case .architecture: "Architecture"
        case .networking: "Networking"
        case .persistence: "Persistence"
        case .testing: "Testing"
        }
    }
}

enum Difficulty: String, CaseIterable, Codable, Sendable {
    case beginner
    case intermediate
    case advanced

    var title: String { rawValue.capitalized }
}
