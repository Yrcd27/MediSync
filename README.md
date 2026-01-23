# MediSync - Smart Personal Health Record Tracker

<div align="center">

![MediSync Logo](https://img.shields.io/badge/MediSync-Health%20Tracker-blue?style=for-the-badge&logo=heart&logoColor=white)

**A comprehensive, modern, and intelligent personal health record management system**

[![Flutter](https://img.shields.io/badge/Flutter-3.9.0+-02569B?style=flat&logo=flutter&logoColor=white)](https://flutter.dev)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.5.8-6DB33F?style=flat&logo=spring-boot&logoColor=white)](https://spring.io/projects/spring-boot)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Database-336791?style=flat&logo=postgresql&logoColor=white)](https://www.postgresql.org)
[![Java](https://img.shields.io/badge/Java-17-ED8B00?style=flat&logo=openjdk&logoColor=white)](https://www.oracle.com/java/)

[Features](#-features) • [Architecture](#-architecture) • [Getting Started](#-getting-started) • [Documentation](#-documentation) • [Screenshots](#-screenshots) • [Contributing](#-contributing)

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Key Features](#-key-features)
- [Technology Stack](#-technology-stack)
- [Architecture](#-architecture)
- [Project Structure](#-project-structure)
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [Backend Setup](#-backend-setup)
- [Frontend Setup](#-frontend-setup)
- [API Documentation](#-api-documentation)
- [Deployment](#-deployment)
- [Screenshots](#-screenshots)
- [Contributing](#-contributing)
- [Support](#-support)

## 🌟 Overview

**MediSync** is a full-stack health record management system that enables users to track, analyze, and maintain their personal medical records digitally. Built with modern technologies, it provides a seamless experience across multiple platforms (Android, iOS, Web, Desktop) with a powerful backend API.

### Why MediSync?

- 📱 **Cross-Platform**: Single codebase runs on Android, iOS, Web, Windows, macOS, and Linux
- 🔒 **Secure**: Industry-standard security practices with encrypted passwords and secure API communication
- 📊 **Insightful**: Beautiful charts and analytics to track health trends over time
- 🎨 **Modern UI**: Clean, intuitive interface with dark mode support
- 🚀 **Scalable**: Robust backend architecture with connection pooling and optimized database queries
- 💾 **Comprehensive**: Track multiple health metrics in one place
- 🔔 **Smart Reminders**: Automated email notifications for health checkups

## ✨ Key Features

### 🏥 Health Record Management

Track comprehensive health metrics:

| Category | Metrics | Features |
|----------|---------|----------|
| **Cardiovascular** | Blood Pressure | Systolic/Diastolic readings, trend analysis |
| **Metabolic** | Fasting Blood Sugar | Glucose level monitoring, diabetic tracking |
| **Hematology** | Full Blood Count | Haemoglobin, WBC, Platelet counts |
| **Lipid Profile** | Cholesterol Analysis | Total, HDL, LDL, VLDL, Triglycerides |
| **Liver Function** | Liver Profile | Protein, Albumin, Bilirubin, SGPT levels |
| **Renal** | Urine Report | Complete urinalysis tracking |

### 📈 Analytics & Insights

- **Interactive Charts**: Beautiful line charts and bar graphs using FL Chart
- **Trend Analysis**: Track health metrics over time with visual indicators
- **Health Status**: Color-coded indicators (Normal, At Risk, Abnormal)
- **Historical Comparison**: Compare current vs. historical data

### 👤 User Management

- **Secure Authentication**: Login/registration with SHA-256 password hashing
- **Profile Management**: Complete user profile with health information
- **Session Persistence**: Auto-login with secure session management
- **Multiple Users**: Support for multiple user accounts

### 🎨 Modern User Experience

- **Material Design 3**: Latest design guidelines with custom theming
- **Dark Mode**: Full dark theme support
- **Smooth Animations**: Micro-interactions and transitions
- **Responsive Design**: Adapts to all screen sizes
- **Google Fonts**: Beautiful typography
- **Shimmer Effects**: Elegant loading states

### 🔔 Notifications & Reminders

- **Email Notifications**: Automated health test reminders
- **Async Processing**: Non-blocking email delivery
- **Custom Templates**: Configurable notification content

## 🛠 Technology Stack

### Frontend (Mobile & Web)

```yaml
Framework:          Flutter 3.9.0+ / Dart 3.9.0+
State Management:   Provider Pattern
HTTP Client:        http 1.1.0
Charts:             FL Chart 0.64.0
Animations:         Flutter Animate 4.3.0
Typography:         Google Fonts 6.1.0
Local Storage:      SharedPreferences 2.2.2
```

**Platforms Supported:**
- Android (API 21+)
- iOS (12.0+)
- Web (Chrome, Firefox, Safari, Edge)
- Windows Desktop
- macOS Desktop
- Linux Desktop

### Backend (API Server)

```yaml
Framework:          Spring Boot 3.5.8
Language:           Java 17
Database:           PostgreSQL
ORM:                Spring Data JPA (Hibernate)
Build Tool:         Maven
Connection Pool:    HikariCP
Security:           SHA-256 Password Hashing
Email Service:      Resend API
```

**Key Libraries:**
- Spring Boot Starter Web
- Spring Boot Starter Data JPA
- Spring Boot Starter Mail
- PostgreSQL Driver
- Lombok
- Apache Commons Codec

## 🏗 Architecture

### System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        Client Layer                          │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │ Android  │  │   iOS    │  │   Web    │  │ Desktop  │   │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘   │
│       │             │              │             │          │
│       └─────────────┴──────────────┴─────────────┘          │
│                           │                                  │
│                    Flutter Frontend                          │
│                  (Provider + Services)                       │
└───────────────────────────┬─────────────────────────────────┘
                            │
                            │ HTTPS/REST API
                            │
┌───────────────────────────┴─────────────────────────────────┐
│                    Backend Layer                             │
│  ┌──────────────────────────────────────────────────────┐   │
│  │              Spring Boot REST API                     │   │
│  │  ┌────────────┐  ┌─────────────┐  ┌──────────────┐  │   │
│  │  │Controllers │→ │  Services   │→ │ Repositories │  │   │
│  │  └────────────┘  └─────────────┘  └──────────────┘  │   │
│  └──────────────────────────────────────────────────────┘   │
│                           │                                  │
│  ┌────────────────────────┴──────────────────────────────┐  │
│  │              Connection Pool (HikariCP)                │  │
│  └────────────────────────┬──────────────────────────────┘  │
└───────────────────────────┼─────────────────────────────────┘
                            │
                            │ JDBC
                            │
┌───────────────────────────┴─────────────────────────────────┐
│                    Data Layer                                │
│  ┌──────────────────────────────────────────────────────┐   │
│  │                PostgreSQL Database                    │   │
│  │  ┌────────┐ ┌────────┐ ┌────────┐ ┌─────────────┐   │   │
│  │  │ Users  │ │  FBS   │ │  FBC   │ │   Reports   │   │   │
│  │  └────────┘ └────────┘ └────────┘ └─────────────┘   │   │
│  │  ┌────────┐ ┌────────┐ ┌────────┐ ┌─────────────┐   │   │
│  │  │  B.P.  │ │ Lipid  │ │ Liver  │ │    Urine    │   │   │
│  │  └────────┘ └────────┘ └────────┘ └─────────────┘   │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

### Backend Architecture Pattern

**Layered Architecture (MVC Pattern)**
```
┌──────────────────────────────────────┐
│         Controller Layer              │  ← REST Endpoints
│  (Request/Response handling)          │
└──────────────┬───────────────────────┘
               │
┌──────────────┴───────────────────────┐
│         Service Layer                 │  ← Business Logic
│  (Data processing & validation)       │
└──────────────┬───────────────────────┘
               │
┌──────────────┴───────────────────────┐
│       Repository Layer                │  ← Data Access
│  (JPA/Hibernate operations)           │
└──────────────┬───────────────────────┘
               │
┌──────────────┴───────────────────────┐
│         Entity Layer                  │  ← Data Models
│  (Database tables mapping)            │
└──────────────────────────────────────┘
```

### Frontend Architecture

**Provider Pattern with Clean Architecture**
```
┌──────────────────────────────────────┐
│         Presentation Layer            │
│  ┌──────────────────────────────┐    │
│  │  Screens & Widgets           │    │
│  │  (UI Components)             │    │
│  └─────────┬────────────────────┘    │
└────────────┼─────────────────────────┘
             │
┌────────────┼─────────────────────────┐
│  State Management (Provider)         │
│  ┌─────────┴────────────────────┐    │
│  │  AuthProvider                │    │
│  │  HealthRecordsProvider       │    │
│  │  ThemeProvider               │    │
│  └─────────┬────────────────────┘    │
└────────────┼─────────────────────────┘
             │
┌────────────┼─────────────────────────┐
│         Service Layer                 │
│  ┌──────────────────────────────┐    │
│  │  API Services                │    │
│  │  (HTTP Communication)        │    │
│  └─────────┬────────────────────┘    │
└────────────┼─────────────────────────┘
             │
┌────────────┴─────────────────────────┐
│         Data Layer                    │
│  ┌──────────────────────────────┐    │
│  │  Models                      │    │
│  │  Local Storage               │    │
│  └──────────────────────────────┘    │
└──────────────────────────────────────┘
```

## 📂 Project Structure

```
MediSync__Smart-Personal-Health-Record-Tracker/
│
├── backend/                          # Spring Boot Backend API
│   ├── src/
│   │   ├── main/
│   │   │   ├── java/com/lakshan/medi_sync/
│   │   │   │   ├── controller/      # REST Controllers (8)
│   │   │   │   ├── entity/          # JPA Entities (8 tables)
│   │   │   │   ├── repository/      # Data repositories
│   │   │   │   ├── service/         # Business logic
│   │   │   │   └── MediSyncApplication.java
│   │   │   └── resources/
│   │   │       └── application.properties
│   │   └── test/
│   ├── pom.xml                      # Maven dependencies
│   ├── mvnw, mvnw.cmd              # Maven wrapper
│   └── README.md                    # Backend documentation
│
├── frontend/                         # Flutter Frontend App
│   ├── lib/
│   │   ├── core/                    # Core functionality
│   │   │   ├── config/              # App configuration
│   │   │   ├── constants/           # Constants & colors
│   │   │   ├── services/            # Base services
│   │   │   ├── theme/               # Theme configuration
│   │   │   └── utils/               # Utilities
│   │   ├── models/                  # Data models (8)
│   │   ├── providers/               # State management (3)
│   │   ├── screens/                 # UI screens (20+)
│   │   │   ├── auth/                # Authentication
│   │   │   ├── main/                # Main navigation
│   │   │   └── records/             # Health records
│   │   ├── services/                # API services (9)
│   │   ├── widgets/                 # Reusable widgets
│   │   └── main.dart               # App entry point
│   ├── assets/                      # Images & resources
│   ├── android/                     # Android configuration
│   ├── ios/                         # iOS configuration
│   ├── web/                         # Web configuration
│   ├── pubspec.yaml                # Flutter dependencies
│   └── README.md                    # Frontend documentation
│
└── README.md                        # This file
```

## 📋 Prerequisites

### System Requirements

- **Operating System**: Windows 10+, macOS 10.14+, or Linux
- **RAM**: Minimum 4GB (8GB recommended)
- **Storage**: 10GB free space

### Backend Requirements

- **Java**: JDK 17 or higher
- **Maven**: 3.6+ (or use included wrapper)
- **PostgreSQL**: 12+ database server
- **IDE**: IntelliJ IDEA, Eclipse, or VS Code

### Frontend Requirements

- **Flutter SDK**: 3.9.0 or higher
- **Dart**: 3.9.0+ (included with Flutter)
- **Android Studio**: For Android development
- **Xcode**: For iOS development (macOS only)
- **Chrome**: For web development

### Development Tools

```bash
# Verify installations
java --version          # Should be 17+
mvn --version          # Maven 3.6+
flutter --version      # Flutter 3.9.0+
dart --version         # Dart 3.9.0+
psql --version         # PostgreSQL 12+
```

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/MediSync__Smart-Personal-Health-Record-Tracker.git
cd MediSync__Smart-Personal-Health-Record-Tracker
```

### 2. Set Up the Database

```sql
-- Create PostgreSQL database
CREATE DATABASE medisync;

-- Connect to the database
\c medisync

-- Run your schema SQL scripts (if provided)
-- Or let Spring Boot JPA create tables automatically
```

### 3. Configure Environment Variables

**Windows (PowerShell):**
```powershell
$env:Database_Host = "jdbc:postgresql://localhost:5432/medisync"
$env:Database_Username = "postgres"
$env:Database_Password = "your_password"
$env:RESEND_API_KEY = "your_resend_api_key"
```

**Linux/Mac:**
```bash
export Database_Host="jdbc:postgresql://localhost:5432/medisync"
export Database_Username="postgres"
export Database_Password="your_password"
export RESEND_API_KEY="your_resend_api_key"
```

### 4. Start the Backend

```bash
cd backend

# Using Maven wrapper (recommended)
./mvnw spring-boot:run

# Or using Maven
mvn spring-boot:run
```

Backend will start at: `http://localhost:8080`

### 5. Configure Frontend

Edit `frontend/lib/core/config/app_config.dart`:

```dart
static String get baseUrl {
  return 'http://localhost:8080';  // Your backend URL
}
```

### 6. Start the Frontend

```bash
cd frontend

# Install dependencies
flutter pub get

# Run on your preferred platform
flutter run                  # Auto-detect device
flutter run -d chrome       # Web
flutter run -d windows      # Windows desktop
flutter run -d android      # Android emulator
```

### 7. Access the Application

- **Backend API**: http://localhost:8080
- **Frontend App**: Opens automatically or http://localhost:port

## 🔧 Backend Setup

### Detailed Backend Configuration

1. **Navigate to backend directory:**
   ```bash
   cd backend
   ```

2. **Configure database connection** in `src/main/resources/application.properties`:
   ```properties
   spring.datasource.url=${Database_Host}
   spring.datasource.username=${Database_Username}
   spring.datasource.password=${Database_Password}
   ```

3. **Build the project:**
   ```bash
   ./mvnw clean install
   ```

4. **Run the application:**
   ```bash
   ./mvnw spring-boot:run
   ```

5. **Verify it's running:**
   ```bash
   curl http://localhost:8080/users/getAllUsers
   ```

### Backend API Endpoints

Base URL: `http://localhost:8080`

#### Authentication
- `POST /users/addUser` - Register new user
- `POST /users/login` - User login

#### User Management
- `GET /users/getAllUsers` - Get all users
- `GET /users/getUser/{id}` - Get user by ID
- `PUT /users/updateUser` - Update user
- `DELETE /users/deleteUser/{id}` - Delete user

#### Health Records
All health record endpoints follow similar patterns:
- `POST /{endpoint}/add{Type}Record` - Add new record
- `GET /{endpoint}/getAll{Type}Records` - Get all records
- `GET /{endpoint}/get{Type}Record/{id}` - Get by ID
- `GET /{endpoint}/get{Type}RecordsByUserId/{userId}` - Get by user
- `PUT /{endpoint}/update{Type}Record` - Update record
- `DELETE /{endpoint}/delete{Type}Record/{id}` - Delete record

**Endpoints:**
- `/blood_pressure` - Blood pressure records
- `/fbs` - Fasting blood sugar records
- `/fbc` - Full blood count records
- `/lipid_profile` - Lipid profile records
- `/liver_profile` - Liver profile records
- `/urine_report` - Urine report records
- `/reports` - Consolidated reports

For complete API documentation, see [backend/README.md](backend/README.md)

## 📱 Frontend Setup

### Detailed Frontend Configuration

1. **Navigate to frontend directory:**
   ```bash
   cd frontend
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Check Flutter setup:**
   ```bash
   flutter doctor
   ```

4. **Configure backend URL** in `lib/core/config/app_config.dart`:
   ```dart
   class AppConfig {
     static String get baseUrl {
       // For local development
       return 'http://localhost:8080';
       
       // For physical device (use your computer's IP)
       // return 'http://192.168.1.100:8080';
       
       // For production
       // return 'https://your-backend-url.com';
     }
   }
   ```

5. **Run the app:**
   ```bash
   # List available devices
   flutter devices
   
   # Run on specific device
   flutter run -d <device-id>
   
   # Or let Flutter choose
   flutter run
   ```

### Building for Production

#### Android (APK/App Bundle)
```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
```

#### Web
```bash
flutter build web --release
```

#### Desktop
```bash
# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

For complete frontend documentation, see [frontend/README.md](frontend/README.md)

## 📚 API Documentation

### Sample API Requests

#### Register New User
```bash
curl -X POST http://localhost:8080/users/addUser \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "password": "securepassword123",
    "dateOfBirth": "1990-01-01",
    "gender": "Male",
    "height": 175.5,
    "weight": 70.0,
    "bloodGroup": "O+"
  }'
```

#### Login
```bash
curl -X POST http://localhost:8080/users/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "securepassword123"
  }'
```

#### Add Blood Pressure Record
```bash
curl -X POST http://localhost:8080/blood_pressure/addBloodPressureRecord \
  -H "Content-Type: application/json" \
  -d '{
    "testDate": "2024-01-15",
    "bpLevel": "120/80",
    "imageUrl": "https://example.com/image.jpg",
    "user": { "id": 1 }
  }'
```

#### Get User's Health Records
```bash
curl http://localhost:8080/blood_pressure/getBloodPressureRecordsByUserId/1
```

For complete API documentation with all endpoints, request/response examples, and error codes, refer to [backend/README.md](backend/README.md)

## 🚀 Deployment

### Backend Deployment

#### Railway / Heroku / Render
```bash
# Deploy using Git
git push railway main    # Railway
git push heroku main     # Heroku
```

#### Docker Deployment
```dockerfile
# Create Dockerfile in backend/
FROM openjdk:17-jdk-slim
COPY target/*.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
```

```bash
# Build and run
docker build -t medisync-backend .
docker run -p 8080:8080 medisync-backend
```

### Frontend Deployment

#### Web (Firebase Hosting / Netlify / Vercel)
```bash
# Build for web
flutter build web --release

# Deploy to Firebase
firebase init hosting
firebase deploy

# Or deploy to Netlify
netlify deploy --prod --dir=build/web
```

#### Mobile (App Stores)
```bash
# Android - Google Play Store
flutter build appbundle --release

# iOS - Apple App Store
flutter build ios --release
# Then archive and upload via Xcode
```

#### Desktop
```bash
# Package for distribution
flutter build windows --release
flutter build macos --release
flutter build linux --release
```

## 📸 Screenshots

<details>
<summary>Click to view screenshots</summary>

### Authentication
- Login Screen
- Registration Screen

### Dashboard
- Health Overview
- Recent Records
- Quick Actions

### Health Records
- Blood Pressure Tracking
- Blood Sugar Monitoring
- Blood Count Analysis
- Lipid Profile
- Liver Function
- Urine Analysis

### Analytics
- Interactive Charts
- Trend Analysis
- Health Insights

### Profile
- User Information
- Settings
- Theme Toggle

</details>

## 🧪 Testing

### Backend Tests
```bash
cd backend
./mvnw test
```

### Frontend Tests
```bash
cd frontend

# Unit tests
flutter test

# Integration tests
flutter test integration_test

# Coverage
flutter test --coverage
```

## 🐛 Troubleshooting

### Common Issues

#### Backend Won't Start
- Check if PostgreSQL is running: `pg_isready`
- Verify environment variables are set
- Check port 8080 is not in use: `netstat -an | findstr 8080`
- Review logs for specific errors

#### Frontend Build Errors
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

#### Database Connection Issues
- Verify PostgreSQL service is running
- Check database credentials
- Ensure database exists: `psql -l`
- Check firewall settings

#### API Connection Issues (Frontend)
- Verify backend is running
- Check `app_config.dart` has correct URL
- For physical devices, use computer's IP address
- Check network connectivity

## 📖 Documentation

- **Backend Documentation**: [backend/README.md](backend/README.md)
- **Frontend Documentation**: [frontend/README.md](frontend/README.md)
- **API Reference**: See backend README
- **Flutter Documentation**: [flutter.dev](https://flutter.dev/docs)
- **Spring Boot Documentation**: [spring.io](https://spring.io/projects/spring-boot)

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork the repository**
   ```bash
   git clone https://github.com/yourusername/MediSync.git
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/AmazingFeature
   ```

3. **Make your changes**
   - Follow existing code style
   - Add tests if applicable
   - Update documentation

4. **Commit your changes**
   ```bash
   git commit -m 'Add some AmazingFeature'
   ```

5. **Push to the branch**
   ```bash
   git push origin feature/AmazingFeature
   ```

6. **Open a Pull Request**

### Code Style Guidelines

**Backend (Java):**
- Follow Java naming conventions
- Use Lombok for boilerplate reduction
- Write meaningful comments
- Keep methods focused and small

**Frontend (Dart):**
- Follow Dart style guide
- Use meaningful widget names
- Keep widgets small and reusable
- Document complex logic

## 🙏 Acknowledgments

- **Flutter Team** - Amazing cross-platform framework
- **Spring Team** - Robust backend framework
- **PostgreSQL** - Reliable database system
- **FL Chart** - Beautiful chart library
- **Provider Package** - State management solution
- **Resend** - Email service provider
- **Open Source Community** - For amazing tools and libraries

## 👨‍💻 Authors

**Lakshan Imantha** - *Backend Developer*
- 🔧 Spring Boot API Development
- 🗄️ Database Architecture & Design
- 🔐 Authentication & Security

**Yasiru Pandigama** - *Frontend Developer*
- 📱 Flutter Mobile & Web Development
- 🎨 UI/UX Design & Implementation
- 📊 Data Visualization & Charts

## 📞 Support

### Get Help

- 📧 Email: medisync.app.team@gmail.com
- 💬 GitHub Issues: [Create an issue](https://github.com/yourusername/MediSync/issues)
- 📚 Documentation: See README files in backend/ and frontend/

## 🔮 Future Enhancements

- [ ] AI-powered health predictions
- [ ] Integration with wearable devices
- [ ] Doctor appointment scheduling
- [ ] Medication reminders
- [ ] Family health tracking
- [ ] Export to PDF reports
- [ ] Multi-language support
- [ ] Voice commands
- [ ] Biometric authentication
- [ ] Cloud sync across devices
- [ ] Telemedicine integration
- [ ] Insurance claim management

## 📊 Project Status

- Core Features: Complete
- Authentication: Implemented
- Health Records: All 6 types implemented
- Analytics: Charts and insights working
- Cross-Platform: Android, iOS, Web, Desktop
- Additional Features: In Progress

## ⭐ Show Your Support

If you find this project helpful, please give it a ⭐ on GitHub!

---

<div align="center">

**Built with ❤️ using Flutter & Spring Boot**

[⬆ Back to Top](#medisync---smart-personal-health-record-tracker)

</div> 




