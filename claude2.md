# CLAUDE2.md - Frontend Alignment & Missing Specifications

Dokumen ini merupakan hasil analisis komparatif antara `claude.md` (Rencana Praktis Mock API) dan `claude1.md` (Aturan Ketat Clean Architecture). Dokumen ini berfungsi untuk menutup *gap* (kekurangan) yang tidak dijelaskan di kedua dokumen tersebut agar implementasi kode benar-benar sempurna dan sesuai standar *Enterprise*.

---

## 1. KOREKSI FATAL: Standar Wrapper API Response

### Masalah:
Di `claude1.md`, setiap response diwajibkan menggunakan standar `ApiResponse<T>`:
```json
{
  "success": true,
  "message": "Success",
  "data": { ... }
}
```
Namun, di `claude.md` (dan di dalam script `setup_mock_api.ps1`), *Mock API* langsung mengembalikan *raw data* (contoh: `{ "child_info": ... }`). Ini akan menyebabkan error saat proses *parsing* di Repository/Datasource.

### Solusi (Aturan Baru):
Semua *MockInterceptor* dan *RemoteDataSource* **WAJIB** dibungkus menggunakan format `ApiResponse`.

**Contoh Payload yang Benar (Dashboard):**
```json
{
  "success": true,
  "message": "Data dashboard berhasil diambil",
  "data": {
    "child_info": { "name": "Arkan", "age_months": 14, "gender": "Laki-laki" },
    "last_growth": { "weight_kg": 9.8, "height_cm": 76.5, "z_score_status": "Normal" }
  }
}
```
*Tindakan:* Script Mock API (`setup_mock_api.ps1`) dan *Interceptor* yang sudah ada harus direvisi agar membungkus `data` dengan `success` dan `message`.

---

## 2. STRATEGI ERROR HANDLING (Repository Pattern)

### Masalah:
`claude1.md` menyebutkan bahwa semua error harus di-mapping menjadi class `Failure` (`ServerFailure`, `NetworkFailure`, dll), tetapi tidak menjelaskan *bagaimana* alur data dari Datasource ke Cubit. 

### Solusi (Aturan Baru):
Kita **WAJIB** menggunakan `Either<Failure, Type>` (dari package `dartz` atau `fpdart`, atau membuat class `Result` kustom) di dalam *Repository*.
**Datasource** hanya boleh melempar `Exception` (misal: `ServerException`).
**Repository** bertugas menangkap `Exception` tersebut dan mengembalikannya sebagai `Failure`.

**Contoh Standar Repository:**
```dart
abstract class GrowthRepository {
  Future<Either<Failure, List<GrowthRecordEntity>>> getGrowthRecords(String childId);
}

class GrowthRepositoryImpl implements GrowthRepository {
  final GrowthRemoteDataSource remoteDataSource;

  GrowthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<GrowthRecordEntity>>> getGrowthRecords(String childId) async {
    try {
      final models = await remoteDataSource.getRecords(childId);
      // Map Model ke Entity di sini
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
```
*Tindakan:* Cubit hanya boleh menerima objek `Either` dan bereaksi berdasarkan `Left` (ErrorState) atau `Right` (SuccessState).

---

## 3. DEPENDENCY INJECTION (DI) STRATEGY

### Masalah:
Sistem saat ini (contoh di `posyandu_page.dart`) melakukan inisialisasi manual di dalam UI:
```dart
final remoteDataSource = PosyanduRemoteDataSource(dio);
final repository = PosyanduRepositoryImpl(remoteDataSource);
final useCase = GetPosyanduDataUseCase(repository);
_cubit = PosyanduCubit(useCase)..load();
```
Ini melanggar aturan `claude1.md` (Business logic must never exist inside Pages).

### Solusi (Aturan Baru):
Proyek memiliki library `get_it` dan `injectable` di `pubspec.yaml`. Kita **WAJIB** menggunakan Service Locator.

**Aturan Registrasi:**
1. Gunakan `@injectable` / `@lazySingleton` pada semua Datasource, Repository, dan UseCase.
2. Gunakan `@injectable` pada Cubit.
3. Di dalam UI, panggil dependency menggunakan `GetIt.I<MyCubit>()` atau melalui BlocProvider di layer router.

**Contoh UI yang Benar:**
```dart
@override
Widget build(BuildContext context) {
  return BlocProvider(
    create: (context) => GetIt.I<PosyanduCubit>()..load(),
    child: PosyanduView(),
  );
}
```

---

## 4. OFFLINE-FIRST & LOCAL CACHING (Hive)

### Masalah:
`claude.md` fokus pada Dio Mock API, sedangkan proyek ini memiliki package `hive` dan local datasource (contoh `growth_local_data_source.dart`). Tidak ada aturan tentang kapan menggunakan Local vs Remote.

### Solusi (Aturan Baru):
Penerapan arsitektur **Cache-Then-Network** (Offline First) di Repository:
1. Saat UI meminta data, Repository pertama kali mengambil data dari `LocalDataSource` (Hive) dan me-return *Right* agar UI cepat tampil.
2. Di background, Repository memanggil `RemoteDataSource` (Dio/Mock API) untuk mengambil data terbaru.
3. Jika data Remote sukses diambil, simpan ke `LocalDataSource`, dan update Cubit state.
4. Operasi `POST/PUT/DELETE` disimpan ke Local terlebih dahulu dengan `syncStatus = pending`, lalu dikirim ke Remote.

---

## 5. STANDAR VALIDASI FORM

### Masalah:
Tidak ada aturan tentang validasi form (Login, Tambah BB/TB, dll). Menaruh logika validasi (regex, pengecekan panjang string) di dalam `TextFormField` melanggar Clean Architecture.

### Solusi (Aturan Baru):
Validasi form **WAJIB** dikelola oleh Cubit State (bisa menggunakan package `formz` jika tersedia, atau validasi custom di Cubit).
- UI hanya memanggil `context.read<AuthCubit>().emailChanged(val)`.
- Cubit menghitung validasi dan meng-emit state `isEmailValid`.
- UI menampilkan pesan error berdasarkan state Cubit, bukan logika lokal di Widget.

---

## KESIMPULAN PENYELARASAN
Dengan ditambahkannya `claude2.md` ini, maka tiga pilar utama telah lengkap:
1. **claude.md**: Cetak biru skema JSON & ERD, serta mekanisme Mock Interceptor.
2. **claude1.md**: Konstitusi utama Clean Architecture, State Management, dan Definisi Selesai (DoD).
3. **claude2.md**: Penambal celah integrasi (Wrapper Response, Either/Dartz, Dependency Injection `GetIt`, Offline-first Hive, dan Form Validation).
