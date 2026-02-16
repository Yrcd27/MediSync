<div align="center">

# MediSync

**Personal Health Record Management System**

A full-stack mobile application for tracking, analyzing, and managing personal medical records. Built with Flutter and Spring Boot as a 5th semester Mobile Application Development project.

[![Flutter](https://img.shields.io/badge/Flutter-3.9+-02569B?style=flat&logo=flutter&logoColor=white)](https://flutter.dev)
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.5.8-6DB33F?style=flat&logo=spring-boot&logoColor=white)](https://spring.io/projects/spring-boot)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=flat&logo=postgresql&logoColor=white)](https://www.postgresql.org)
[![Java](https://img.shields.io/badge/Java-17-ED8B00?style=flat&logo=openjdk&logoColor=white)](https://www.oracle.com/java/)

</div>

---

## Overview

MediSync lets users digitally store their lab test results, view health trends over time through interactive charts, and receive color-coded health status indicators with recommendations. The backend REST API is deployed on Railway and the Flutter frontend targets Android as the primary platform.

## Features

### Health Record Tracking

Users can add, view, edit, and delete records for **6 types** of medical tests:

| Test Type | Tracked Metrics |
|-----------|----------------|
| Blood Pressure | Systolic / Diastolic readings |
| Fasting Blood Sugar | Glucose level (mg/dL) |
| Full Blood Count | Haemoglobin, WBC, Platelet count |
| Lipid Profile | Total Cholesterol, HDL, LDL, VLDL, Triglycerides |
| Liver Profile | Total Protein, Albumin, Bilirubin, SGPT |
| Urine Report | Color, Appearance, Protein, Sugar, Specific Gravity |

Each record stores the test date and an optional image URL for the lab report.

### Analytics & Health Insights

- **Trend Charts** -- Interactive line charts (FL Chart) for each test type with time-range filtering (Week / Month / 3 Months / Year / All)
- **Health Status Engine** -- Every metric is evaluated against clinical reference ranges and color-coded:

  | Color | Meaning |
  |-------|---------|
  | Green | Normal |
  | Blue | Low |
  | Orange | Elevated / Borderline |
  | Red | Abnormal / Requires attention |

- **Recommendations** -- Each evaluation includes a short health recommendation (e.g., *"Prediabetic range. Consider dietary changes and exercise."*)

### Authentication & User Profile

- Multi-step registration (3 screens) collecting name, email, password, DOB, gender, blood group, height, and weight
- Login with SHA-256 password hashing
- Session persistence via SharedPreferences (auto-login on app restart)
- Profile editing with real-time updates

### Email Reminders

When a Fasting Blood Sugar record is created, the backend asynchronously sends an email via the Resend API reminding the user to schedule their next test in 6 months.

### UI / UX

- Material Design 3 theming with dark mode support
- Shimmer loading skeletons, smooth animations (flutter_animate)
- Google Fonts typography
- Reusable widget library (cards, buttons, inputs, feedback components)

---

## Architecture

```
┌─────────────────────────────────────────────────────┐
│                  Flutter Mobile App                  │
│                                                     │
│  Screens ──► Providers ──► Services ──► HTTP Client │
│  (UI)        (State)       (API calls)              │
└──────────────────────┬──────────────────────────────┘
                       │ REST / JSON
                       ▼
┌──────────────────────┴──────────────────────────────┐
│               Spring Boot REST API                   │
│                                                     │
│  Controllers ──► Services ──► Repositories ──► JPA  │
│  (Endpoints)     (Logic)      (Data access)         │
└──────────────────────┬──────────────────────────────┘
                       │ JDBC (HikariCP)
                       ▼
┌─────────────────────────────────────────────────────┐
│                    PostgreSQL                        │
│                                                     │
│  users │ blood_pressure │ fasting_blood_sugar       │
│  full_blood_count │ lipid_profile │ liver_profile   │
│  urine_report │ reports                             │
└─────────────────────────────────────────────────────┘
```

**Frontend state management:** Provider pattern with 3 providers -- `AuthProvider`, `HealthRecordsProvider`, `ThemeProvider`.

**Backend pattern:** Layered MVC -- each of the 8 entity types has its own Controller, Service, and Repository class.

---

## Tech Stack

| Layer | Technology | Key Libraries |
|-------|-----------|---------------|
| **Frontend** | Flutter 3.9+ / Dart 3.9+ | provider, fl_chart, flutter_animate, shimmer, google_fonts, shared_preferences, http, intl |
| **Backend** | Spring Boot 3.5.8 / Java 17 | Spring Data JPA, Spring Web, Spring Mail, Lombok, Commons Codec, PostgreSQL Driver |
| **Database** | PostgreSQL | HikariCP connection pooling |
| **Email** | Resend API | Async delivery via `@Async` |
| **Deployment** | Railway | Backend hosted at `medisync-backend-production.up.railway.app` |

---

## Project Structure

```
MediSync/
├── backend/
│   └── src/main/java/com/lakshan/medi_sync/
│       ├── controller/       # 8 REST controllers
│       ├── service/          # 9 services (incl. EmailService)
│       ├── repository/       # 8 JPA repositories
│       └── entity/           # 8 entity classes
│
├── frontend/lib/
│   ├── core/                 # Config, theme, constants, utilities
│   ├── models/               # 8 data models (mirror backend entities)
│   ├── providers/            # AuthProvider, HealthRecordsProvider, ThemeProvider
│   ├── services/             # 9 API service classes
│   ├── screens/
│   │   ├── auth/             # Login, 3-step signup
│   │   ├── main/             # Dashboard, Analytics, Records Hub, Profile
│   │   └── records/          # Add & View screens for each test type
│   ├── widgets/              # Reusable UI components
│   └── utils/                # Health analysis engine
│
└── README.md
```

---

## Getting Started

### Prerequisites

- Java 17+
- Maven 3.6+ (or use the included `mvnw` wrapper)
- PostgreSQL 12+
- Flutter SDK 3.9+

### 1. Database

```sql
CREATE DATABASE medisync;
```

### 2. Backend

```bash
cd backend

# Set environment variables
export Database_Host="jdbc:postgresql://localhost:5432/medisync"
export Database_Username="postgres"
export Database_Password="your_password"
export RESEND_API_KEY="your_resend_api_key"    # optional, for email reminders

# Run
./mvnw spring-boot:run
```

The API starts at `http://localhost:8080`. JPA with `ddl-auto=none` means you manage the schema yourself (or switch to `update` for auto-creation during development).

### 3. Frontend

```bash
cd frontend

# Point to your backend
# Edit lib/core/config/app_config.dart → change baseUrl to http://localhost:8080

flutter pub get
flutter run           # auto-detect connected device
```

> For a physical Android device, use your machine's local IP (e.g., `http://192.168.1.100:8080`).

---

## API Endpoints

All endpoints follow a consistent CRUD pattern per entity:

| Method | Pattern | Description |
|--------|---------|-------------|
| `POST` | `/{entity}/add{Type}Record` | Create a record |
| `GET` | `/{entity}/getAll{Type}Records` | List all records |
| `GET` | `/{entity}/get{Type}Record/{id}` | Get by ID |
| `GET` | `/{entity}/get{Type}RecordsByUserId/{userId}` | Get by user |
| `PUT` | `/{entity}/update{Type}Record` | Update a record |
| `DELETE` | `/{entity}/delete{Type}Record/{id}` | Delete a record |

**Entity prefixes:** `/blood_pressure`, `/fbs`, `/fbc`, `/lipid_profile`, `/liver_profile`, `/urine_report`, `/reports`

**User endpoints:** `/users/addUser`, `/users/login`, `/users/getUser/{id}`, `/users/updateUser`, `/users/deleteUser/{id}`

---

## Authors

| Name | Role |
|------|------|
| **Yasiru Pandigama** | Frontend -- Flutter UI/UX, data visualization, state management |
| **Lakshan Imantha** | Backend -- Spring Boot API, database design, authentication |

