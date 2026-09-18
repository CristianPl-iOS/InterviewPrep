import Foundation

struct QuestionSeedData {
    static let questions: [InterviewQuestion] = [
        InterviewQuestion(
            id: UUID(uuidString: "11111111-1111-1111-1111-111111111111")!,
            title: "¿Cuál es la diferencia entre struct y class en Swift?",
            answer: "Una struct es un tipo valor: cada copia tiene su propio estado. Una class es un tipo referencia: varias variables pueden apuntar a la misma instancia. Prefiere structs por defecto y usa clases cuando necesites identidad, herencia o compartir estado mutable.",
            category: .swift,
            difficulty: .beginner,
            tags: ["value type", "reference type", "memory"],
            isFavorite: false
        ),
        InterviewQuestion(
            id: UUID(uuidString: "22222222-2222-2222-2222-222222222222")!,
            title: "¿Qué problema resuelve @State en SwiftUI?",
            answer: "@State almacena estado local controlado por una vista. Cuando cambia, SwiftUI vuelve a evaluar el body y actualiza únicamente las partes necesarias. El estado debe vivir en la vista que es dueña de él; para compartirlo, usa Binding, Observable o un modelo inyectado.",
            category: .swiftUI,
            difficulty: .beginner,
            tags: ["state", "views", "rendering"],
            isFavorite: false
        ),
        InterviewQuestion(
            id: UUID(uuidString: "33333333-3333-3333-3333-333333333333")!,
            title: "¿Qué es un actor y por qué evita data races?",
            answer: "Un actor protege su estado mutable y permite que solo una tarea acceda a ese estado a la vez. Las llamadas que cruzan el límite del actor requieren await. Esto hace explícita la sincronización y reduce errores de concurrencia, aunque debes seguir considerando la reentrancia de los actores.",
            category: .concurrency,
            difficulty: .advanced,
            tags: ["async", "await", "actor", "Sendable"],
            isFavorite: false
        ),
        InterviewQuestion(
            id: UUID(uuidString: "44444444-4444-4444-4444-444444444444")!,
            title: "¿Qué responsabilidad tiene un Repository?",
            answer: "Un repository abstrae el origen de los datos. La capa de presentación no debería saber si los datos vienen de una API, Core Data o un cache. También es un buen lugar para coordinar una estrategia offline-first y mantener la consistencia entre fuentes.",
            category: .architecture,
            difficulty: .intermediate,
            tags: ["MVVM", "clean architecture", "dependency injection"],
            isFavorite: false
        ),
        InterviewQuestion(
            id: UUID(uuidString: "55555555-5555-5555-5555-555555555555")!,
            title: "¿Cómo diseñarías una app offline-first?",
            answer: "Primero muestras el último estado válido guardado localmente. Después intentas sincronizar en segundo plano. Si la red falla, mantienes la experiencia usable, muestras un estado no bloqueante y reintentas más tarde. Las escrituras locales deben tener una estrategia de sincronización y resolución de conflictos.",
            category: .networking,
            difficulty: .advanced,
            tags: ["cache", "sync", "network", "resilience"],
            isFavorite: false
        ),
        InterviewQuestion(
            id: UUID(uuidString: "66666666-6666-6666-6666-666666666666")!,
            title: "¿Qué diferencia hay entre un unit test y un UI test?",
            answer: "Un unit test prueba una unidad aislada y suele ser rápido; un UI test ejecuta la aplicación y valida flujos visibles para el usuario. Conviene tener muchos unit tests y pocos UI tests enfocados en los caminos críticos.",
            category: .testing,
            difficulty: .beginner,
            tags: ["XCTest", "quality", "automation"],
            isFavorite: false
        )
    ]
}
