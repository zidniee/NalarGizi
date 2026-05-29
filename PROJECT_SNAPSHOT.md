# Project Snapshot

## Overall Progress

**Estimated Completion:** 60%

The project is past the foundational stage. Core infrastructure (networking, error handling, dependency injection) is established. Critical features (Auth, Dashboard, Growth) have full vertical implementations (Data → Domain → Presentation). The remaining features are in a mixed state of UI-only or partial implementation.

## Current Architecture

- **Architecture Pattern:** Clean Architecture (Presentation, Domain, Data)
- **State Management:** BLoC / Cubit pattern
- **Networking Layer:** Dio with `MockInterceptor` simulating backend responses. Responses are wrapped in a generic `ApiResponse<T>` wrapper.
- **Dependency Injection:** `GetIt` as a Service Locator (manual registration in `lib/core/di/injection.dart`).
- **Data Flow:** UI calls Cubit → Cubit calls UseCase → UseCase calls Repository → Repository calls Remote/Local DataSource.
- **Error Handling Pattern:** Datasources throw `Exception` (e.g., `ServerException`). Repositories catch exceptions and return Dart 3 Records containing `Failure` objects (e.g., `Future<({Data? data, Failure? failure})>`).

## Completed Features

- **Core Foundation:** API Client, Endpoints, ApiResponse, MockInterceptor, Failures, Exceptions, GetIt injection.
- **Auth (100%):** Models, Entities, Datasource, Repository, Usecases, Cubit, and UI Pages (Login, Register, Forgot Password).
- **Dashboard (100%):** Data/Domain layer fully implemented and connected to UI via Cubit.
- **Growth (100%):** Models, Entities, Remote and Local (Hive) Datasources, Repository (Offline-first approach), Usecases, Cubit, and UI.

## Partially Completed Features

- **Posyandu (~80%):** UI, Models, Entities, Datasources, and Cubit exist. **However**, it currently manually instantiates its dependencies in the UI (`posyandu_page.dart`) instead of using `GetIt`, and is not registered in `injection.dart`.
- **Quick Add (~50%):** UI bottom sheet exists but needs to be wired to the respective feature Cubits (Growth, Nutrition, Posyandu) instead of making direct API calls.

## Not Started Features

*(Note: "Not Started" means the Data/Domain layers are missing; the UI pages usually exist with hardcoded data)*
- **Nutrition (~20%):** Only UI page and placeholder entity/datasource files exist.
- **Profile (~15%):** Only UI page and placeholder entity/datasource files exist.

## File Inventory

### Implemented Files (Safe)
- `lib/core/network/*` (`api_client.dart`, `api_endpoints.dart`, `api_response.dart`, `mock_interceptor.dart`)
- `lib/core/error/*` (`exceptions.dart`, `failures.dart`)
- `lib/core/di/injection.dart`
- `lib/main.dart` (Hive & DI initialized)
- `lib/features/auth/*` (All data, domain, presentation files)
- `lib/features/dashboard/*` (All data, domain, presentation files)
- `lib/features/growth/*` (All data, domain, presentation files)

### Placeholder/Incomplete Files
- `lib/features/nutrition/domain/entities/nutrition_entity.dart` (Placeholder)
- `lib/features/nutrition/data/datasources/nutrition_remote_data_source.dart` (Placeholder)
- `lib/features/profile/domain/entities/profile_entity.dart` (Placeholder)
- `lib/features/profile/data/datasources/profile_remote_data_source.dart` (Placeholder)

### Technical Debt / Refactor Targets
- `lib/features/posyandu/presentation/pages/posyandu_page.dart` (Manual DI instantiation)
- `lib/features/quick_add/presentation/widgets/quick_add_bottom_sheet.dart` (Needs Cubit wiring)

## API Integration Status

- **Completed:** `/api/auth/login`, `/api/auth/register`, `/api/auth/google`, `/api/auth/forgot-password`, `/api/dashboard/overview`, `/api/growth/records` (GET/POST).
- **Missing/Mock Only:** `/api/nutrition/daily`, `/api/nutrition/logs`, `/api/posyandu/overview`, `/api/posyandu/schedule`, `/api/profile/info`, `/api/profile/history`, `/api/profile/notifications`.

## Technical Debt

- **Manual Dependency Injection:** The Posyandu feature bypasses `GetIt` and manually creates `ApiClient`, `Datasource`, `Repository`, and `UseCase` directly inside `PosyanduPage.initState`.
- **Hardcoded Data:** The Nutrition and Profile pages still rely heavily on hardcoded UI elements and have not been converted to consume Cubit states.
- **Inconsistent Error Handling:** Features implemented before the latest architecture rules (like Posyandu) might not be returning Dart 3 Records with `Failure` objects consistently.

## Risks

- **Offline-First Conflicts:** Growth feature implements Hive caching, but other features (Dashboard, Posyandu) do not. Need to ensure caching strategy is consistent where required.
- **State Integrity:** Since Posyandu bypasses DI, its Cubit is recreated on page loads rather than maintaining state as a singleton or properly scoped factory.

## Recommended Next Task

1. **Refactor Posyandu:** Update `posyandu_page.dart` to use `BlocProvider` with `GetIt.I<PosyanduCubit>()`. Register its dependencies in `injection.dart`. Ensure its repository uses the `Failure` record return pattern.
2. **Implement Nutrition:** Build out the missing Data and Domain layers for Nutrition based on the API mock schemas.
