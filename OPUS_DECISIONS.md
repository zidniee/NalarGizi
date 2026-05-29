# NalarGizi — Implementation Plan

Rencana implementasi ini **100% berdasarkan** tiga dokumen berikut tanpa referensi luar:
- [claude.md](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/claude.md) — Mock API blueprint & JSON schema
- [claude1.md](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/claude1.md) — Clean Architecture rules & DoD
- [claude2.md](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/claude2.md) — Gap fixes (ApiResponse wrapper, Either, DI, Offline-first, Form validation)

---

## Kondisi Codebase Saat Ini

| Area | Status | Detail |
|---|---|---|
| **Folder Structure** | ✅ Benar | Semua feature sudah mengikuti `data/domain/presentation` per `claude1.md` |
| **MockInterceptor** | ⚠️ Partial | Sudah ada di [mock_interceptor.dart](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/lib/core/network/mock_interceptor.dart), tapi **tidak dibungkus `ApiResponse`** (melanggar `claude2.md` §1) |
| **ApiResponse\<T\>** | ❌ Belum ada | Wajib per `claude1.md` §API Response Standard |
| **Failure classes** | ❌ Belum ada | `lib/core/error/` hanya berisi `.gitkeep`. Wajib per `claude1.md` §Error Handling |
| **Either pattern** | ❌ Belum ada | Tidak ada `dartz`/`fpdart` di pubspec. Wajib per `claude2.md` §2 |
| **DI (get_it)** | ⚠️ Ada di pubspec tapi belum dipakai | `injectable` + `get_it` ada. Belum ada `injection.dart`. Wajib per `claude2.md` §3 |
| **Auth** | ⚠️ Skeleton | Entity ada, Cubit ada (tapi catch raw Exception), Repository abstract ada, **Datasource KOSONG**, **Model KOSONG** |
| **Growth** | ⚠️ Salah mapping | Entity hanya punya `id/title/description` — tidak cocok ERD (`claude.md` §3C: `weight_kg`, `height_cm`, `z_score_status`, dll). Model sama. LocalDataSource referensi `GrowthRecordModel` yang belum ada. |
| **Dashboard** | ❌ Kosong layer data/domain | Hanya ada UI page + widgets |
| **Nutrition** | ❌ Kosong layer data/domain | Hanya ada UI page |
| **Posyandu** | ⚠️ Partial | Ada datasource/model/repository/cubit tapi inisialisasi manual di Page (melanggar `claude2.md` §3) |
| **Profile** | ❌ Kosong layer data/domain | Hanya ada UI page |
| **Quick Add** | ❌ Kosong layer data/domain | Hanya ada bottom sheet widget |

---

## User Review Required

> [!IMPORTANT]
> **Package `dartz` atau `fpdart`**: `claude2.md` §2 mewajibkan `Either<Failure, T>` di Repository. Package mana yang disetujui untuk ditambahkan ke `pubspec.yaml`?
> - **Opsi A** — `dartz` (mature, banyak digunakan)
> - **Opsi B** — `fpdart` (modern, maintained)
> - **Opsi C** — Custom sealed class `Result<T>` tanpa package tambahan

> [!IMPORTANT]
> **Validasi form** (`claude2.md` §5): Apakah cukup menggunakan validasi manual di Cubit, atau perlu menambahkan package `formz`?

> [!IMPORTANT]
> **Build runner**: Implementasi DI dengan `injectable` memerlukan eksekusi `dart run build_runner build`. Apakah disetujui?

---

## Proposed Changes

Setiap tahap mengikuti **Task Execution Protocol** 12 langkah dari `claude1.md` §692-732:
```
Step 1: Analyze existing code
Step 2: Identify impacted files
Step 3: Create implementation plan
Step 4: Implement datasource
Step 5: Implement repository
Step 6: Implement use case
Step 7: Implement cubit
Step 8: Implement UI
Step 9: Validate against ERD
Step 10: Validate against API contract
Step 11: Run analyzer
Step 12: Summarize changes
```

---

### Tahap 0 — Core Foundation

Fondasi yang digunakan oleh **semua** fitur. Tidak ada fitur yang boleh dikerjakan sebelum tahap ini selesai.

---

#### [NEW] `lib/core/network/api_response.dart`
**Sumber**: `claude1.md` §233-253, `claude2.md` §1
```dart
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  // factory fromJson(Map<String, dynamic> json, T Function(dynamic) fromData)
}
```

#### [MODIFY] [api_endpoints.dart](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/lib/core/network/api_endpoints.dart)
**Sumber**: `claude.md` §3A-3G (semua endpoint), `claude1.md` §476-604
Menambahkan semua endpoint konstanta:
```
POST /api/auth/login
POST /api/auth/register
POST /api/auth/google
POST /api/auth/forgot-password
GET  /api/dashboard/overview
GET  /api/growth/records
POST /api/growth/records
GET  /api/nutrition/daily
POST /api/nutrition/logs
GET  /api/posyandu/overview
POST /api/posyandu/schedule
GET  /api/profile/info
GET  /api/profile/history
GET  /api/profile/notifications
```

#### [MODIFY] [mock_interceptor.dart](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/lib/core/network/mock_interceptor.dart)
**Sumber**: `claude2.md` §1 (KOREKSI FATAL)
Semua response di-wrap dengan format:
```json
{ "success": true, "message": "...", "data": { <payload dari claude.md> } }
```
- Response auth login/register/google → wrap `claude.md` §3A JSON
- Response dashboard overview → wrap `claude.md` §3B JSON
- Response growth GET/POST → wrap `claude.md` §3C JSON
- Response nutrition GET/POST → wrap `claude.md` §3D JSON
- Response posyandu overview → wrap `claude.md` §3E JSON
- Response profile/notifications → wrap `claude.md` §3G JSON
- Tambahkan endpoint profile info & history yang belum ada

Tambahan per `claude1.md` §295-300:
- Simulate latency ✅ (sudah ada 500ms)
- Simulate success ✅
- Simulate failure (tambahkan mekanisme untuk test error state)
- Simulate empty data (tambahkan mekanisme untuk test empty state)

#### [NEW] `lib/core/error/failures.dart`
**Sumber**: `claude1.md` §257-280
```dart
abstract class Failure {
  final String message;
}
class ServerFailure extends Failure { ... }
class NetworkFailure extends Failure { ... }
class ValidationFailure extends Failure { ... }
class UnauthorizedFailure extends Failure { ... }
class UnknownFailure extends Failure { ... }
```

#### [NEW] `lib/core/error/exceptions.dart`
**Sumber**: `claude2.md` §2 (Datasource hanya melempar Exception)
```dart
class ServerException implements Exception { ... }
class CacheException implements Exception { ... }
```
Catatan: [network_exception.dart](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/lib/core/network/network_exception.dart) sudah ada dan akan tetap dipertahankan.

#### [NEW] `lib/core/di/injection.dart`
**Sumber**: `claude2.md` §3
```dart
final getIt = GetIt.instance;
@InjectableInit()
Future<void> configureDependencies() async => getIt.init();
```

#### [NEW] `lib/core/di/injection.config.dart`
Auto-generated oleh `build_runner` + `injectable_generator`.

#### [MODIFY] [main.dart](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/lib/main.dart)
Tambahkan:
```dart
await configureDependencies();   // claude2.md §3
await Hive.initFlutter();         // claude2.md §4
```

#### [MODIFY] [app.dart](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/lib/app/app.dart)
Sediakan `MultiBlocProvider` global untuk Auth di root, karena session management dibutuhkan di seluruh app (`claude1.md` §AUTH: Session Management).

---

### Tahap 1 — Priority 1: Auth

**Sumber utama**: `claude1.md` §478-497, `claude.md` §3A, `claude2.md` §2-3-5

#### [NEW] `lib/features/auth/data/models/user_model.dart`
Field sesuai `claude.md` §3A JSON: `id`, `name`, `email`, `phone_number`, `email_verified_at`
Wajib: `fromJson()`, `toJson()`, `toEntity()` per `claude1.md` §318-348

#### [NEW] `lib/features/auth/data/models/child_model.dart`
Field: `id`, `user_id`, `name`, `birth_date`, `gender`
Wajib: `fromJson()`, `toJson()`, `toEntity()`

#### [NEW] `lib/features/auth/data/models/auth_response_model.dart`
Wrapper: `token`, `UserModel user`, `ChildModel child`

#### [NEW] `lib/features/auth/data/datasources/auth_remote_data_source.dart`
**Sumber**: `claude1.md` §205-230 (hanya Datasource boleh akses Dio)
```dart
@lazySingleton
class AuthRemoteDataSource {
  final Dio _dio;
  Future<AuthResponseModel> login(String email, String password) { ... }
  Future<AuthResponseModel> register(...) { ... }
  Future<AuthResponseModel> googleLogin(String idToken) { ... }
  Future<void> forgotPassword(String email) { ... }
}
```

#### [MODIFY] [auth_entity.dart](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/lib/features/auth/domain/entities/auth_entity.dart)
Sesuaikan field `UserEntity` dengan ERD `claude.md` §3A: `name` (bukan `fullName`), tipe `id` = `int` (bukan `String`). `ChildEntity` tambahkan `birth_date`, `gender`. Semua Entity wajib **Immutable** & **Equatable** (`claude1.md` §351-367).

#### [MODIFY] [auth_repository.dart](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/lib/features/auth/domain/repositories/auth_repository.dart)
Ubah return type menjadi `Either<Failure, T>` per `claude2.md` §2:
```dart
Future<Either<Failure, AuthTokens>> login({...});
Future<Either<Failure, UserEntity>> register({...});
Future<Either<Failure, AuthTokens>> googleLogin(String idToken);
Future<Either<Failure, void>> forgotPassword(String email);
```

#### [MODIFY] [auth_repository_impl.dart](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/lib/features/auth/data/repositories/auth_repository_impl.dart)
Implementasi `Either` pattern: try/catch `ServerException` → return `Left(ServerFailure(...))` per `claude2.md` §2.

#### [NEW] `lib/features/auth/domain/usecases/login_usecase.dart`
#### [NEW] `lib/features/auth/domain/usecases/register_usecase.dart`
#### [NEW] `lib/features/auth/domain/usecases/google_login_usecase.dart`
#### [NEW] `lib/features/auth/domain/usecases/forgot_password_usecase.dart`
**Sumber**: `claude1.md` §80-94 (Architecture Flow: UseCase wajib ada antara Repository dan Cubit)

#### [MODIFY] [auth_cubit.dart](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/lib/features/auth/presentation/bloc/auth_cubit.dart)
- Terima UseCase via constructor (bukan Repository langsung, sesuai flow `claude1.md`)
- Gunakan `@injectable` (`claude2.md` §3)
- Tambahkan method: `login()`, `register()`, `googleLogin()`, `forgotPassword()`
- Validasi form di-handle di sini (`claude2.md` §5): `emailChanged()`, `passwordChanged()`, emit `isEmailValid`, `isPasswordValid`
- Handle `Either`: `fold(onFailure, onSuccess)` (`claude2.md` §2)

#### [MODIFY] [auth_state.dart](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/lib/features/auth/presentation/bloc/auth_state.dart)
Tambahkan **Equatable** (`claude1.md` §191-196), tambahkan field validasi form per `claude2.md` §5.

#### [MODIFY] [login_page.dart](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/lib/features/auth/presentation/pages/login_page.dart)
- Tampilkan 4 state: Loading, Empty, Error, Success (`claude1.md` §371-390)
- Skeleton Loading, Error Retry
- Gunakan `BlocProvider` + `GetIt.I<AuthCubit>()` (`claude2.md` §3)
- Tidak boleh ada business logic (`claude1.md` §96-104)
- Gunakan `AppColors`, `AppTypography`, `AppSpacing` (`claude1.md` §393-411)

#### [NEW] `lib/features/auth/presentation/pages/register_page.dart`
**Sumber**: `claude.md` §3A (POST /api/auth/register)

#### [NEW] `lib/features/auth/presentation/pages/forgot_password_page.dart`
**Sumber**: `claude.md` §3A (POST /api/auth/forgot-password)

#### [MODIFY] [app_router.dart](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/lib/app/router/app_router.dart)
Tambahkan route: `register`, `forgotPassword`

---

### Tahap 1B — Priority 1: Dashboard

**Sumber utama**: `claude1.md` §500-512, `claude.md` §3B

#### [NEW] `lib/features/dashboard/data/models/dashboard_overview_model.dart`
Sub-models sesuai JSON `claude.md` §3B:
- `ChildInfoModel` (`name`, `age_months`, `gender`)
- `LastGrowthModel` (`weight_kg`, `height_cm`, `z_score_status`, `recorded_at`)
- `DailyTipModel` (`title`, `content`)
- `NearestScheduleModel` (`id`, `posyandu_center_name`, `title`, `description`, `event_date`)
- `PosyanduCenterModel` (`id`, `name`, `address`, `leader_name`)
- `EducationalContentModel` (`id`, `title`, `media_url`, `thumbnail_url`, `duration`)

Semua wajib `fromJson()`, `toJson()`, `toEntity()` (`claude1.md` §318-348)

#### [NEW] `lib/features/dashboard/domain/entities/dashboard_entity.dart`
Entity: `DashboardOverviewEntity` berisi semua sub-entity. **Immutable**, **Equatable** (`claude1.md` §351-367)

#### [NEW] `lib/features/dashboard/data/datasources/dashboard_remote_data_source.dart`
Panggil `GET /api/dashboard/overview?child_id=<id>` via Dio (`claude.md` §3B)

#### [NEW] `lib/features/dashboard/domain/repositories/dashboard_repository.dart`
Return `Either<Failure, DashboardOverviewEntity>` (`claude2.md` §2)

#### [NEW] `lib/features/dashboard/data/repositories/dashboard_repository_impl.dart`
Try/catch → Left/Right (`claude2.md` §2)

#### [NEW] `lib/features/dashboard/domain/usecases/get_dashboard_overview_usecase.dart`

#### [NEW] `lib/features/dashboard/presentation/cubit/dashboard_cubit.dart`
#### [NEW] `lib/features/dashboard/presentation/cubit/dashboard_state.dart`
State: `Loading`, `Empty`, `Error`, `Success` (`claude1.md` §371-390)

#### [MODIFY] `lib/features/dashboard/presentation/pages/dashboard_page.dart`
- Ganti semua data hardcoded → baca dari `DashboardState`
- Nama bayi, usia, berat, Z-Score status, tips harian, jadwal terdekat, edukasi gizi, info posyandu → semua dari Cubit
- Skeleton Loading (`claude1.md` §387)
- `BlocProvider` + `GetIt.I<DashboardCubit>()` (`claude2.md` §3)

---

### Tahap 2 — Priority 2: Growth

**Sumber utama**: `claude1.md` §516-530, `claude.md` §3C, `claude2.md` §4

#### [MODIFY] [growth_entity.dart](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/lib/features/growth/domain/entities/growth_entity.dart)
**REWRITE** — Entity saat ini (`id/title/description`) tidak sesuai ERD. Ganti menjadi:
`id`, `child_id`, `age_months`, `weight_kg`, `height_cm`, `head_circumference_cm`, `z_score_status`, `recorded_at`
Sesuai JSON `claude.md` §3C. Wajib **Equatable** (`claude1.md` §351-367)

#### [MODIFY] [growth_model.dart](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/lib/features/growth/data/models/growth_model.dart)
**REWRITE** — Sesuaikan field dengan entity baru. Rename ke `GrowthRecordModel`.
Wajib: `fromJson()`, `toJson()`, `toEntity()` (`claude1.md` §318-348)

#### [MODIFY] [growth_remote_data_source.dart](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/lib/features/growth/data/datasources/growth_remote_data_source.dart)
**REWRITE** — Saat ini return hardcoded `GrowthModel`. Ganti:
- `getRecords(childId)` → `GET /api/growth/records?child_id=<id>` via Dio
- `addRecord(data)` → `POST /api/growth/records` via Dio

#### [MODIFY] [growth_local_data_source.dart](file:///d:/Tugas/SEMESTER%206/Mobile/nalargizi/lib/features/growth/data/datasources/growth_local_data_source.dart)
Sesuaikan referensi `GrowthRecordModel` dengan model baru. Logika Hive tetap dipertahankan per `claude2.md` §4 (Cache-Then-Network).

#### [NEW] `lib/features/growth/domain/repositories/growth_repository.dart`
```dart
Future<Either<Failure, List<GrowthRecordEntity>>> getRecords(String childId);
Future<Either<Failure, GrowthRecordEntity>> addRecord(Map<String, dynamic> data);
```

#### [NEW] `lib/features/growth/data/repositories/growth_repository_impl.dart`
Implementasi Offline-First per `claude2.md` §4:
1. Return data dari LocalDataSource dulu
2. Fetch dari RemoteDataSource di background
3. Simpan ke LocalDataSource, emit ulang via stream/callback

#### [NEW] `lib/features/growth/domain/usecases/get_growth_records_usecase.dart`
#### [NEW] `lib/features/growth/domain/usecases/add_growth_record_usecase.dart`

#### [NEW] `lib/features/growth/presentation/cubit/growth_cubit.dart`
#### [NEW] `lib/features/growth/presentation/cubit/growth_state.dart`
State mencakup: `Loading`, `Success(records)`, `Error`, `Empty` (`claude1.md` §371-390)
Perhitungan kenaikan BB/TB = `Sekarang - Sebelumnya` (business logic di Cubit, per `claude1.md` §96-104)

#### [MODIFY] `lib/features/growth/presentation/pages/growth_page.dart`
Ganti semua data hardcoded. Grafik `fl_chart` / `syncfusion_flutter_charts` membaca `List<GrowthRecordEntity>` dari state.

---

### Tahap 3 — Priority 3: Nutrition

**Sumber utama**: `claude1.md` §534-548, `claude.md` §3D

#### [NEW] `lib/features/nutrition/data/models/nutrition_daily_model.dart`
Field sesuai JSON `claude.md` §3D: `target_calories`, `consumed_calories`, `remaining_calories`, `hydration_glasses_target`, `hydration_glasses_done`, `meals[]`

#### [NEW] `lib/features/nutrition/data/models/meal_model.dart`
Field: `id`, `meal_time`, `time_label`, `food_name`, `portion`, `calories`, `status`

#### [NEW] `lib/features/nutrition/domain/entities/nutrition_entity.dart`
`NutritionDailyEntity`, `MealEntity` — Immutable, Equatable

#### [NEW] `lib/features/nutrition/data/datasources/nutrition_remote_data_source.dart`
- `getDailySummary(childId, date)` → `GET /api/nutrition/daily`
- `addMealLog(data)` → `POST /api/nutrition/logs`

#### [NEW] `lib/features/nutrition/domain/repositories/nutrition_repository.dart`
Return `Either<Failure, NutritionDailyEntity>` / `Either<Failure, MealEntity>`

#### [NEW] `lib/features/nutrition/data/repositories/nutrition_repository_impl.dart`

#### [NEW] `lib/features/nutrition/domain/usecases/get_daily_nutrition_usecase.dart`
#### [NEW] `lib/features/nutrition/domain/usecases/add_meal_log_usecase.dart`

#### [NEW] `lib/features/nutrition/presentation/cubit/nutrition_cubit.dart`
#### [NEW] `lib/features/nutrition/presentation/cubit/nutrition_state.dart`
State: progress kalori, hidrasi, meal list. Logika "Sisa Sedikit / Habis / Belum Mencatat" di Cubit (`claude1.md` §96-104)

#### [MODIFY] `lib/features/nutrition/presentation/pages/nutrition_page.dart`
Progress bar kalori, gelas air putih, meal cards — semua dari state.

---

### Tahap 4 — Priority 4: Posyandu

**Sumber utama**: `claude1.md` §551-573, `claude.md` §3E, `claude2.md` §3

#### [MODIFY] Existing datasource/model/repository/cubit
- Wrap response dengan `ApiResponse` di datasource (`claude2.md` §1)
- Repository return `Either<Failure, T>` (`claude2.md` §2)
- **Hapus inisialisasi manual** di `posyandu_page.dart` → ganti `GetIt.I<PosyanduCubit>()` (`claude2.md` §3)

#### 7 Imunisasi Dasar Wajib (`claude1.md` §565-573, `claude.md` §3E):
BCG, Polio 1, DPT 1, DPT 2, DPT 3, Campak, MR
UI checklist: hijau ✓ jika `is_done: true`

---

### Tahap 5 — Priority 5: Profile

**Sumber utama**: `claude1.md` §577-589, `claude.md` §3G

#### [NEW] `lib/features/profile/data/models/profile_model.dart`
Reuse `UserModel` + `ChildModel` dari auth (DRY). Tambahkan field sesuai endpoint `/api/profile/info`.

#### [NEW] `lib/features/profile/data/datasources/profile_remote_data_source.dart`
- `getProfileInfo()` → `GET /api/profile/info`
- `getChildHistory()` → `GET /api/profile/history`

#### [NEW] `lib/features/profile/domain/entities/profile_entity.dart`
#### [NEW] `lib/features/profile/domain/repositories/profile_repository.dart`
#### [NEW] `lib/features/profile/data/repositories/profile_repository_impl.dart`
#### [NEW] `lib/features/profile/domain/usecases/get_profile_usecase.dart`
#### [NEW] `lib/features/profile/domain/usecases/get_history_usecase.dart`
#### [NEW] `lib/features/profile/presentation/cubit/profile_cubit.dart`
#### [NEW] `lib/features/profile/presentation/cubit/profile_state.dart`

#### [MODIFY] `lib/features/profile/presentation/pages/profile_page.dart`
Tampilkan profil orang tua + anak dari Cubit state. Halaman riwayat lengkap histori anak.

---

### Tahap 6 — Priority 6: Notification

**Sumber utama**: `claude1.md` §593-604, `claude.md` §3G

#### [NEW] `lib/features/profile/data/models/notification_model.dart`
Field sesuai JSON `claude.md` §3G: `id`, `title`, `message`, `type`, `is_read`, `created_at`

#### [NEW] `lib/features/profile/domain/entities/notification_entity.dart`
#### [NEW] `lib/features/profile/data/datasources/notification_remote_data_source.dart`
`GET /api/profile/notifications`

#### [NEW] `lib/features/profile/domain/usecases/get_notifications_usecase.dart`
#### [NEW] `lib/features/profile/presentation/cubit/notification_cubit.dart`
#### [NEW] `lib/features/profile/presentation/cubit/notification_state.dart`

#### [NEW] `lib/features/profile/presentation/pages/notification_page.dart`
List notifikasi per tipe (`posyandu`, `growth`, dll) sesuai JSON mock.

---

### Tahap 7 — Priority 7: Quick Add

**Sumber utama**: `claude.md` §3F

#### [MODIFY] `lib/features/quick_add/presentation/widgets/quick_add_bottom_sheet.dart`
Refactor agar mendelegasikan ke Cubit terkait:
1. Tambah BB/TB → panggil `GrowthCubit.addRecord()` (`POST /api/growth/records`)
2. Tambah Nutrisi → panggil `NutritionCubit.addMealLog()` (`POST /api/nutrition/logs`)
3. Jadwal Posyandu → panggil `PosyanduCubit.addSchedule()` (`POST /api/posyandu/schedule`)

**Tidak membuat endpoint sendiri** — langsung dialihkan ke endpoint fitur bersangkutan (`claude.md` §3F).

---

## Verification Plan

### Per Tahap (wajib sebelum lanjut ke tahap berikutnya)

Berdasarkan **Definition of Done** `claude1.md` §652-688:

| # | Check | Command / Method |
|---|---|---|
| 1 | API endpoint integrated | MockInterceptor merespons endpoint terkait |
| 2 | Model created + `fromJson`/`toJson` | Code review |
| 3 | Entity created (Immutable, Equatable) | Code review |
| 4 | Repository created (Either pattern) | Code review |
| 5 | Datasource created (hanya layer ini akses Dio) | Code review |
| 6 | Cubit created | Code review |
| 7 | State created (Immutable, Equatable) | Code review |
| 8 | Error handling (Failure, bukan raw Exception) | Code review |
| 9 | Loading state di UI (Skeleton) | Visual check |
| 10 | Empty state di UI (Placeholder) | Visual check |
| 11 | Success state di UI | Visual check |
| 12 | No hardcoded data | `grep` for hardcoded strings |
| 13 | Analyzer passes | `flutter analyze` |
| 14 | Tests pass | `flutter test` |
| 15 | Build succeeds | `flutter build apk --debug` |

### Automated Tests (Per `claude1.md` §608-622)

Setiap fitur wajib:
- ✅ **Model Serialization Test** — `fromJson` ↔ `toJson` roundtrip
- ✅ **Repository Test** — mock datasource, verify Either return
- ✅ **Cubit Test** — mock usecase, verify state transitions (Loading → Success/Error)

### Manual Verification
- Jalankan app di emulator, navigasi semua halaman
- Pastikan MockInterceptor delay 500ms → Skeleton loading terlihat
- Pastikan semua halaman bisa menampilkan Error state dan Empty state
