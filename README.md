# NalarGizi

Aplikasi mobile Flutter untuk pemantauan tumbuh kembang, jurnal nutrisi, dan jadwal posyandu.

README ini menjelaskan struktur folder yang dipakai di project agar mudah dipahami dan konsisten untuk semua anggota tim.

## Dokumentasi Runtun Untuk Pemula

Jika kamu masih awal belajar Flutter, mulai dari dokumen ini terlebih dulu:
- `docs/PANDUAN_UI_DARI_STRUKTUR_FOLDER.md`
- `docs/PANDUAN_PEMULA_BANGUN_APLIKASI.md`
- `docs/PANDUAN_STATE_SAMPAI_API.md`
- `docs/PANDUAN_FULL_TIM_DARI_DESAIN_SAMPAI_RELEASE.md`

Dokumen roadmap teknis yang lebih ringkas:
- `docs/TUTORIAL_RUTE_PEMBANGUNAN_APLIKASI.md`

## Arsitektur Singkat

Project menggunakan pendekatan:
- `feature-first`: kode dipisah per fitur bisnis.
- `clean architecture` ringan: setiap fitur memiliki lapisan `data`, `domain`, dan `presentation`.
- `shared core`: utilitas lintas fitur disimpan di `core` dan `shared`.

Manfaat utama:
- Mudah scale saat fitur bertambah.
- Kode lebih mudah diuji.
- Batas tanggung jawab antar layer lebih jelas.

## Struktur Folder Utama

```text
lib/
	main.dart
	app/
		app.dart
		router/
			app_router.dart
		theme/
			app_theme.dart
	core/
		constants/
		error/
		network/
		utils/
	shared/
		extensions/
		services/
		widgets/
	features/
		auth/
		dashboard/
		growth/
		nutrition/
		posyandu/
		profile/
		quick_add/
		splash/

assets/
	images/
	icons/
	lottie/
	fonts/

test/
	unit/
	widget/

integration_test/
```

## Penjelasan Tiap Folder

### `lib/app`
- Lokasi konfigurasi level aplikasi.
- `app.dart`: root widget aplikasi.
- `router/`: deklarasi route global.
- `theme/`: konfigurasi tema, warna, dan typography.

### `lib/core`
- Komponen inti yang reusable lintas fitur.
- Contoh isi:
- `constants/`: konstanta global.
- `error/`: model error, exception, failure.
- `network/`: client API, interceptor, endpoint.
- `utils/`: helper umum.

### `lib/shared`
- Komponen presentasi dan service yang dipakai banyak fitur.
- Contoh isi:
- `widgets/`: reusable widgets.
- `extensions/`: extension method.
- `services/`: service lintas fitur.

### `lib/features/<feature_name>`
Setiap fitur mengikuti pola yang sama:

```text
features/<feature>/
	<feature>.dart
	data/
		datasources/
		models/
		repositories/
	domain/
		entities/
		repositories/
		usecases/
	presentation/
		bloc/
		pages/
		widgets/
```

Arti layer:
- `data`: komunikasi ke API/local storage dan implementasi repository.
- `domain`: business rule murni (entity, contract repository, use case).
- `presentation`: UI, state management (`cubit/bloc`), dan widget halaman.

## Daftar Fitur Saat Ini

- `dashboard`: ringkasan status anak di halaman beranda.
- `growth`: kurva tumbuh kembang dan riwayat pengukuran.
- `nutrition`: jurnal nutrisi harian.
- `posyandu`: jadwal dan status imunisasi.
- `quick_add`: entry point tambah data cepat (bottom sheet/menu).
- `profile`: data profil pengguna/anak.
- `auth`: autentikasi.
- `splash`: halaman awal aplikasi.

## Konvensi Penamaan

- Gunakan `snake_case` untuk nama file.
- Gunakan `PascalCase` untuk class.
- Penamaan file layer per fitur:
- `<feature>_entity.dart`
- `<feature>_repository.dart`
- `get_<feature>_data_usecase.dart`
- `<feature>_cubit.dart`, `<feature>_state.dart`
- `<feature>_page.dart`

## Cara Menambah Fitur Baru

1. Buat folder baru di `lib/features/<nama_fitur>`.
2. Ikuti struktur `data/domain/presentation` yang sama.
3. Tambahkan route di `lib/app/router/app_router.dart`.
4. Tambahkan page ke alur navigasi aplikasi.
5. Jika butuh dependency baru, update `pubspec.yaml`.
6. Tambahkan unit test/widget test minimal untuk logic dan UI penting.

## Dependency Baseline

Project sudah menyiapkan dependency dasar production, termasuk:
- Routing: `go_router`
- State management: `flutter_bloc`
- Network: `dio`, `pretty_dio_logger`
- DI: `get_it`, `injectable`
- Storage: `shared_preferences`, `hive`, `hive_flutter`
- UI/util: `intl`, `flutter_svg`, `cached_network_image`, `connectivity_plus`

## Setup Project

Jalankan perintah berikut setelah clone:

```bash
flutter pub get
flutter run
```

Untuk generate file berbasis codegen (jika sudah digunakan):

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Catatan Tim

- Jaga konsistensi struktur. Jangan campur logic domain ke UI layer.
- Utamakan reusable widget di `shared/widgets` jika dipakai lebih dari 1 fitur.
- Simpan resource visual pada folder `assets/` yang sesuai.
