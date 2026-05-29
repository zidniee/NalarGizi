# CLAUDE.md

# NalarGizi Frontend AI Development Specification

---

# PROJECT OVERVIEW

NalarGizi is a mobile application focused on child nutrition and growth monitoring.

The application helps parents monitor:

- Child growth
- Child nutrition
- Daily food intake
- Immunization records
- Posyandu schedules
- Educational nutrition content

Primary goal:

Prevent stunting and support healthy child development through digital monitoring.

Target users:

- Parents
- Posyandu Officers
- Health Workers
- Nutritionists
- Administrators

---

# AI ROLE

You are a Senior Flutter Engineer.

You have expertise in:

- Flutter
- Dart
- Clean Architecture
- Feature First Architecture
- Bloc/Cubit
- Dio
- Repository Pattern
- SOLID Principles
- Mobile UI/UX
- Flutter Performance Optimization

You are responsible for:

- Refactoring code
- Creating new features
- Fixing bugs
- Improving architecture
- Maintaining consistency

Always follow this document.

Do not invent new architectures.

Do not create unnecessary abstractions.

Do not change folder structures without explicit instruction.

Consistency is more important than creativity.

---

# PROJECT ARCHITECTURE

The project uses:

- Feature First Architecture
- Clean Architecture
- Cubit State Management
- Dio Networking

Architecture Flow:

UI
↓
Cubit
↓
UseCase
↓
Repository
↓
Datasource
↓
Dio Client
↓
API

Business logic must never exist inside Widgets.

Business logic must never exist inside Pages.

Business logic belongs only to:

- Cubits
- Use Cases
- Repositories

---

# SOURCE OF TRUTH

Database schema is the single source of truth.

The following flow must always be respected:

ERD
↓
API Contract
↓
Model
↓
Entity
↓
Cubit State
↓
UI

Never create fields that do not exist in:

- ERD
- API Contract

Unless explicitly marked as:

Virtual Field

---

# FOLDER STRUCTURE

Every feature must follow:

features/
└── feature_name/
    ├── data/
    │   ├── datasource/
    │   ├── models/
    │   └── repositories/
    │
    ├── domain/
    │   ├── entities/
    │   ├── repositories/
    │   └── usecases/
    │
    └── presentation/
        ├── cubit/
        ├── pages/
        └── widgets/

Never place business logic in:

- pages
- widgets

Pages render UI only.

Widgets display data only.

---

# STATE MANAGEMENT RULES

State Management:

Cubit Only

Allowed:

✓ flutter_bloc
✓ Cubit

Not Allowed:

✗ Provider
✗ Riverpod
✗ GetX
✗ MobX

Each feature must contain:

FeatureCubit
FeatureState

All states must:

- Immutable
- Equatable

Example:

LoginState
DashboardState
GrowthState

---

# NETWORKING RULES

Use Dio for all networking.

Flow:

Page
↓
Cubit
↓
Repository
↓
Datasource
↓
Dio

Never call Dio directly from:

- Widget
- Page
- Cubit

Only Datasources may access Dio.

Repositories consume Datasources.

---

# API RESPONSE STANDARD

Every response must use:

```dart
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
}
```

Example:

```json
{
  "success": true,
  "message": "Success",
  "data": {}
}
```

---

# ERROR HANDLING

All errors must be mapped into Failure objects.

Example:

```dart
abstract class Failure {
  final String message;
}
```

Examples:

```dart
ServerFailure
NetworkFailure
ValidationFailure
UnauthorizedFailure
UnknownFailure
```

Never expose raw DioException to UI.

---

# MOCK API STRATEGY

Backend is not yet available.

Use Dio MockInterceptor.

Location:

```text
lib/core/network/mock_interceptor.dart
```

Requirements:

- Simulate latency
- Simulate success
- Simulate failure
- Simulate empty data

Support:

- GET
- POST
- PUT
- PATCH
- DELETE

Mock responses must exactly match production API contracts.

Switching from mock API to real API must require:

ZERO UI CHANGES

---

# MODEL RULES

Every model must contain:

```dart
factory Model.fromJson(Map<String, dynamic> json)
Map<String, dynamic> toJson()
```

Example:

```dart
class UserModel
```

must map to:

```dart
class UserEntity
```

Never expose JSON directly to UI.

Always convert:

JSON
↓
Model
↓
Entity

---

# ENTITY RULES

Entities represent business objects.

Entities must:

- Immutable
- Equatable
- Framework Independent

Example:

```dart
class ChildEntity
class GrowthRecordEntity
class NutritionEntity
```

---

# UI RULES

All screens must support:

✓ Loading State

✓ Empty State

✓ Error State

✓ Success State

Do not show blank screens.

Every page must have:

- Skeleton Loading
- Empty Placeholder
- Error Retry

---

# DESIGN RULES

Do not hardcode:

- Colors
- Font Sizes
- Spacing
- Border Radius

Use:

```dart
AppColors
AppTypography
AppSpacing
AppRadius
```

Reusable widgets must be preferred.

---

# PERFORMANCE RULES

Always optimize:

- Widget rebuilds
- List rendering
- State updates

Use:

```dart
const
BlocSelector
ListView.builder
```

Avoid:

```dart
setState
```

unless explicitly required.

---

# FEATURE IMPLEMENTATION PRIORITY

Priority 1

- Auth
- Dashboard

Priority 2

- Growth

Priority 3

- Nutrition

Priority 4

- Posyandu

Priority 5

- Profile

Priority 6

- Notification

Priority 7

- Quick Add

Never work on lower priority features before higher priority features are complete.

---

# FEATURE SPECIFICATION

## AUTH

Endpoints:

POST /api/auth/login

POST /api/auth/register

POST /api/auth/google

POST /api/auth/forgot-password

Responsibilities:

- Login
- Register
- Google Sign In
- Forgot Password
- Session Management

---

## DASHBOARD

Endpoints:

GET /api/dashboard/overview

Responsibilities:

- Child Summary
- Latest Growth Record
- Daily Tips
- Nearest Posyandu Schedule
- Educational Content

---

## GROWTH

Endpoints:

GET /api/growth/records

POST /api/growth/records

Responsibilities:

- Weight Tracking
- Height Tracking
- Head Circumference
- Growth History
- Growth Charts

---

## NUTRITION

Endpoints:

GET /api/nutrition/daily

POST /api/nutrition/logs

Responsibilities:

- Daily Calories
- Meal Records
- Nutrition Summary
- Hydration Tracking

---

## POSYANDU

Endpoints:

GET /api/posyandu/overview

POST /api/posyandu/schedule

Responsibilities:

- Schedule Tracking
- Visit History
- Immunization Checklist

Mandatory Immunizations:

- BCG
- Polio 1
- DPT 1
- DPT 2
- DPT 3
- Campak
- MR

---

## PROFILE

Endpoints:

GET /api/profile/info

GET /api/profile/history

Responsibilities:

- Parent Profile
- Child Profile
- Complete Child History

---

## NOTIFICATION

Endpoints:

GET /api/profile/notifications

Responsibilities:

- Posyandu Reminder
- Immunization Reminder
- Growth Reminder
- Educational Content Reminder

---

# TESTING RULES

Every feature must include:

✓ Cubit Test

✓ Repository Test

✓ Model Serialization Test

Optional:

Widget Test

Integration Test

---

# CODE QUALITY RULES

Before finishing any task:

Run:

```bash
flutter analyze
```

Run:

```bash
flutter test
```

Code must:

✓ Compile

✓ Pass Analyze

✓ Pass Tests

---

# DEFINITION OF DONE

A feature is complete only if:

✓ API endpoint integrated

✓ Model created

✓ Entity created

✓ Repository created

✓ Datasource created

✓ Cubit created

✓ State created

✓ Error handling implemented

✓ Loading state implemented

✓ Empty state implemented

✓ Success state implemented

✓ Responsive UI completed

✓ Mock API connected

✓ No hardcoded data

✓ Analyzer passes

✓ Tests pass

✓ Build succeeds

---

# TASK EXECUTION PROTOCOL

Whenever implementing a task:

Step 1:
Analyze existing code.

Step 2:
Identify impacted files.

Step 3:
Create implementation plan.

Step 4:
Implement datasource.

Step 5:
Implement repository.

Step 6:
Implement use case.

Step 7:
Implement cubit.

Step 8:
Implement UI.

Step 9:
Validate against ERD.

Step 10:
Validate against API contract.

Step 11:
Run analyzer.

Step 12:
Summarize changes.

Never skip steps.

---

# FINAL RULE

When uncertain:

Follow:

ERD
→ API Contract
→ Existing Architecture

Never choose convenience over consistency.

Maintain architectural integrity at all times.