# Project Structure & Organization

## Root Directory Layout
```
active_source_wing/          # Main Flutter application
├── lib/                     # Dart source code
├── test/                    # Unit and widget tests
├── integration_test/        # Integration tests
├── assets/                  # Static assets (images, fonts, data)
├── android/                 # Android platform code
├── ios/                     # iOS platform code
├── linux/                   # Linux platform code
└── docs/                    # Project documentation
```

## Core Library Structure (`lib/`)

### `lib/core/` - Shared Foundation
```
core/
├── cognitive/              # Advanced psychological engines
│   ├── emotional_gravity_engine.dart
│   ├── surprise_evolution_engine.dart
│   ├── dual_truth_engine.dart
│   └── psychological_context_manager.dart
├── infrastructure/         # System initialization & governance
│   ├── app_initializer.dart
│   ├── wing_logger.dart
│   └── sef_governance_system.dart
├── models/                 # Data models (Hive entities)
│   ├── memory_model.dart
│   ├── gratitude_entry_model.dart
│   └── verse_model.dart
├── psychology/             # Emotional state logic
│   ├── emotional_state.dart
│   └── psychological_analysis_engine.dart
├── security/               # Data protection & error handling
│   ├── secure_data_manager.dart
│   └── safe_error_handler.dart
└── services/               # Business logic services
    ├── db_service.dart
    ├── auth_service.dart
    └── notification_service.dart
```

### `lib/features/` - Feature-Specific Code
```
features/
├── home/
│   ├── screens/
│   │   ├── home_screen.dart
│   │   └── enhanced_home_screen.dart
│   └── widgets/
│       └── enhanced_parallax_layer.dart
├── memories/
│   └── screens/
│       └── memory_detail_screen.dart
└── messages/
    └── screens/
        └── love_message_screen.dart
```

## Test Structure (`test/`)
```
test/
├── core/
│   ├── cognitive/          # Tests for psychological engines
│   ├── models/             # Model tests
│   ├── psychology/         # Emotional system tests
│   ├── security/           # Security tests
│   └── services/           # Service tests
├── features/               # Feature-specific tests
├── integration/            # Integration tests
├── performance/            # Performance tests
└── widgets/                # Widget tests
```

## Assets Structure (`assets/`)
```
assets/
├── data/                   # JSON configuration files
│   ├── message_templates.json
│   └── compliance_manifest.json
├── images/                 # Static images
├── lottie/                 # Animation files
└── sounds/                 # Audio files
```

## Naming Conventions

### Files & Directories
- **Snake_case** for file names: `emotional_gravity_engine.dart`
- **Lowercase** for directory names: `cognitive/`, `services/`
- **Descriptive names** that indicate purpose

### Classes & Functions
- **PascalCase** for classes: `EmotionalGravityEngine`
- **camelCase** for functions and variables: `analyzeEmotionalState()`
- **Arabic comments** for cultural context where appropriate

### Models
- All models end with `Model`: `MemoryModel`, `GratitudeEntryModel`
- Generated files end with `.g.dart`: `memory_model.g.dart`

## Import Organization
```dart
// Flutter/Dart imports first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Core imports
import 'core/services/db_service.dart';
import 'core/models/memory_model.dart';

// Feature imports
import 'features/home/screens/home_screen.dart';
```

## Documentation Standards
- **Arabic comments** for cultural/spiritual context
- **English comments** for technical implementation
- **Comprehensive documentation** for public APIs
- **README files** in each major directory explaining purpose

## Code Organization Principles
1. **Separation of Concerns**: Core vs Features vs UI
2. **Dependency Direction**: Features depend on Core, not vice versa
3. **Single Responsibility**: Each file has one clear purpose
4. **Testability**: Structure supports easy unit testing
5. **Scalability**: Easy to add new features without affecting existing code