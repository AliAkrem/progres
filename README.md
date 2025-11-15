# Progres

[<img src='https://stc.utdstc.com/img/mediakit/download-gio-big.png' alt='Download progres'>](https://progres.en.uptodown.com/android)

[![Download progres](https://a.fsdn.com/con/app/sf-download-button)](https://sourceforge.net/projects/progres/files/latest/download)

Progres is an independently developed remake of Progres/Webetu with a focus on enhanced user experience.

![image1](https://github.com/user-attachments/assets/b33a0fda-5827-45b1-a526-204b2f408c79)

I built this app because the original student portal (Progres/Webetu) is... well, not the best. It’s slow, outdated, and not very user-friendly. I wanted something faster, cleaner, and more reliable
So I decided to rebuild it from scratch, with a better design and offline support. It's open-source too, so that anyone can improve it.

> **Note:** This application is not officially affiliated with Progres/Webetu or any educational institution.

## Key Features

- **Modern UI/UX** - Intuitive interface built with Material Design 3
- **Bilingual Support** - Full support for both Arabic scripts
- **Enhanced Performance** - Optimized for speed and reliability

## Screenshots

<p align="center">
  <img src="screenshot/login.jpg" width="200" alt="Login Screen" />
  <img src="screenshot/profile.jpg" width="200" alt="Profile Screen" /> 
  <img src="screenshot/menu.jpg" width="200" alt="Menu Screen" />
</p>

<p align="center">
  <img src="screenshot/transcript.jpg" width="200" alt="Transcript Screen" />
  <img src="screenshot/assessment.jpg" width="200" alt="Assessment Screen" />
  <img src="screenshot/exams.jpg" width="200" alt="Exams Screen" />
  <img src="screenshot/timeline.jpg" width="200" alt="Timeline Screen" />
  <img src="screenshot/discharge.jpg" width="200" alt="Discharge Screen" />
</p>

## App Modules

- **Authentication**
- **Student Profile**
- **Academic Records**
- **Performance Tracking**
- **Academic history**
- **Weekly Timeline**
- **Student Discharge**

## Technical Details

### Built With

- Flutter for cross-platform compatibility
- BLoC pattern for state management
- local storage for offline capabilities

### Architecture

- Clean architecture with separation of concerns
- Repository pattern for data management

## Getting Started

### Prerequisites

- Flutter SDK (version 3.38.1)
- Dart SDK (version 3.10.0)
- [FVM (Flutter Version Management)](https://fvm.app/) - Recommended for managing Flutter versions

### Run Locally

1. Clone the repository

   ```bash
   git clone https://github.com/aliakrem/progres.git
   ```

2. Navigate to project directory

   ```bash
   cd progres
   ```

   > **Note:** If you prefer not to use FVM, you can run standard Flutter commands directly, but ensure you're using Flutter 3.38.1 and Dart 3.10.0.

3. Install FVM (if not already installed)

   ```bash
   dart pub global activate fvm
   ```

4. Install the Flutter version specified in `.fvmrc`

   ```bash
   fvm install
   ```

5. Use the configured Flutter version
   ```bash
   fvm use stable
   ```
6. Install dependencies

   ```bash
   fvm flutter pub get
   ```

7. Run the app
   ```bash
   fvm flutter run
   ```

## In The Future

- [x] Arabic language support
- [ ] Push notifications for grade updates
- [ ] Push notifications for courses start

## Contributing

[View contributing guidelines](https://github.com/AliAkrem/progres/blob/master/CONTRIBUTING.md)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<p align="center">
  Made with ❤️ by 
</p>
<p align="center">
  <a href="https://github.com/aliakrem/progres/graphs/contributors">
    <img src="https://contrib.rocks/image?repo=aliakrem/progres" />
  </a>
</p>
