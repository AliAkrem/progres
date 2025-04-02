# Progres App - Architecture and Patterns

## Architectural Overview

The Progres application follows a clean architecture approach that separates concerns and maintains a clear dependency flow. The architecture is designed to be scalable, maintainable, and testable.

## Architecture Layers

### 1. Presentation Layer

The presentation layer is responsible for rendering the UI and handling user input:

- **Pages**: Flutter widgets that compose the screens
- **BLoC (Business Logic Component)**: Manages state and business logic for UI components
- **Events**: Input events sent to the BLoC
- **States**: Output states emitted by the BLoC

### 2. Data Layer

The data layer handles data operations and external services:

- **Repositories**: Implementations of interfaces that abstract data sources
- **Models**: Data structures that represent domain entities
- **Data Sources**: External services like APIs or local databases

## State Management

The application uses the BLoC pattern for state management, which provides several benefits:

- Clear separation between UI and business logic
- Predictable state transitions
- Testable components
- Reactive programming approach

## Example BLoC Flow:

1. The UI dispatches an event to the BLoC
2. The BLoC processes the event and performs operations via repositories
3. The BLoC emits a new state
4. The UI rebuilds based on the new state

```dart
// Event dispatching (from UI)
context.read<AuthBloc>().add(CheckAuthStatusEvent());

// State handling (in UI)
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    if (state is AuthLoading) {
      return LoadingIndicator();
    } else if (state is AuthAuthenticated) {
      return AuthenticatedScreen();
    } else {
      return LoginScreen();
    }
  },
)
```

## Dependency Injection

Dependency injection is implemented using:

- `RepositoryProvider`: For injecting repositories
- `BlocProvider`: For injecting BLoCs

This approach:
- Makes dependencies explicit
- Facilitates testing through mock dependencies
- Ensures proper lifecycle management of services

```dart
MultiRepositoryProvider(
  providers: [
    RepositoryProvider(
      create: (context) => AuthRepositoryImpl(),
    ),
    // Other repositories
  ],
  child: MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => AuthBloc(
          authRepository: context.read<AuthRepositoryImpl>(),
        ),
      ),
      // Other blocs
    ],
    child: AppComponent(),
  ),
)
```

## Routing

The application uses GoRouter for declarative routing, which provides:

- Nested routes
- Route parameters
- Deep linking
- Transition animations

## Repository Pattern

The Repository pattern is used to abstract data sources and provide a clean API for accessing data:

- Repositories define interfaces for data operations
- Implementations handle the specifics of data sources (API, local storage, etc.)
- BLoCs interact with repositories, not directly with data sources

## Coding Practices

### Folder Structure
The application follows a feature-first approach where each feature contains its own layers, promoting:
- High cohesion within features
- Low coupling between features
- Clear boundaries

### Naming Conventions
- **Files**: snake_case (e.g., `auth_repository.dart`)
- **Classes**: PascalCase (e.g., `AuthRepository`)
- **Methods/Variables**: camelCase (e.g., `getUserProfile()`)
- **Constants**: SCREAMING_SNAKE_CASE (e.g., `DEFAULT_TIMEOUT`)

### Error Handling
- Repository methods return appropriate error types or throw exceptions
- BLoCs catch exceptions and transform them into appropriate states
- UI handles error states appropriately 