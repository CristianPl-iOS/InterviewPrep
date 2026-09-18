import SwiftUI

@main
struct InterviewPrepApp: App {
    private let repository: DefaultQuestionRepository

    init() {
        repository = DefaultQuestionRepository(local: QuestionLocalStore())
    }

    var body: some Scene {
        WindowGroup {
            QuestionListView(repository: repository)
        }
    }
}
