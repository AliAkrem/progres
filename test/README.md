# API Integration Tests Documentation

## Overview
This documentation covers the integration test setup for the Progres mobile application, focusing on API interaction testing.

## Test Structure

### Test Files
- `helpers/mock_secure_storage.dart`: Mock implementation of secure storage
- `helpers/test_http_override.dart`: HTTP client override for testing

### Environment Setup
Tests require environment variables passed via dart-define:
- TEST_USERNAME: Username for test authentication
- TEST_PASSWORD: Password for test authentication

## Test Components

### Mock Classes

#### MockSecureStorage
A mock implementation of secure storage for testing:
- Simulates storage operations
- Allows verification of storage interactions
- Used to test token storage functionality

#### TestHttpOverrides
Custom HTTP client configuration for testing:
- Handles SSL certificates in test environment
- Manages HTTP connections during tests
- Enables API endpoint testing

## Running Tests


### Execute Tests
Run all integration tests:
```bash
flutter test --dart-define=TEST_USERNAME=your_test_username --dart-define=TEST_PASSWORD=your_test_password
```

You can also use default test values by running without parameters:
```bash
flutter test
```

## Best Practices

### Test Setup
- Use `setUpAll()` for one-time configurations
- Use `setUp()` for per-test initialization
- Clean up resources after each test

### API Testing
- Verify response structures
- Test error scenarios
- Validate data persistence
- Clean up after tests

### Security
- Never commit real credentials
- Pass sensitive data through dart-define parameters
- Don't store test credentials in version control

## Contributing
When adding new tests:
1. Follow existing test structure
2. Add appropriate mocks if needed
3. Document new test cases
4. Ensure cleanup after tests
