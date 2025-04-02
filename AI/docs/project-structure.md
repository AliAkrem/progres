# Progres App - Project Structure

## Overview

The Progres application follows a clean architecture approach with feature-based organization. This document outlines the project's folder structure and the purpose of each component.

## Root Structure

```
lib/
├── config/        # Application-wide configuration
├── core/          # Core utilities and shared components
├── features/      # Feature modules (domain-specific functionality)
├── layouts/       # Layout components and shells
└── main.dart      # Application entry point
```

## Configuration (`config/`)

```
config/
├── routes/        # Routing configuration
└── theme/         # Theme configuration
```

The configuration directory contains app-wide settings:
- **routes/**: Contains the app router configuration for navigation
- **theme/**: Defines the application's theme settings and styles

## Core (`core/`)

```
core/
├── network/       # Networking utilities and API clients
└── theme/         # Theme state management
```

The core directory houses fundamental utilities:
- **network/**: Network-related utilities, API clients, and interceptors
- **theme/**: Theme state management (BLoC) for handling theme changes

## Features (`features/`)

```
features/
├── academics/     # Academic information feature
├── app/           # App-wide feature components
├── auth/          # Authentication feature
├── home/          # Home screen feature
├── profile/       # User profile feature
└── settings/      # Application settings feature
```

Each feature follows a layered architecture:
```
feature/
├── data/          # Data layer (repositories, models)
│   ├── models/    # Data models
│   └── repositories/ # Repository implementations
└── presentation/  # Presentation layer (UI)
    ├── bloc/      # Business Logic Components
    └── pages/     # UI pages and widgets
```

## Layouts (`layouts/`)

```
layouts/
└── main_shell.dart # Main application shell/layout
```

Contains the application's layout shells and structural UI components.

## Main Entry Point

`main.dart` serves as the application's entry point, setting up:
- Dependency injection (Repository providers)
- State management (BLoC providers)
- Theme configuration
- Routing 