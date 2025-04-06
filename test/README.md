# API Integration Tests Documentation

## Overview
This documentation covers the integration test setup for the Progres mobile application, focusing on API interaction testing.

## Test Structure

### Test Files
- `helpers/mock_secure_storage.dart`: Mock implementation of secure storage
- `helpers/test_http_override.dart`: HTTP client override for testing
- `.env.test`: Test environment configuration file

### Environment Setup
Tests use a `.env.test` file for configuration:
```
TEST_USERNAME=your_test_username
TEST_PASSWORD=your_test_password
```

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

### Prerequisites
1. Create `.env.test` file in project root

```
cp .env.example .env.test
```

2. Configure test credentials
3. Ensure test dependencies are installed

### Execute Tests
Run all integration tests:
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
- Use environment variables

## Contributing
When adding new tests:
1. Follow existing test structure
2. Add appropriate mocks if needed
3. Document new test cases
4. Ensure cleanup after tests
