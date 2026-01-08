# 🕊️ Wing of Nostalgia | جناح الحنين

[![Institutional QA](https://github.com/${{ github.repository }}/actions/workflows/institutional_qa.yml/badge.svg)](https://github.com/${{ github.repository }}/actions/workflows/institutional_qa.yml)
[![Institutional Security](https://github.com/${{ github.repository }}/actions/workflows/maintenance.yml/badge.svg)](https://github.com/${{ github.repository }}/actions/workflows/maintenance.yml)
[![Documentation Sync](https://github.com/${{ github.repository }}/actions/workflows/documentation.yml/badge.svg)](https://github.com/${{ github.repository }}/actions/workflows/documentation.yml)

> كيان هندسي حي للحب والحنين مع الإطار التنفيذي المؤسسي (SEF)
> [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

**Wing of Nostalgia** is a sophisticated, emotionally intelligent application designed to deepen relational bonds through shared memories, gratitude, and spiritual connection. Unlike typical social or journaling apps, it leverages a custom **Psychological Engine** to analyze emotional states and provide tailored recommendations that foster connection and well-being.

## Key Features

- **🧠 Psychological & Emotional Analysis**:

  - **Emotional Gravity Engine**: Amplifies positive emotional presence.
  - **Surprise & Evolution Engine**: Introduces serendipity and novelty.
  - **Emotional State Tracking**: Analyzes user mood (Joy, Calm, Nostalgic, etc.) to tailor the experience.

- **🕰️ Memory Management**:

  - Create, view, and share cherished memories.
  - intelligent "Time Capsule" features to resurface memories at meaningful moments.

- **🙏 Gratitude Journal**:

  - Dedicated space for recording daily blessings and moments of gratitude.
  - Integrated with the psychological engine to reinforce positive thinking.

- **📖 Spiritual Connection**:

  - Quranic verses and spiritual reflections curated for emotional resonance.

- **🎨 Immersive UI**:
  - **Enhanced Parallax Effects**: Dynamic, depth-based visual storytelling.
  - **Glassmorphism Design**: Modern, premium aesthetic with smooth animations.

## Technical Architecture

The project follows **Clean Architecture** principles to ensure scalability, testability, and maintainability.

### Core Stack

- **Framework**: Flutter (Dart)
- **State Management**: Provider
- **Local Persistence**: Hive (NoSQL)
- **Audio**: `audioplayers`, `flutter_tts`

### Directory Structure

```
lib/
├── core/               # Shared logic, services, and utilities
│   ├── cognitive/      # Advanced psychological engines
│   ├── infrastructure/ # System initialization, logging, governance
│   ├── models/         # Data models (Hive entities)
│   ├── psychology/     # Emotional state logic
│   ├── security/       # Data encryption and error handling
│   └── services/       # Feature-agnostic services (Auth, DB, Audio)
├── features/           # Feature-specific code (UI, Logic)
│   ├── home/           # Main dashboard and navigation
│   └── memories/       # Memory creation and viewing
└── main.dart           # Application entry point
```

## Getting Started

### Prerequisites

- Flutter SDK (Latest Stable)
- Dart SDK

### Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/username/wing_of_nostalgia.git
   cd wing_of_nostalgia/active_source_wing
   ```

2. **Install dependencies**:

   ```bash
   flutter pub get
   ```

3. **Run the application**:
   ```bash
   flutter run
   ```

## Testing

The project maintains high code quality standards with comprehensive test coverage.

- **Run all tests**:
  ```bash
  flutter test
  ```
- **Run performance tests**:
  ```bash
  flutter test test/performance/performance_security_test.dart
  ```

## Security

- **Local Data Encryption**: All sensitive data is encrypted locally using `SecureDataManager`.
- **Privacy First**: No data is sent to external servers; everything operates locally or peer-to-peer (future).

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
