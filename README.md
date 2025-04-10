# Test Boshqaruv Tizimi (Test Management System)

A Flutter desktop application for managing tests, variants, and educational content.

## Overview

This application is designed for educational institutions to manage tests, create variants, and organize educational content. It provides a user-friendly interface for administrators, teachers, and moderators.

## Features

- **User Authentication**: Secure login system for different user roles
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

4. Run the application:
   ```
   flutter run -d windows  # For Windows
   flutter run -d macos    # For macOS
   flutter run -d linux    # For Linux
   ```

## Project Structure

- `lib/screens/` - UI screens for different sections of the application
- `lib/utils/` - Utility classes and constants
- `lib/models/` - Data models
- `lib/services/` - Business logic and services

## License

This project is licensed under the MIT License - see the LICENSE file for details.
