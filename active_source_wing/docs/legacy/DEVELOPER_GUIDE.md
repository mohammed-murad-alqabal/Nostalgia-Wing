# Developer Guide - Wing of Nostalgia

## Architecture Overview

Wing of Nostalgia follows **Clean Architecture** principles to ensure maintainability, testability, and scalability.

### Layers

- **Core**: Contains shared infrastructure, models, and domain logic.
  - `cognitive/`: Algorithms for emotional gravity, surprise evolution, etc.
  - `infrastructure/`: Systems for governance, documentation, and metadata.
  - `psychology/`: Emotional state definitions.
  - `services/`: Database, authentication, and notification services.
  - `models/`: Data entities.
- **Features**: UI and business logic for specific functional areas.
- **Test**: Comprehensive test suite categorized into core, features, performance, and integration.

## Key Design Principles

1. **Institutional Engineering**: Adherence to the [comprehensive_engineering_institutionalty_protocol].
2. **Local-First Security**: All sensitive data is encrypted locally using `SecureDataManager`.
3. **Living Documentation**: The project maintains its own documentation state via `LivingDocumentationSystem`.
4. **Emotional Intelligence**: Algorithms are designed to increase "Emotional Presence Density" without overwhelming the user.

## Getting Started

### Prerequisites

- Flutter SDK (Strictly following the version in `analysis_options.yaml`)
- Android SDK (for mobile deployment)

### Setup

1. Clone the repository.
2. Run `flutter pub get`.
3. Verify setup with `flutter analyze`.
4. Run tests: `flutter test`.

## Testing Strategy

The project aims for **90% test coverage**.

- **Unit Tests**: Test logic in core and services.
- **Integration Tests**: Test interactions between Auth and DB services.
- **Performance Tests**: Verify DB latency and security.
- **Edge Case Tests**: Handle boundary conditions and null safety.

## Contribution Guidelines

Please read `CONTRIBUTING.md` before submitting pull requests. All PRs must pass the CI pipeline (`flutter_ci.yml`).

## ADR System

Technical decisions are recorded in `docs/adr/`. When making a significant change, please create a new ADR.
