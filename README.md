# Test Boshqaruv Tizimi (Test Management System)

A Flutter desktop application for managing university entrance tests, variants, and educational content.

## Overview

This application is designed for educational institutions to manage tests, create variants, and organize educational content. It provides a user-friendly interface for administrators, moderators, and teachers.

## Features

- **User Authentication**: Secure login system for different user roles (Admin, Moderator, Teacher)
- **Dashboard**: Overview of system statistics and activities
- **Variant Creation**: Tools for creating test variants
- **Teacher Management**: Add, edit, and manage teacher accounts
- **Test Management**: Create, edit, and organize tests
- **Moderator Management**: Assign and manage content moderators
- **Direction Management**: Organize educational directions/departments
- **Subject Management**: Manage educational subjects
- **Settings**: System configuration options

## Technical Details

- Built with Flutter for cross-platform desktop support (Windows, macOS, Linux)
- Uses Material 3 design principles for a modern UI
- Responsive layout suitable for various screen sizes
- Clean Architecture with Feature-First approach
- BLoC pattern for state management
- Dependency Injection with GetIt and Injectable
- Networking with Dio
- Routing with GoRouter
- Local storage with Shared Preferences and Flutter Secure Storage
- Data modeling with Freezed and JSON Serializable

## Getting Started

### Prerequisites

- Flutter SDK (version 3.7.2 or higher)
- Dart SDK (version 3.0.0 or higher)

### Installation

1. Clone the repository:

   ```
   git clone https://github.com/yourusername/variant_master.git
   ```

2. Navigate to the project directory:

   ```
   cd variant_master
   ```

3. Install dependencies:

   ```
   flutter pub get
   ```

4. Run code generation:

   ```
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. Run the application:
   ```
   flutter run -d windows  # For Windows
   flutter run -d macos    # For macOS
   flutter run -d linux    # For Linux
   ```

## Project Structure

```
lib/
├── app.dart                  # App entry point
├── main.dart                 # Main function
├── core/                     # Core components
│   ├── di/                   # Dependency injection
│   ├── error/                # Error handling
│   ├── network/              # Network utilities
│   ├── router/               # Routing
│   ├── storage/              # Local storage
│   ├── theme/                # App theme
│   └── utils/                # Utilities
└── features/                 # Features
    ├── auth/                 # Authentication feature
    │   ├── data/             # Data layer
    │   │   ├── datasources/  # Data sources
    │   │   ├── models/       # Data models
    │   │   └── repositories/ # Repository implementations
    │   ├── domain/           # Domain layer
    │   │   ├── entities/     # Domain entities
    │   │   ├── repositories/ # Repository interfaces
    │   │   └── usecases/     # Use cases
    │   └── presentation/     # Presentation layer
    │       ├── bloc/         # BLoC
    │       ├── pages/        # Pages
    │       └── widgets/      # Widgets
    ├── dashboard/            # Dashboard feature
    ├── teachers/             # Teachers feature
    ├── moderators/           # Moderators feature
    ├── tests/                # Tests feature
    ├── variants/             # Variants feature
    ├── directions/           # Directions feature
    ├── subjects/             # Subjects feature
    └── settings/             # Settings feature
```

## Testing

Run tests with:

```
flutter test
```

For BLoC tests:

```
flutter test test/features/auth/presentation/bloc/auth_bloc_test.dart
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.
