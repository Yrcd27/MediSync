# MediSync Backend API

A comprehensive RESTful API for managing personal health records, built with Spring Boot 3.5.8 and Java 17.

## 📋 Table of Contents

- [Overview](#overview)
- [Technology Stack](#technology-stack)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Database Schema](#database-schema)
- [API Endpoints](#api-endpoints)
- [Configuration](#configuration)
- [Getting Started](#getting-started)
- [Building & Running](#building--running)
- [Features](#features)
- [Email Service](#email-service)
- [Security](#security)

## 🌟 Overview

MediSync Backend is a Spring Boot application that provides a comprehensive API for managing personal health records. It enables users to track various health metrics including blood pressure, blood sugar levels, lipid profiles, liver function tests, full blood count, and urine reports. The system also generates consolidated medical reports and provides email notifications for health reminders.

## 🛠 Technology Stack

- **Framework**: Spring Boot 3.5.8
- **Language**: Java 17
- **Database**: PostgreSQL
- **ORM**: Spring Data JPA (Hibernate)
- **Build Tool**: Maven
- **Libraries**:
  - Lombok - Reduces boilerplate code
  - Commons Codec - Password hashing (SHA-256)
  - Spring Mail - Email notifications
  - Spring Dev Tools - Development utilities
  - HikariCP - Connection pooling

## 📦 Prerequisites

- Java 17 or higher
- Maven 3.6+
- PostgreSQL database
- Resend API key (for email functionality)

## 📁 Project Structure

```
backend/
├── src/
│   ├── main/
│   │   ├── java/com/lakshan/medi_sync/
│   │   │   ├── controller/          # REST Controllers
│   │   │   │   ├── UserController.java
│   │   │   │   ├── BloodPressureController.java
│   │   │   │   ├── FastingBloodSugarController.java
│   │   │   │   ├── FullBloodCountController.java
│   │   │   │   ├── LipidProfileController.java
│   │   │   │   ├── LiverProfileController.java
│   │   │   │   ├── UrineReportController.java
│   │   │   │   └── ReportController.java
│   │   │   ├── entity/              # JPA Entities
│   │   │   │   ├── User.java
│   │   │   │   ├── BloodPressure.java
│   │   │   │   ├── FastingBloodSugar.java
│   │   │   │   ├── FullBloodCount.java
│   │   │   │   ├── LipidProfile.java
│   │   │   │   ├── LiverProfile.java
│   │   │   │   ├── UrineReport.java
│   │   │   │   └── Report.java
│   │   │   ├── repository/          # Data Access Layer
│   │   │   │   └── [Repository interfaces]
│   │   │   ├── service/             # Business Logic
│   │   │   │   ├── EmailService.java
│   │   │   │   └── [Service classes]
│   │   │   └── MediSyncApplication.java
│   │   └── resources/
│   │       └── application.properties
│   └── test/
│       └── java/
├── pom.xml
└── README.md
```

## 🗃 Database Schema

### Users Table (`users`)
| Column | Type | Description |
|--------|------|-------------|
| id | INT (PK) | User ID |
| name | VARCHAR | User's full name |
| email | VARCHAR | User's email (login) |
| pwd | VARCHAR | Hashed password (SHA-256) |
| dob | DATE | Date of birth |
| gender | VARCHAR | Gender |
| height | DOUBLE | Height in cm |
| weight | DOUBLE | Weight in kg |
| blood_group | VARCHAR | Blood group |

### Blood Pressure Table (`blood_pressure`)
| Column | Type | Description |
|--------|------|-------------|
| id | INT (PK) | Record ID |
| test_date | DATE | Test date |
| bp_level | VARCHAR | Blood pressure reading |
| image_url | VARCHAR | Report image URL |
| user_id | INT (FK) | Reference to user |

### Fasting Blood Sugar Table (`fbs`)
| Column | Type | Description |
|--------|------|-------------|
| id | INT (PK) | Record ID |
| test_date | DATE | Test date |
| fbs_level | DOUBLE | Blood sugar level |
| image_url | VARCHAR | Report image URL |
| user_id | INT (FK) | Reference to user |

### Full Blood Count Table (`fbc`)
| Column | Type | Description |
|--------|------|-------------|
| id | INT (PK) | Record ID |
| test_date | DATE | Test date |
| haemoglobin | DOUBLE | Haemoglobin level |
| total_leucocyte_count | DOUBLE | White blood cell count |
| platelet_count | DOUBLE | Platelet count |
| image_url | VARCHAR | Report image URL |
| user_id | INT (FK) | Reference to user |

### Lipid Profile Table (`lipid_profile`)
| Column | Type | Description |
|--------|------|-------------|
| id | INT (PK) | Record ID |
| test_date | DATE | Test date |
| total_cholesterol | DOUBLE | Total cholesterol |
| hdl | DOUBLE | HDL cholesterol |
| ldl | DOUBLE | LDL cholesterol |
| vldl | DOUBLE | VLDL cholesterol |
| triglycerides | DOUBLE | Triglycerides level |
| image_url | VARCHAR | Report image URL |
| user_id | INT (FK) | Reference to user |

### Liver Profile Table (`liver_profile`)
| Column | Type | Description |
|--------|------|-------------|
| id | INT (PK) | Record ID |
| test_date | DATE | Test date |
| protein_total_serum | DOUBLE | Total protein |
| albumin_serum | DOUBLE | Albumin level |
| bilirubin_total_serum | DOUBLE | Bilirubin level |
| sgpt | DOUBLE | SGPT/ALT level |
| image_url | VARCHAR | Report image URL |
| user_id | INT (FK) | Reference to user |

### Urine Report Table (`urine_report`)
| Column | Type | Description |
|--------|------|-------------|
| id | INT (PK) | Record ID |
| test_date | DATE | Test date |
| color | VARCHAR | Urine color |
| appearance | VARCHAR | Urine appearance |
| protein | VARCHAR | Protein presence |
| sugar | VARCHAR | Sugar presence |
| specific_gravity | DOUBLE | Specific gravity |
| image_url | VARCHAR | Report image URL |
| user_id | INT (FK) | Reference to user |

### Reports Table (`reports`)
| Column | Type | Description |
|--------|------|-------------|
| id | INT (PK) | Report ID |
| report_date | DATE | Report generation date |
| user_id | INT (FK) | Reference to user |
| fbc_id | INT (FK) | Full blood count record |
| liver_id | INT (FK) | Liver profile record |
| urine_id | INT (FK) | Urine report record |
| fbs_id | INT (FK) | Blood sugar record |
| lipid_id | INT (FK) | Lipid profile record |
| bp_id | INT (FK) | Blood pressure record |

## 🔌 API Endpoints

### User Management

#### Register User
```http
POST /users/addUser
Content-Type: application/json

{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "dateOfBirth": "1990-01-01",
  "gender": "Male",
  "height": 175.5,
  "weight": 70.0,
  "bloodGroup": "O+"
}

Response: 201 Created
```

#### User Login
```http
POST /users/login
Content-Type: application/json

{
  "email": "john@example.com",
  "password": "password123"
}

Response: 200 OK (User object) or 401 Unauthorized
```

#### Get All Users
```http
GET /users/getAllUsers

Response: 200 OK (Array of users)
```

#### Get User by ID
```http
GET /users/getUser/{id}

Response: 200 OK (User object)
```

#### Update User
```http
PUT /users/updateUser
Content-Type: application/json

{
  "id": 1,
  "name": "John Doe Updated",
  ...
}

Response: 200 OK
```

#### Delete User
```http
DELETE /users/deleteUser/{id}

Response: 200 OK
```

### Blood Pressure Management

#### Add Blood Pressure Record
```http
POST /blood_pressure/addBloodPressureRecord
Content-Type: application/json

{
  "testDate": "2024-01-15",
  "bpLevel": "120/80",
  "imageUrl": "https://example.com/image.jpg",
  "user": { "id": 1 }
}

Response: 201 Created
```

#### Get All Blood Pressure Records
```http
GET /blood_pressure/getAllBloodPressureRecords

Response: 200 OK
```

#### Get Blood Pressure Record by ID
```http
GET /blood_pressure/getBloodPressureRecord/{id}

Response: 200 OK
```

#### Get Blood Pressure Records by User ID
```http
GET /blood_pressure/getBloodPressureRecordsByUserId/{userId}

Response: 200 OK
```

#### Update Blood Pressure Record
```http
PUT /blood_pressure/updateBloodPressureRecord
Content-Type: application/json

Response: 200 OK
```

#### Delete Blood Pressure Record
```http
DELETE /blood_pressure/deleteBloodPressureRecord/{id}

Response: 200 OK
```

### Fasting Blood Sugar Management

#### Add FBS Record
```http
POST /fasting_blood_sugar/addFastingBloodSugarRecord
Content-Type: application/json

{
  "testDate": "2024-01-15",
  "fbsLevel": 95.5,
  "imageUrl": "https://example.com/image.jpg",
  "user": { "id": 1 }
}

Response: 201 Created
```

**Similar endpoints available for FBS**:
- `GET /fasting_blood_sugar/getAllFastingBloodSugarRecords`
- `GET /fasting_blood_sugar/getFastingBloodSugarRecord/{id}`
- `GET /fasting_blood_sugar/getFastingBloodSugarRecordsByUserId/{userId}`
- `PUT /fasting_blood_sugar/updateFastingBloodSugarRecord`
- `DELETE /fasting_blood_sugar/deleteFastingBloodSugarRecord/{id}`

### Full Blood Count Management

#### Add FBC Record
```http
POST /full_blood_count/addFullBloodCountRecord
Content-Type: application/json

{
  "testDate": "2024-01-15",
  "haemoglobin": 14.5,
  "totalLeucocyteCount": 7500,
  "plateletCount": 250000,
  "imageUrl": "https://example.com/image.jpg",
  "user": { "id": 1 }
}

Response: 201 Created
```

**Similar endpoints available for Full Blood Count**:
- `GET /full_blood_count/getAllFullBloodCountRecords`
- `GET /full_blood_count/getFullBloodCountRecord/{id}`
- `GET /full_blood_count/getFullBloodCountRecordsByUserId/{userId}`
- `PUT /full_blood_count/updateFullBloodCountRecord`
- `DELETE /full_blood_count/deleteFullBloodCountRecord/{id}`

### Lipid Profile Management

#### Add Lipid Profile Record
```http
POST /lipid_profile/addLipidProfileRecord
Content-Type: application/json

{
  "testDate": "2024-01-15",
  "totalCholesterol": 200,
  "hdl": 60,
  "ldl": 120,
  "vldl": 20,
  "triglycerides": 150,
  "imageUrl": "https://example.com/image.jpg",
  "user": { "id": 1 }
}

Response: 201 Created
```

**Similar endpoints available for Lipid Profile**:
- `GET /lipid_profile/getAllLipidProfileRecords`
- `GET /lipid_profile/getLipidProfileRecord/{id}`
- `GET /lipid_profile/getLipidProfileRecordsByUserId/{userId}`
- `PUT /lipid_profile/updateLipidProfileRecord`
- `DELETE /lipid_profile/deleteLipidProfileRecord/{id}`

### Liver Profile Management

#### Add Liver Profile Record
```http
POST /liver_profile/addLiverProfileRecord
Content-Type: application/json

{
  "testDate": "2024-01-15",
  "proteinTotalSerum": 7.0,
  "albuminSerum": 4.5,
  "bilirubinTotalSerum": 1.0,
  "sgpt": 30,
  "imageUrl": "https://example.com/image.jpg",
  "user": { "id": 1 }
}

Response: 201 Created
```

**Similar endpoints available for Liver Profile**:
- `GET /liver_profile/getAllLiverProfileRecords`
- `GET /liver_profile/getLiverProfileRecord/{id}`
- `GET /liver_profile/getLiverProfileRecordsByUserId/{userId}`
- `PUT /liver_profile/updateLiverProfileRecord`
- `DELETE /liver_profile/deleteLiverProfileRecord/{id}`

### Urine Report Management

#### Add Urine Report Record
```http
POST /urine_report/addUrineReportRecord
Content-Type: application/json

{
  "testDate": "2024-01-15",
  "color": "Yellow",
  "appearance": "Clear",
  "protein": "Negative",
  "sugar": "Negative",
  "specificGravity": 1.020,
  "imageUrl": "https://example.com/image.jpg",
  "user": { "id": 1 }
}

Response: 201 Created
```

**Similar endpoints available for Urine Report**:
- `GET /urine_report/getAllUrineReportRecords`
- `GET /urine_report/getUrineReportRecord/{id}`
- `GET /urine_report/getUrineReportRecordsByUserId/{userId}`
- `PUT /urine_report/updateUrineReportRecord`
- `DELETE /urine_report/deleteUrineReportRecord/{id}`

### Report Management

#### Get Reports by User ID
```http
GET /reports/getReportsByUserId/{userId}

Response: 200 OK
```

#### Update Report
```http
PUT /reports/updateReport
Content-Type: application/json

Response: 200 OK
```

#### Delete Report
```http
DELETE /reports/deleteReport/{id}

Response: 200 OK
```

## ⚙ Configuration

### Environment Variables

Create the following environment variables or configure them in your application properties:

| Variable | Description | Example |
|----------|-------------|---------|
| `Database_Host` | PostgreSQL connection URL | `jdbc:postgresql://localhost:5432/medisync` |
| `Database_Username` | Database username | `postgres` |
| `Database_Password` | Database password | `your_password` |
| `RESEND_API_KEY` | Resend API key for emails | `re_xxxxxxxxxxxxx` |

### application.properties

```properties
# Application Name
spring.application.name=MediSync

# Database Configuration
spring.datasource.url=${Database_Host}
spring.datasource.username=${Database_Username}
spring.datasource.password=${Database_Password}

# Connection Pool Configuration (HikariCP)
spring.datasource.hikari.pool-name=SpringBootConnectorCP
spring.datasource.hikari.maximumPoolSize=5
spring.datasource.hikari.minimumIdle=3
spring.datasource.hikari.maxLifetime=2000000
spring.datasource.hikari.connectionTimeout=30000
spring.datasource.hikari.idleTimeout=30000
spring.datasource.hikari.auto-commit=true

# JPA/Hibernate Configuration
spring.jpa.hibernate.ddl-auto=none
spring.jpa.properties.hibernate.format_sql=true
spring.jpa.show-sql=true

# Logging Configuration
logging.level.root=WARN
logging.level.com.lakshan.medi_sync=INFO
logging.level.org.springframework=ERROR
logging.level.org.hibernate=ERROR

# Email Service Configuration
resend.api.key=${RESEND_API_KEY}
```

## 🚀 Getting Started

### 1. Clone the Repository

```bash
cd backend
```

### 2. Set Up PostgreSQL Database

Create a new PostgreSQL database:

```sql
CREATE DATABASE medisync;
```

Run the database migration scripts to create tables (ensure your schema matches the entities).

### 3. Configure Environment Variables

Set the required environment variables:

**Windows (PowerShell)**:
```powershell
$env:Database_Host = "jdbc:postgresql://localhost:5432/medisync"
$env:Database_Username = "postgres"
$env:Database_Password = "your_password"
$env:RESEND_API_KEY = "your_resend_api_key"
```

**Linux/Mac**:
```bash
export Database_Host="jdbc:postgresql://localhost:5432/medisync"
export Database_Username="postgres"
export Database_Password="your_password"
export RESEND_API_KEY="your_resend_api_key"
```

### 4. Build the Project

```bash
./mvnw clean install
```

Or on Windows:
```bash
mvnw.cmd clean install
```

### 5. Run the Application

```bash
./mvnw spring-boot:run
```

Or on Windows:
```bash
mvnw.cmd spring-boot:run
```

The application will start on `http://localhost:8080`

## 🏗 Building & Running

### Development Mode

```bash
./mvnw spring-boot:run
```

This will:
- Start the application with hot reload enabled
- Enable developer tools
- Connect to the configured PostgreSQL database

### Production Build

```bash
# Build the JAR file
./mvnw clean package

# Run the JAR
java -jar target/medi_sync-0.0.1-SNAPSHOT.jar
```

### Running Tests

```bash
./mvnw test
```

## ✨ Features

### 1. User Management
- User registration with password hashing (SHA-256)
- Secure login authentication
- User profile management
- Complete CRUD operations for users

### 2. Health Record Management
Comprehensive tracking of:
- **Blood Pressure**: Systolic/diastolic readings
- **Fasting Blood Sugar**: Glucose level monitoring
- **Full Blood Count**: Haemoglobin, WBC, platelet counts
- **Lipid Profile**: Cholesterol levels (Total, HDL, LDL, VLDL, Triglycerides)
- **Liver Profile**: Liver function tests (Protein, Albumin, Bilirubin, SGPT)
- **Urine Report**: Comprehensive urinalysis

### 3. Consolidated Reports
- Generate comprehensive health reports
- Link multiple test results to a single report
- Track health trends over time

### 4. Image Storage
- Support for storing medical report images
- Image URL references for all test types

### 5. Email Notifications
- Asynchronous email sending using Resend API
- Health test reminders
- Customizable email templates

## 📧 Email Service

The application uses the Resend API for sending emails asynchronously. The `EmailService` class provides:

- **Async Processing**: Emails are sent asynchronously using `@Async` annotation
- **Health Reminders**: Automated reminders for scheduled health tests
- **Custom Templates**: Configurable email templates for different notification types

### Email Configuration

```properties
resend.api.key=${RESEND_API_KEY}
```

### Usage Example

```java
@Autowired
private EmailService emailService;

// Send a health reminder
emailService.sendTestReminderEmail(
    "patient@example.com",
    "Blood Test Reminder",
    "Your blood test is scheduled for tomorrow."
);
```

## 🔒 Security

### Password Security
- All passwords are hashed using SHA-256 before storage
- Passwords are never stored in plain text
- Login validation with secure password comparison

### Best Practices Implemented
- Environment-based configuration for sensitive data
- WRITE_ONLY access for password fields in JSON responses
- Connection pooling for efficient database resource management
- Prepared statements via JPA to prevent SQL injection

### Future Security Enhancements
Consider implementing:
- JWT-based authentication
- Role-based access control (RBAC)
- Password strength requirements
- Account lockout after failed attempts
- HTTPS/TLS encryption
- Rate limiting on API endpoints

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 👨‍💻 Author

**Lakshan**

## 📞 Support

For support, email medisync.app.team@gmail.com or create an issue in the repository.

---

**Note**: This is a demo project. For production use, ensure proper security measures, comprehensive testing, and compliance with healthcare data regulations (HIPAA, GDPR, etc.).
