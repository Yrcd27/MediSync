# MediSync Frontend - Personal Health Record Tracker

A beautiful, modern Flutter application for managing personal health records with comprehensive tracking, analytics, and insights.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Technology Stack](#technology-stack)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Configuration](#configuration)
- [Screens & Navigation](#screens--navigation)
- [State Management](#state-management)
- [Services & API Integration](#services--api-integration)
- [Models](#models)
- [Widgets](#widgets)
- [Theme & Styling](#theme--styling)
- [Building & Running](#building--running)
- [Deployment](#deployment)

## 🌟 Overview

MediSync is a cross-platform mobile application built with Flutter that empowers users to track and manage their personal health records. The app provides an intuitive interface for logging various health metrics, viewing historical data with beautiful charts, receiving health insights, and maintaining a complete medical history.

## ✨ Features

### 🔐 Authentication & User Management
- Secure user registration and login
- Session persistence with SharedPreferences
- Profile management with personal health information
- Automatic session restoration

### 📊 Health Record Tracking
Track comprehensive health metrics:
- **Blood Pressure**: Monitor systolic/diastolic readings over time
- **Fasting Blood Sugar (FBS)**: Track glucose levels
- **Full Blood Count (FBC)**: Haemoglobin, WBC, platelet counts
- **Lipid Profile**: Complete cholesterol analysis (Total, HDL, LDL, VLDL, Triglycerides)
- **Liver Profile**: Liver function tests (Protein, Albumin, Bilirubin, SGPT)
- **Urine Report**: Comprehensive urinalysis tracking

### 📈 Analytics & Insights
- Interactive charts using FL Chart
- Trend analysis for all health metrics
- Health status indicators (Normal, At Risk, Abnormal)
- Color-coded visual feedback
- Historical data comparison
- AI-powered health insights

### 🎨 Modern UI/UX
- Material Design 3 with custom theming
- Dark mode support
- Smooth animations with Flutter Animate
- Shimmer loading effects
- Google Fonts integration
- Responsive design for all screen sizes
- Beautiful gradient backgrounds
- Custom cards and components

### 📱 Cross-Platform
- **Android**: Full native support
- **iOS**: Complete iOS implementation
- **Web**: Web-ready deployment
- **Windows**: Desktop support
- **macOS**: macOS compatibility
- **Linux**: Linux desktop support

## 🛠 Technology Stack

### Core Framework
- **Flutter**: 3.9.0+ (Cross-platform UI framework)
- **Dart**: 3.9.0+ (Programming language)

### State Management
- **Provider**: 6.1.1 (State management solution)

### HTTP & Networking
- **HTTP**: 1.1.0 (REST API communication)
- **SharedPreferences**: 2.2.2 (Local data persistence)

### UI/UX Libraries
- **FL Chart**: 0.64.0 (Beautiful interactive charts)
- **Google Fonts**: 6.1.0 (Custom typography)
- **Shimmer**: 3.0.0 (Loading animations)
- **Flutter Animate**: 4.3.0 (Advanced animations)
- **Intl**: 0.18.1 (Internationalization and date formatting)

### Development Tools
- **Flutter Lints**: 5.0.0 (Code quality and best practices)

## 📦 Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK**: 3.9.0 or higher
  - Download from [flutter.dev](https://flutter.dev/docs/get-started/install)
- **Dart SDK**: 3.9.0 or higher (comes with Flutter)
- **Android Studio** or **Xcode** (for mobile development)
- **VS Code** or **Android Studio** (IDE)
- **Git**: For version control

### Platform-Specific Requirements

#### Android Development
- Android Studio
- Android SDK (API level 21 or higher)
- Java Development Kit (JDK)

#### iOS Development (macOS only)
- Xcode 12.0 or higher
- CocoaPods
- iOS Simulator or physical device

#### Web Development
- Chrome browser for debugging

## 📁 Project Structure

```
frontend/
├── lib/
│   ├── core/                         # Core functionality
│   │   ├── config/
│   │   │   └── app_config.dart       # API endpoints & configuration
│   │   ├── constants/
│   │   │   └── app_colors.dart       # Color constants
│   │   ├── services/
│   │   │   └── api_service.dart      # Base API service
│   │   ├── theme/
│   │   │   ├── app_theme.dart        # App theme definitions
│   │   │   └── theme_provider.dart   # Theme state management
│   │   └── utils/
│   │       ├── app_logger.dart       # Logging utility
│   │       ├── exception_handler.dart # Error handling
│   │       └── health_analysis.dart   # Health data analysis
│   │
│   ├── models/                       # Data models
│   │   ├── user.dart
│   │   ├── blood_pressure.dart
│   │   ├── fasting_blood_sugar.dart
│   │   ├── full_blood_count.dart
│   │   ├── lipid_profile.dart
│   │   ├── liver_profile.dart
│   │   ├── urine_report.dart
│   │   └── report.dart
│   │
│   ├── providers/                    # State management
│   │   ├── auth_provider.dart
│   │   └── health_records_provider.dart
│   │
│   ├── screens/                      # UI screens
│   │   ├── splash_screen.dart
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   └── signup/
│   │   ├── main/
│   │   │   ├── main_layout.dart      # Bottom navigation
│   │   │   ├── dashboard_screen.dart
│   │   │   ├── records_hub_screen.dart
│   │   │   ├── analytics_screen.dart
│   │   │   └── profile_screen.dart
│   │   └── records/
│   │       ├── all_records_screen.dart
│   │       ├── add/                  # Add record screens
│   │       │   ├── add_blood_pressure_screen.dart
│   │       │   ├── add_blood_sugar_screen.dart
│   │       │   ├── add_blood_count_screen.dart
│   │       │   ├── add_lipid_profile_screen.dart
│   │       │   ├── add_liver_profile_screen.dart
│   │       │   └── add_urine_report_screen.dart
│   │       └── view/                 # View record screens
│   │           ├── view_blood_pressure_screen.dart
│   │           ├── view_blood_sugar_screen.dart
│   │           ├── view_blood_count_screen.dart
│   │           ├── view_lipid_profile_screen.dart
│   │           ├── view_liver_profile_screen.dart
│   │           └── view_urine_report_screen.dart
│   │
│   ├── services/                     # API services
│   │   ├── auth_service.dart
│   │   ├── blood_pressure_service.dart
│   │   ├── fasting_blood_sugar_service.dart
│   │   ├── full_blood_count_service.dart
│   │   ├── lipid_profile_service.dart
│   │   ├── liver_profile_service.dart
│   │   ├── urine_report_service.dart
│   │   ├── report_service.dart
│   │   └── health_insights_service.dart
│   │
│   ├── widgets/                      # Reusable widgets
│   │   ├── alerts/
│   │   ├── buttons/
│   │   ├── cards/
│   │   │   ├── health_metric_card.dart
│   │   │   ├── analysis_detail_card.dart
│   │   │   ├── info_card.dart
│   │   │   └── report_card.dart
│   │   ├── common/
│   │   ├── feedback/
│   │   ├── inputs/
│   │   └── modals/
│   │
│   └── main.dart                     # App entry point
│
├── assets/
│   └── images/                       # Image assets
│
├── android/                          # Android platform code
├── ios/                              # iOS platform code
├── web/                              # Web platform code
├── windows/                          # Windows platform code
├── macos/                            # macOS platform code
├── linux/                            # Linux platform code
│
├── pubspec.yaml                      # Dependencies
├── analysis_options.yaml             # Linting rules
└── README.md

```

## 🚀 Getting Started

### 1. Install Flutter

Follow the official Flutter installation guide:
- [Windows](https://flutter.dev/docs/get-started/install/windows)
- [macOS](https://flutter.dev/docs/get-started/install/macos)
- [Linux](https://flutter.dev/docs/get-started/install/linux)

Verify installation:
```bash
flutter doctor
```

### 2. Clone the Repository

```bash
cd frontend
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Configure Backend URL

Edit [lib/core/config/app_config.dart](lib/core/config/app_config.dart):

```dart
class AppConfig {
  static String get baseUrl {
    // For hosted backend
    return 'https://your-backend-url.com';
    
    // For local development
    // return 'http://localhost:8080';
    
    // For physical device testing
    // return 'http://192.168.1.100:8080';
  }
}
```

### 5. Run the App

#### Run on Android/iOS Emulator
```bash
flutter run
```

#### Run on Specific Device
```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>
```

#### Run on Web
```bash
flutter run -d chrome
```

#### Run on Desktop
```bash
# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux
```

## ⚙ Configuration

### Backend API Configuration

The app connects to the MediSync backend API. Configure the base URL in [app_config.dart](lib/core/config/app_config.dart):

```dart
// Hosted backend (Production)
static String get baseUrl {
  return 'https://medisync-backend-production.up.railway.app';
}

// Local development
static String get baseUrl {
  return 'http://localhost:8080';
}

// Physical device (use your computer's IP)
static String get baseUrl {
  return 'http://192.168.1.100:8080';
}
```

### API Endpoints

All endpoints are automatically configured based on the backend structure:

```dart
// User endpoints
static const String login = '/users/login';
static const String addUser = '/users/addUser';

// Health record endpoints
static const String bloodPressureEndpoint = '/blood_pressure';
static const String fbsEndpoint = '/fbs';
static const String fbcEndpoint = '/fbc';
static const String lipidEndpoint = '/lipid_profile';
static const String liverEndpoint = '/liver_profile';
static const String urineEndpoint = '/urine_report';
static const String reportsEndpoint = '/reports';
```

## 📱 Screens & Navigation

### Authentication Flow
1. **Splash Screen**: App initialization and session check
2. **Login Screen**: User authentication
3. **Signup Screen**: New user registration

### Main Navigation (Bottom Navigation Bar)
1. **Dashboard**: Overview of recent health metrics and quick actions
2. **Records Hub**: Access all health record types
3. **Analytics**: Charts and trends for health data
4. **Profile**: User information and settings

### Health Record Screens
Each health metric has dedicated screens:
- **Add Record**: Form to input new health data
- **View Records**: List of historical records with details
- **Record Details**: Individual record view with insights

## 🔄 State Management

### Providers

#### AuthProvider
Manages user authentication state:
- Login/Logout functionality
- Session persistence
- User profile management
- Authentication status

```dart
// Usage example
final authProvider = Provider.of<AuthProvider>(context);
await authProvider.login(email, password);
```

#### HealthRecordsProvider
Manages all health records:
- CRUD operations for all record types
- Bulk data loading
- Record filtering and sorting
- Data caching

```dart
// Usage example
final healthProvider = Provider.of<HealthRecordsProvider>(context);
await healthProvider.loadAllRecords(userId);
```

#### ThemeProvider
Manages app theme:
- Light/Dark mode switching
- Theme persistence
- Dynamic theme updates

```dart
// Usage example
final themeProvider = Provider.of<ThemeProvider>(context);
themeProvider.toggleTheme();
```

## 🌐 Services & API Integration

### Base API Service
[api_service.dart](lib/core/services/api_service.dart) provides:
- HTTP request handling (GET, POST, PUT, DELETE)
- Response parsing and error handling
- Session management
- Request logging

### Specialized Services

#### AuthService
- User login and registration
- Session management
- Token handling

#### Health Record Services
Each health metric has a dedicated service:
- `BloodPressureService`
- `FastingBloodSugarService`
- `FullBloodCountService`
- `LipidProfileService`
- `LiverProfileService`
- `UrineReportService`
- `ReportService`

All services extend the base API service and provide:
- Add new record
- Get all records
- Get record by ID
- Get records by user ID
- Update record
- Delete record

#### HealthInsightsService
Provides AI-powered health analysis and recommendations based on health data trends.

## 📊 Models

All models match the backend entity structure:

### User Model
```dart
class User {
  final int id;
  final String name;
  final String email;
  final String dateOfBirth;
  final String gender;
  final double height;
  final double weight;
  final String bloodGroup;
}
```

### Health Record Models
- `BloodPressure`: BP readings with date and status
- `FastingBloodSugar`: Glucose levels
- `FullBloodCount`: Complete blood count data
- `LipidProfile`: Cholesterol analysis
- `LiverProfile`: Liver function tests
- `UrineReport`: Urinalysis results
- `Report`: Consolidated health report

All models include:
- JSON serialization/deserialization
- Data validation
- Helper methods for display formatting

## 🎨 Widgets

### Reusable Components

#### Cards
- **HealthMetricCard**: Display health metric summaries
- **AnalysisDetailCard**: Show detailed analysis
- **InfoCard**: General information display
- **ReportCard**: Health report summaries

#### Inputs
- Custom text fields with validation
- Date pickers
- Dropdown selectors
- Form validators

#### Buttons
- Primary action buttons
- Secondary buttons
- Icon buttons
- Loading states

#### Feedback
- Success/Error messages
- Loading indicators with shimmer
- Empty state displays
- Confirmation dialogs

## 🎨 Theme & Styling

### App Theme
The app supports both light and dark themes with:
- Custom color schemes
- Google Fonts (default: Poppins)
- Consistent spacing and sizing
- Material Design 3 components

### Colors
Defined in [app_colors.dart](lib/core/constants/app_colors.dart):
- Primary colors
- Status colors (success, warning, error)
- Gradient combinations
- Health metric colors

### Animations
- Smooth page transitions
- Loading animations with shimmer
- Micro-interactions using Flutter Animate
- Chart animations with FL Chart

## 🔨 Building & Running

### Development Mode

```bash
# Run with hot reload
flutter run

# Run with specific flavor
flutter run --flavor development
```

### Debug Mode
```bash
flutter run --debug
```

### Profile Mode (Performance Testing)
```bash
flutter run --profile
```

### Release Mode
```bash
flutter run --release
```

## 📦 Building for Production

### Android APK
```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### iOS
```bash
flutter build ios --release
```

Then open in Xcode for archiving and distribution.

### Web
```bash
flutter build web --release
```

Output: `build/web/`

### Desktop

#### Windows
```bash
flutter build windows --release
```

Output: `build/windows/runner/Release/`

#### macOS
```bash
flutter build macos --release
```

#### Linux
```bash
flutter build linux --release
```

## 🚀 Deployment

### Android (Google Play Store)
1. Create a keystore for signing
2. Configure `android/app/build.gradle`
3. Build app bundle: `flutter build appbundle --release`
4. Upload to Google Play Console

### iOS (App Store)
1. Configure signing in Xcode
2. Build: `flutter build ios --release`
3. Archive in Xcode
4. Upload to App Store Connect

### Web Hosting
1. Build: `flutter build web --release`
2. Deploy `build/web/` to hosting service:
   - Firebase Hosting
   - Netlify
   - Vercel
   - GitHub Pages

```bash
# Example: Firebase Hosting
firebase init hosting
firebase deploy
```

## 🧪 Testing

### Run Unit Tests
```bash
flutter test
```

### Run Widget Tests
```bash
flutter test test/widget_test.dart
```

### Run Integration Tests
```bash
flutter test integration_test
```

### Code Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 🛠 Development Tools

### Code Generation
```bash
# Generate code (if using build_runner)
flutter pub run build_runner build --delete-conflicting-outputs
```

### Code Formatting
```bash
# Format all Dart files
dart format .

# Check formatting
dart format --set-exit-if-changed .
```

### Code Analysis
```bash
# Run analyzer
flutter analyze

# Fix auto-fixable issues
dart fix --apply
```

## 🐛 Troubleshooting

### Common Issues

#### Build Failures
```bash
# Clean build cache
flutter clean
flutter pub get
flutter run
```

#### Dependency Issues
```bash
# Update dependencies
flutter pub upgrade

# Get specific version
flutter pub get
```

#### Platform-Specific Issues

**Android:**
- Check `minSdkVersion` in `android/app/build.gradle` (minimum 21)
- Ensure Android SDK is updated

**iOS:**
- Run `pod install` in `ios/` directory
- Check iOS deployment target (minimum 12.0)

**Web:**
- Use `--web-renderer html` or `--web-renderer canvaskit`
```bash
flutter run -d chrome --web-renderer html
```

## 📝 Best Practices

### Code Organization
- Follow Flutter/Dart style guide
- Use meaningful variable and function names
- Keep widgets small and focused
- Separate business logic from UI

### Performance
- Use `const` constructors where possible
- Implement lazy loading for lists
- Optimize image loading and caching
- Profile app performance regularly

### Security
- Never commit API keys or sensitive data
- Validate all user inputs
- Use HTTPS for all API calls
- Implement proper error handling

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 👨‍💻 Author

**Yasiru Pandigama**

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Provider package for state management
- FL Chart for beautiful charts
- All open-source contributors

## 📞 Support

For support, please:
- Create an issue in the repository
- Contact: medisync.app.team@gmail.com

---

**Built with ❤️ using Flutter** 




