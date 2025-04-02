# Progres App - Feature Modules

## Overview

The Progres app follows a feature-based architecture where each functional area is encapsulated in its own module. This document outlines the purpose and components of each feature module.

## Feature Modules Structure

Each feature module follows a consistent structure:

```
feature/
├── data/                   # Data layer
│   ├── models/             # Data models
│   └── repositories/       # Repository implementations
└── presentation/           # Presentation layer
    ├── bloc/               # State management
    └── pages/              # UI components
```

## Authentication (auth)

The authentication feature handles user login, session management, and security.

### Purpose
- Authenticate users with institutional credentials
- Manage authentication state
- Handle token storage and refresh
- Implement logout functionality

### Key Components
- `AuthBloc`: Manages authentication state
- `AuthRepository`: Handles API communication for auth
- Login page and components
- Session management utilities

## Profile (profile)

The profile feature displays user information and profile management.

### Purpose
- Display user profile information
- Show student details in multiple languages
- Handle profile updates if applicable

### Key Components
- `ProfileBloc`: Manages profile data state
- `StudentRepository`: Fetches student information
- Profile page and components

## Academics (academics)

The academics feature provides access to academic information and records.

### Purpose
- Display academic periods and semesters
- Show course information
- Present grade reports and transcripts
- Handle academic appeals if applicable

### Key Components
- `AcademicsBloc`: Manages academic data state
- Academic pages (grades, courses, etc.)
- Period/semester navigation components

## Home (home)

The home feature serves as the main dashboard for the application.

### Purpose
- Provide an overview of key information
- Act as a navigation hub to other features
- Display notifications and announcements

### Key Components
- `HomeBloc`: Manages home screen state
- Dashboard widgets and components
- Quick access tiles to other features

## Settings (settings)

The settings feature allows users to customize their application experience.

### Purpose
- Manage application preferences
- Language selection
- Theme customization
- Notification settings

### Key Components
- Settings pages and components
- Preference storage utilities

## App (app)

The app feature contains application-wide components that don't belong to a specific domain.

### Purpose
- Shared UI components
- Application-wide utilities
- Cross-feature functionality

### Key Components
- Common widgets
- Shared utilities
- Global state managers

## Cross-Feature Communication

Features can communicate with each other through:

1. **BLoC to BLoC**: Using BlocListeners to react to state changes in other BLoCs
2. **Shared Repositories**: Accessing common data through injected repositories
3. **Navigation Events**: Features can trigger navigation to other features

## Adding New Features

When adding a new feature:

1. Create a new directory under `features/`
2. Follow the established structure (data and presentation layers)
3. Define clear boundaries for the feature
4. Inject dependencies through the provider system
5. Add routes to the app router
6. Update the main layout if necessary 