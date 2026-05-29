# Codebase Map

## Folder Structure

```
lib/
├── app/                  # App initialization, routing, theme, layouts
├── core/                 # Shared infrastructure (network, errors, DI, storage)
├── features/             # Feature modules (Clean Architecture applied)
│   ├── auth/
│   ├── dashboard/
│   ├── growth/
│   ├── nutrition/
│   ├── posyandu/
│   ├── profile/
│   └── quick_add/
└── shared/               # Shared widgets/utils across features
```

## Features

### Auth
- **Pages:** `login_page.dart`, `register_page.dart`, `forgot_password_page.dart`
- **Cubits:** `auth_cubit.dart`, `auth_state.dart`
- **Repositories:** `auth_repository.dart`, `auth_repository_impl.dart`
- **Datasources:** `auth_remote_data_source.dart`
- **Models:** `auth_response_model.dart`, `child_model.dart`, `user_model.dart`
- **Entities:** `auth_entity.dart`
- **API Endpoints:** `/api/auth/login`, `/api/auth/register`, `/api/auth/google`, `/api/auth/forgot-password`
- **Status:** Complete

### Dashboard
- **Pages:** `dashboard_page.dart`
- **Cubits:** `dashboard_cubit.dart`, `dashboard_state.dart`
- **Repositories:** `dashboard_repository.dart`, `dashboard_repository_impl.dart`
- **Datasources:** `dashboard_remote_data_source.dart`
- **Models:** `dashboard_model.dart`, `dashboard_overview_model.dart`
- **Entities:** `dashboard_entity.dart`
- **API Endpoints:** `/api/dashboard/overview`
- **Status:** Complete

### Growth
- **Pages:** `growth_page.dart`
- **Cubits:** `growth_cubit.dart`, `growth_state.dart`
- **Repositories:** `growth_repository.dart`, `growth_repository_impl.dart`
- **Datasources:** `growth_remote_data_source.dart`, `growth_local_data_source.dart`
- **Models:** `growth_model.dart`
- **Entities:** `growth_entity.dart`
- **API Endpoints:** `/api/growth/records` (GET/POST)
- **Status:** Complete

### Posyandu
- **Pages:** `posyandu_page.dart`
- **Cubits:** `posyandu_cubit.dart` (located in `bloc/`)
- **Repositories:** `posyandu_repository_impl.dart`
- **Datasources:** `posyandu_remote_data_source.dart`, `posyandu_local_data_source.dart`
- **Models:** `immunization_item_model.dart`, `posyandu_model.dart`, `posyandu_schedule_item_model.dart`
- **Entities:** `immunization_item_entity.dart`, `posyandu_entity.dart`, `posyandu_schedule_item_entity.dart`
- **API Endpoints:** `/api/posyandu/overview`, `/api/posyandu/schedule`
- **Status:** Partial (Needs DI integration and failure record mapping validation)

### Nutrition
- **Pages:** `nutrition_page.dart`
- **Cubits:** Not Started
- **Repositories:** Not Started
- **Datasources:** `nutrition_remote_data_source.dart`, `nutrition_local_data_source.dart` (Placeholders/Incomplete)
- **Models:** `nutrition_model.dart`
- **Entities:** `nutrition_entity.dart` (Placeholder)
- **API Endpoints:** `/api/nutrition/daily`, `/api/nutrition/logs`
- **Status:** Partial (UI only, Domain/Data missing)

### Profile
- **Pages:** `profile_page.dart` (Assumption, UI likely present)
- **Cubits:** Not Started
- **Repositories:** Not Started
- **Datasources:** `profile_remote_data_source.dart` (Placeholder)
- **Models:** `profile_model.dart`
- **Entities:** `profile_entity.dart` (Placeholder)
- **API Endpoints:** `/api/profile/info`, `/api/profile/history`, `/api/profile/notifications`
- **Status:** Partial (UI only, Domain/Data missing)

### Quick Add
- **Pages:** `quick_add_bottom_sheet.dart` (Widget)
- **Cubits:** N/A (Should delegate to other feature cubits)
- **Repositories:** N/A
- **Datasources:** N/A
- **Models:** N/A
- **Entities:** N/A
- **API Endpoints:** N/A
- **Status:** Partial (Needs to be wired up to other Cubits)
