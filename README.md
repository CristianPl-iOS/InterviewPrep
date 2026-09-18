# InterviewPrep

MVP de una app para practicar entrevistas de iOS y Swift.

## Incluye

- Preguntas reales de Swift, SwiftUI, Concurrency, arquitectura, networking y testing.
- Categorías, dificultad, búsqueda y filtros.
- Detalle con respuesta y tags.
- Favoritos persistidos con Core Data.
- Arquitectura MVVM + Repository + Dependency Injection.
- Carga local inmediata (offline-first) y sincronización preparada para una fuente remota.
- Concurrencia con `async/await` y actores.
- Logging con `OSLog`.

## Cómo ejecutarlo

1. Abre `InterviewPrep.xcodeproj` en Xcode.
2. Selecciona un simulador con iOS 18 o superior.
3. Ejecuta el target `InterviewPrep`.
4. Haz pull de la rama `feature/interview-prep-mvp`.

La primera carga crea las preguntas semilla en Core Data. Si no hay red, la app continúa funcionando con los datos guardados.

## Próximos ejercicios

- Sustituir `QuestionSeedData` por una API real.
- Añadir un test target con XCTest.
- Implementar paginación y debounce de búsqueda.
- Medir lanzamiento, memoria y renderizado con Instruments (Time Profiler, Allocations y SwiftUI).
