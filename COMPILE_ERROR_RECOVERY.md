# Compile Error Recovery Report

This report analyzes the compiler errors detected during static analysis (`flutter analyze`) in the NalarGizi Flutter application. The errors are categorized by their root causes to guide recovery and cleanup efforts without altering the architecture.

---

## 1. Core Infrastructure / Sync Layer Errors

### Error A: Undefined Sync Getter in ApiEndpoints
- **Error Description:** `The getter 'sync' isn't defined for the type 'ApiEndpoints' - lib/core/sync/sync_manager.dart:117:22 - undefined_getter`
- **Root Cause:** Incomplete Claude Implementation. `SyncManager` implements the offline-first synchronization process by sending a bulk payload POST request to the backend. It references `ApiEndpoints.sync`, but this endpoint was never added to the constants in the core network configuration.
- **Affected Files:**
  - [api_endpoints.dart](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/lib/core/network/api_endpoints.dart)
  - [sync_manager.dart](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/lib/core/sync/sync_manager.dart)
- **Related Architecture Layer:** Core / Infrastructure (Network & Storage)
- **Recovery Recommendation:** Define `static const sync = '$_base/v1/sync';` in the `ApiEndpoints` class. Since `_base` is `/api`, this correctly maps to the expected `/api/v1/sync` endpoint matching the backend route.

---

## 2. Invalid Web/HTML Parameters on Flutter Widgets

### Error B: Undefined Parameter 'id' on Forms and Buttons
- **Error Description:** `The named parameter 'id' isn't defined` on `TextField`, `ElevatedButton`, and `OutlinedButton` widgets.
- **Root Cause:** Architecture Inconsistency / Web vs. Mobile Mismatch. A previous agent attempted to fulfill HTML/Web-based testing standards (specifically the SEO & UI unique ID guidelines) by inserting an `id` named parameter onto native Flutter widgets. Native Flutter material widgets do not support an `id` property.
- **Affected Files:**
  - [forgot_password_page.dart](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/lib/features/auth/presentation/pages/forgot_password_page.dart) (Lines 127, 157)
  - [login_page.dart](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/lib/features/auth/presentation/pages/login_page.dart) (Lines 152, 182, 242, 299)
  - [register_page.dart](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/lib/features/auth/presentation/pages/register_page.dart) (Lines 108, 134, 162, 196, 221)
  - [dashboard_page.dart](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/lib/features/dashboard/presentation/pages/dashboard_page.dart) (Line 230 - retry button)
- **Related Architecture Layer:** Presentation Layer (UI Pages)
- **Recovery Recommendation:** Replace the `id: '...'` parameters with `key: const Key('...')` (or `ValueKey`). This enables widget testing identification in Flutter without causing syntax or compilation failures.

---

## 3. Dashboard Obsolete/Dead Code Files

### Error C: DashboardModel Class Extending Non-existent Entity
- **Error Description:** `Classes can only extend other classes - lib/features/dashboard/data/models/dashboard_model.dart:3:30 - extends_non_class`
- **Root Cause:** Leftover/Duplicate Skeleton Files. `DashboardModel` is an unused model class from an early skeleton. The actual domain mapping uses `DashboardOverviewModel` and `DashboardOverviewEntity`. `DashboardModel` tries to extend `DashboardEntity` which does not exist in the domain layer.
- **Affected Files:**
  - [dashboard_model.dart](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/lib/features/dashboard/data/models/dashboard_model.dart)
- **Related Architecture Layer:** Data Layer (Models)
- **Recovery Recommendation:** Delete the obsolete file `lib/features/dashboard/data/models/dashboard_model.dart`.

### Error D: Obsolete Use Case Calling Undefined Repository Method
- **Error Description:**
  - `The name 'DashboardEntity' isn't a type - lib/features/dashboard/domain/usecases/get_dashboard_data_usecase.dart:9:10 - non_type_as_type_argument`
  - `The method 'getDashboardData' isn't defined for the type 'DashboardRepository' - lib/features/dashboard/domain/usecases/get_dashboard_data_usecase.dart:10:24 - undefined_method`
- **Root Cause:** Leftover/Duplicate Skeleton Files. `GetDashboardDataUseCase` was generated as an early placeholder usecase. The active dashboard usecase is `GetDashboardOverviewUseCase` (located in `get_dashboard_overview_usecase.dart`).
- **Affected Files:**
  - [get_dashboard_data_usecase.dart](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/lib/features/dashboard/domain/usecases/get_dashboard_data_usecase.dart)
- **Related Architecture Layer:** Domain Layer (Use Cases)
- **Recovery Recommendation:** Delete the obsolete file `lib/features/dashboard/domain/usecases/get_dashboard_data_usecase.dart`.

---

## 4. Dashboard Widgets Constructor Mismatch

### Error E: Widgets Lacking Constructors for Passed Parameters
- **Error Description:** `The named parameter 'weightKg'` (and similar parameters) is not defined for custom dashboard widgets.
- **Root Cause:** Constructor Mismatch. The dashboard page `dashboard_page.dart` retrieves structured overview data and correctly passes dynamic properties to the UI widgets. However, the widgets themselves are static placeholders with empty default constructors (`const Widget({super.key})`).
- **Affected Files:**
  - [dashboard_page.dart](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/lib/features/dashboard/presentation/pages/dashboard_page.dart) (Invoking widgets)
  - [dashboard_status_row.dart](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/lib/features/dashboard/presentation/widgets/dashboard_status_row.dart) (Constructor needs `weightKg`, `ageMonths`, `zScoreStatus`)
  - [tip_harian_card.dart](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/lib/features/dashboard/presentation/widgets/tip_harian_card.dart) (Constructor needs `title`, `content`)
  - [z_score_indicator_card.dart](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/lib/features/dashboard/presentation/widgets/z_score_indicator_card.dart) (Constructor needs `zScoreStatus`, `weightKg`, `heightCm`)
  - [jadwal_terdekat_card.dart](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/lib/features/dashboard/presentation/widgets/jadwal_terdekat_card.dart) (Constructor needs `NearestScheduleEntity? schedule`)
  - [edukasi_gizi_section.dart](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/lib/features/dashboard/presentation/widgets/edukasi_gizi_section.dart) (Constructor needs `List<EducationalContentEntity> contents`)
  - [info_posyandu_banner.dart](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/lib/features/dashboard/presentation/widgets/info_posyandu_banner.dart) (Constructor needs `PosyanduCenterEntity? center`)
- **Related Architecture Layer:** Presentation Layer (UI Widgets)
- **Recovery Recommendation:** Refactor the widget constructors to accept the dynamic parameters, define the corresponding private variables, and bind them to the build tree (with standard mock values acting as fallbacks in case of null values).
