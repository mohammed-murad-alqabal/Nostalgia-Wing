# Architecture Documentation - Wing of Nostalgia

## Overview

The application follows a **Service-Oriented Architecture (SOA)** combined with **Provider** for state management and dependency injection. This structure separates concerns into three main layers: Core, Features, and UI.

## Directory Structure

### `lib/core`

Contains the foundational elements of the application, shared across features.

- **Services**: Business logic and external interactions (e.g., `DBService`, `AuthService`, `AnalyticsService`).
- **Models**: Data classes (e.g., `Memory`, `VerseModel`, `EmotionalState`).
- **Psychology**: The unique "Soul" engine of the app (`EmotionalAdaptationSystem`, `EmotionalState`).
- **Security**: Error handling and secure data management.

### `lib/features`

Contains functionality specific to distinct parts of the application.

- **Home**: `HomeScreen`, `EnhancedHomeScreen`, Parallax effects.
- **Memories**: `MemoryDetailScreen` and related UI.
- **Messages**: Love message composition and display.

## Design Patterns

### Dependency Injection

We use `provider` to inject services into the widget tree at the root (`main.dart`). This ensures singletons like `DBService` and `AuthService` are accessible globally.

### State Management

- **Global State**: Managed via Services (e.g., `AuthService` holds user state).
- **Ephemeral State**: Managed via `StatefulWidget` (e.g., animations in `EnhancedParallaxLayer`).

### Psychology Engine

The `EmotionalAdaptationSystem` acts as a central "Brain", taking inputs (Time, Usage, Sentiment) and outputting UI configurations (Colors, Animations, Themes).

## Clean Architecture Adherence

While not strictly following the folder structure of (Data/Domain/Presentation) per feature, the logical separation holds:

- **Data Layer**: `DBService` (Hive), `AuthService`.
- **Domain/Logic Layer**: `EmotionalAdaptationSystem`, `PsychologicalAnalysisEngine`.
- **Presentation Layer**: `features/*`, utilizing `Provider` to consume Data/Logic.

## Future Improvements

- Consider introducing `Repository` pattern if data sources become complex (e.g. syncing with Cloud).
- Extract `UseCases` if business logic in Services becomes bloated.
