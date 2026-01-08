# Technology Stack & Build System

## Core Framework
- **Flutter SDK**: Latest stable version (>=3.22.2)
- **Dart SDK**: >=3.6.0 <4.0.0
- **Target Platforms**: Android, iOS, Linux

## State Management & Architecture
- **State Management**: Provider pattern for dependency injection
- **Architecture**: Service-Oriented Architecture (SOA) with Clean Architecture principles
- **Database**: Hive (NoSQL) for local persistence
- **Storage**: SharedPreferences for simple key-value storage

## Key Dependencies
- **UI/Animations**: Lottie, CarouselSlider, SmoothPageIndicator
- **Audio**: audioplayers, flutter_tts
- **Notifications**: flutter_local_notifications
- **Utilities**: intl (localization), uuid, crypto, collection
- **Development**: flutter_lints, hive_generator, build_runner

## Common Commands

### Development
```bash
# Navigate to project directory
cd active_source_wing

# Install dependencies
flutter pub get

# Run code generation (for Hive models)
flutter packages pub run build_runner build

# Run the application
flutter run

# Format code
dart format .

# Analyze code
flutter analyze
```

### Testing
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/core/services/db_service_test.dart

# Run integration tests
flutter drive --target=integration_test/app_flow_test.dart
```

### Quality Assurance
```bash
# Fix auto-fixable issues
dart fix --apply

# Check for unused dependencies
flutter pub deps

# Build for release (Android)
flutter build apk --release

# Build for release (iOS)
flutter build ios --release
```

## Code Generation
The project uses code generation for:
- **Hive TypeAdapters**: Models ending with `.g.dart`
- Run `flutter packages pub run build_runner build` after model changes

## Logging System
- Use `WingLogger` instead of `print()` statements
- Available levels: info, warning, error, critical
- Example: `WingLogger.info('Message', tag: 'ComponentName')`

## Arabic Language Support
- Primary locale: `ar_SA` (Arabic - Saudi Arabia)
- Use RTL-aware widgets and layouts
- Text direction handled automatically by Flutter