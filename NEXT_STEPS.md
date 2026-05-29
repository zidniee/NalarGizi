# Next Steps

Based on the architectural guidelines and current project state, the following tasks must be executed sequentially.

## Priority 1: Posyandu Feature Refactoring
- **Why needed:** The Posyandu module is partially complete but violates Clean Architecture and Dependency Injection rules. It currently instantiates its own dependencies in the UI (`posyandu_page.dart`), bypasses the `ApiResponse<T>` wrapper, and its repository does not map exceptions to the standard Dart 3 Record `Failure` pattern. It must be brought into compliance with the rest of the application.
- **Files affected:**
  - `lib/features/posyandu/data/datasources/posyandu_remote_data_source.dart`
  - `lib/features/posyandu/domain/repositories/posyandu_repository.dart`
  - `lib/features/posyandu/data/repositories/posyandu_repository_impl.dart`
  - `lib/features/posyandu/presentation/bloc/posyandu_cubit.dart`
  - `lib/core/di/injection.dart`
  - `lib/features/posyandu/presentation/pages/posyandu_page.dart`
- **Dependencies:** None. This can and should be done immediately to stabilize the existing codebase.
- **Estimated complexity:** Low (Refactoring existing logic).

## Priority 2: Nutrition Feature Implementation
- **Why needed:** The Nutrition page exists as a static UI, but all underlying models, entities, repositories, and cubits are either missing or placeholders. To provide the core functionality of tracking daily nutrition and logging meals, the Data and Domain layers must be implemented and wired to the UI.
- **Files affected:**
  - `lib/features/nutrition/data/models/nutrition_model.dart`
  - `lib/features/nutrition/domain/entities/nutrition_entity.dart`
  - `lib/features/nutrition/data/datasources/nutrition_remote_data_source.dart`
  - `lib/features/nutrition/domain/repositories/nutrition_repository.dart`
  - `lib/features/nutrition/data/repositories/nutrition_repository_impl.dart`
  - `lib/features/nutrition/domain/usecases/get_daily_nutrition_usecase.dart` (NEW)
  - `lib/features/nutrition/domain/usecases/add_meal_log_usecase.dart` (NEW)
  - `lib/features/nutrition/presentation/cubit/nutrition_state.dart` (NEW)
  - `lib/features/nutrition/presentation/cubit/nutrition_cubit.dart` (NEW)
  - `lib/core/di/injection.dart`
  - `lib/features/nutrition/presentation/pages/nutrition_page.dart`
- **Dependencies:** Priority 1 should be completed first to ensure no overlapping DI modifications. Requires `claude.md` JSON schemas for models.
- **Estimated complexity:** Medium (Full vertical slice implementation).

## Priority 3: Profile & Notifications Implementation
- **Why needed:** The Profile section is stuck in a UI-only state. It requires implementing the fetch profile endpoints, history fetching, and notification fetching. This is required for user personalization and engagement.
- **Files affected:**
  - `lib/features/profile/data/models/profile_model.dart`
  - `lib/features/profile/data/models/notification_model.dart` (NEW)
  - `lib/features/profile/domain/entities/profile_entity.dart`
  - `lib/features/profile/domain/entities/notification_entity.dart` (NEW)
  - `lib/features/profile/data/datasources/profile_remote_data_source.dart`
  - `lib/features/profile/data/datasources/notification_remote_data_source.dart` (NEW)
  - `lib/features/profile/domain/repositories/profile_repository.dart` (NEW)
  - `lib/features/profile/data/repositories/profile_repository_impl.dart` (NEW)
  - `lib/features/profile/domain/usecases/get_profile_usecase.dart` (NEW)
  - `lib/features/profile/domain/usecases/get_history_usecase.dart` (NEW)
  - `lib/features/profile/domain/usecases/get_notifications_usecase.dart` (NEW)
  - `lib/features/profile/presentation/cubit/profile_cubit.dart` (NEW)
  - `lib/features/profile/presentation/cubit/profile_state.dart` (NEW)
  - `lib/features/profile/presentation/cubit/notification_cubit.dart` (NEW)
  - `lib/features/profile/presentation/cubit/notification_state.dart` (NEW)
  - `lib/core/di/injection.dart`
  - `lib/features/profile/presentation/pages/profile_page.dart`
  - `lib/features/profile/presentation/pages/notification_page.dart` (NEW)
- **Dependencies:** Priority 2 should be completed first. Requires `claude.md` JSON schemas for models.
- **Estimated complexity:** High (Multiple endpoints, multiple state management layers).

## Priority 4: Quick Add Integration
- **Why needed:** The Quick Add bottom sheet currently exists but is not functional. Per architecture decisions, it should not have its own endpoints or repository. Instead, it needs to be wired to trigger the add methods on the existing `GrowthCubit`, `NutritionCubit`, and `PosyanduCubit`.
- **Files affected:**
  - `lib/features/quick_add/presentation/widgets/quick_add_bottom_sheet.dart`
- **Dependencies:** Requires all prior priorities to be fully implemented, as it delegates tasks to their respective Cubits.
- **Estimated complexity:** Low (UI wiring only).
