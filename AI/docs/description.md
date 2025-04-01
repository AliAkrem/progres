# Student Mobile Application

## Overview
The Student Mobile Application is a Flutter-based solution designed specifically for university students to access their academic information securely. The application leverages institutional APIs to provide students with a comprehensive view of their academic records, grades, and institutional information—all through a streamlined mobile interface.

## Target Platform
- Primary: Android
- Architecture: Flutter (Dart)

## Core Features

### 1. Authentication System
- Secure login using institutional credentials (student code and password)
- JWT token-based session management
- Password recovery integration with institutional systems
- Secure token storage and expiration handling

### 2. Student Profile
- Personal information display in both Latin and Arabic scripts:
  - First and last name in both scripts
  - Date and place of birth
  - Student identification numbers
- Profile image retrieval and display
- University logo display

### 3. Academic Information
- Current academic year information
- Enrollment details and registration number
- Educational level and cycle information in both languages
- Transportation status tracking

### 4. Academic Structure
- Detailed view of academic periods (semesters)
- Support for bilingual display of semester information
- Period ordering and organization
- Educational cycle information in Arabic and French

### 5. Academic Performance
- Exam results for each course and period
- Continuous assessment grades (projects, tutorials, practical work)
- Grade categorization by type of assessment
- Appeal window information for grade disputes
- Support for different assessment types (PRJ, TD, TP)

## User Interface Design

### Design Philosophy
- Clean, intuitive interface following Material Design guidelines
- Bilingual support (Arabic and Latin scripts)
- Responsive layouts for various Android device sizes
- Clear loading states and feedback mechanisms

### Main Screens
1. **Login Screen**
   - Institutional branding with university logo
   - Student code and password fields
   - "Forgot Password" option
   - Error messaging for failed attempts

2. **Dashboard/Home Screen**
   - Student profile summary with photo
   - Quick access to key academic information
   - Current academic period indicator

3. **Profile Screen**
   - Detailed student information in both language scripts
   - Profile image
   - Birth and identification information
   - Registration details

4. **Academic Periods Screen**
   - Semester organization and navigation
   - Period detail view
   - Cycle and level information

5. **Grades & Assessment Screen**
   - Exam results by course and period
   - Continuous assessment grades by type
   - Appeal status and deadlines
   - Performance visualization

## Technical Architecture

### State Management
- BLoC (Business Logic Component) pattern
- Clear separation of UI and business logic
- Efficient state handling for responsive UI

### Data Management
- Secure local storage for authentication tokens
- Proper caching mechanisms for frequently accessed data
- Offline capabilities for basic information viewing
- Synchronized data refresh strategy

### API Integration
- RESTful service integration
- JWT token authentication
- Efficient handling of nested API dependencies
- Bilingual data handling (Arabic and Latin scripts)
- Image data processing for profile and logo display

### Security Considerations
- Secure storage of authentication credentials
- HTTPS for all API communications
- Token expiration handling
- Session timeout management
- Secure data caching
