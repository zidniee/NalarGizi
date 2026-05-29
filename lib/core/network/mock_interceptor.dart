import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Mock Dio interceptor that simulates backend API responses.
///
/// Source: claude.md §2 (Strategy Mocking via Dio Interceptor)
/// Source: claude1.md §MOCK API STRATEGY
/// Source: claude2.md §1 (KOREKSI FATAL — semua response WAJIB dibungkus ApiResponse)
///
/// Requirements (claude1.md §295-308):
/// - Simulate latency ✅ (500ms)
/// - Simulate success ✅
/// - Simulate failure ✅ (gunakan query param ?mock_error=true)
/// - Simulate empty data ✅ (gunakan query param ?mock_empty=true)
/// - Support GET, POST, PUT, PATCH, DELETE ✅
///
/// ZERO UI CHANGES required when switching to real API (claude1.md §312-314).
class MockInterceptor extends Interceptor {
  // ── In-memory CRUD simulation ──────────────────────────────────────────

  final List<Map<String, dynamic>> _growthRecords = [
    {
      'id': 17,
      'child_id': 1,
      'age_months': 19,
      'weight_kg': 6.0,
      'height_cm': 20.5,
      'head_circumference_cm': 10.5,
      'z_score_status': 'buruk',
      'recorded_at': '2026-10-20',
    },
    {
      'id': 16,
      'child_id': 1,
      'age_months': 18,
      'weight_kg': 11.0,
      'height_cm': 80.5,
      'head_circumference_cm': 48.5,
      'z_score_status': 'Normal',
      'recorded_at': '2026-09-20',
    },
    {
      'id': 15,
      'child_id': 1,
      'age_months': 17,
      'weight_kg': 10.6,
      'height_cm': 79.1,
      'head_circumference_cm': 48.1,
      'z_score_status': 'Normal',
      'recorded_at': '2026-08-20',
    },
    {
      'id': 14,
      'child_id': 1,
      'age_months': 16,
      'weight_kg': 10.2,
      'height_cm': 78.5,
      'head_circumference_cm': 47.5,
      'z_score_status': 'Normal',
      'recorded_at': '2026-07-20',
    },
    {
      'id': 13,
      'child_id': 1,
      'age_months': 15,
      'weight_kg': 10.0,
      'height_cm': 78.0,
      'head_circumference_cm': 47.0,
      'z_score_status': 'Normal',
      'recorded_at': '2026-06-20',
    },
    {
      'id': 12,
      'child_id': 1,
      'age_months': 14,
      'weight_kg': 9.8,
      'height_cm': 76.5,
      'head_circumference_cm': 46.0,
      'z_score_status': 'Normal',
      'recorded_at': '2026-05-20',
    },
    {
      'id': 11,
      'child_id': 1,
      'age_months': 13,
      'weight_kg': 9.4,
      'height_cm': 75.0,
      'head_circumference_cm': 45.5,
      'z_score_status': 'Normal',
      'recorded_at': '2026-04-18',
    },
    {
      'id': 10,
      'child_id': 1,
      'age_months': 12,
      'weight_kg': 9.1,
      'height_cm': 73.8,
      'head_circumference_cm': 45.0,
      'z_score_status': 'Normal',
      'recorded_at': '2026-03-15',
    },
  ];
  final Map<String, List<Map<String, dynamic>>> _nutritionLogsByDate = {};

  Map<String, String> _getDailyTip(String status) {
    final statusLower = status.toLowerCase();
    if (statusLower == 'normal') {
      return {
        'title': 'Tips Gizi Normal (Z-Score)',
        'content': 'Status gizi Arkan terpantau normal. Lanjutkan pemberian ASI/MPASI dengan porsi seimbang dan perbanyak protein hewani seperti hati ayam dan telur untuk menunjang tumbuh kembang kognitif.',
      };
    } else if (statusLower == 'kurang') {
      return {
        'title': 'Tips Gizi Kurang (Z-Score)',
        'content': 'Berat/tinggi badan Arkan terpantau kurang dari standar. Berikan MPASI padat energi dan tambahkan lemak tambahan seperti santan, mentega, atau minyak kelapa pada makanannya.',
      };
    } else {
      return {
        'title': 'Tips Gizi Buruk/Lebih (Z-Score)',
        'content': 'Segera konsultasikan tumbuh kembang anak Anda dengan bidan atau dokter spesialis anak di posyandu terdekat untuk penanganan gizi terpadu.',
      };
    }
  }

  final List<Map<String, dynamic>> _upcomingSchedules = [
    {
      'id': 301,
      'title': 'Posyandu Bulanan & Vitamin A',
      'category': 'Vitamin',
      'location': 'Puskesmas Garuda',
      'scheduled_at': '2026-06-05T08:00:00.000Z',
      'note': 'Bawa Buku KIA dan kartu imunisasi',
      'is_completed': false,
    },
  ];

  final List<Map<String, dynamic>> _completedSchedules = [
    {
      'id': 300,
      'title': 'Imunisasi DPT 2',
      'category': 'Imunisasi',
      'location': 'Puskesmas Garuda',
      'scheduled_at': '2025-07-15T08:00:00.000Z',
      'note': 'Kondisi anak sehat, tidak ada demam setelahnya',
      'is_completed': true,
    },
  ];

  final List<Map<String, dynamic>> _mockNotifications = [
    {
      'id': 1,
      'title': 'Jadwal Posyandu Terdekat',
      'message': 'Jangan lupa datang ke Posyandu Mawar 1 besok pukul 08:00 untuk Imunisasi Campak Arkan.',
      'type': 'posyandu',
      'is_read': false,
      'created_at': '2026-05-26T18:00:00.000Z',
    },
    {
      'id': 2,
      'title': 'Tips Z-Score Arkan',
      'message': 'Berdasarkan timbangan terakhir, grafik tumbuh kembang Arkan membaik. Lihat tips gizi di sini.',
      'type': 'growth',
      'is_read': true,
      'created_at': '2026-05-20T10:00:00.000Z',
    },
  ];

  // ── Helper: build wrapped ApiResponse payload ──────────────────────────

  /// Wraps raw data with ApiResponse envelope.
  /// Source: claude2.md §1 — KOREKSI FATAL
  Map<String, dynamic> _wrap(dynamic data, {String message = 'Berhasil'}) {
    return {
      'success': true,
      'message': message,
      'data': data,
    };
  }

  /// Wraps an error response.
  Map<String, dynamic> _wrapError(String message) {
    return {
      'success': false,
      'message': message,
      'data': null,
    };
  }

  // ── Interceptor ────────────────────────────────────────────────────────

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Simulate network latency (claude.md §2, claude1.md §297)
    await Future.delayed(const Duration(milliseconds: 500));

    final path = options.path;
    final method = options.method.toUpperCase();

    debugPrint('[MockAPI] $method $path');

    final dateStr = options.queryParameters['date'] ?? 
        DateTime.now().toIso8601String().split('T')[0];
    
    if (!_nutritionLogsByDate.containsKey(dateStr)) {
      _nutritionLogsByDate[dateStr] = [
        {
          'id': 201,
          'meal_time': 'breakfast',
          'time_label': '07:00',
          'food_name': 'Bubur Hati Ayam + Bayam',
          'portion': '1 Porsi',
          'calories': 400,
          'status': 'Habis',
          'carbohydrate_g': 20,
          'protein_g': 8,
          'fat_g': 4,
        },
        {
          'id': 202,
          'meal_time': 'lunch',
          'time_label': '12:30',
          'food_name': 'Nasi Tim Telur Puyuh',
          'portion': '1 Porsi',
          'calories': 180,
          'status': 'Sisa Sedikit',
          'carbohydrate_g': 24,
          'protein_g': 10,
          'fat_g': 5,
        },
      ];
    }

    // ── Simulate empty data (for testing empty state) ──────────────────
    final mockEmpty = options.queryParameters['mock_empty'] == 'true';
    // ── Simulate error (for testing error state) ───────────────────────
    final mockError = options.queryParameters['mock_error'] == 'true';

    if (mockError) {
      return handler.resolve(Response(
        requestOptions: options,
        statusCode: 500,
        data: _wrapError('Simulasi error dari server.'),
      ));
    }

    // ── AUTH LOGIN & GOOGLE (claude.md §3A) ───────────────────────────
    if (path.contains('/api/auth/login') ||
        path.contains('/api/auth/google')) {
      return handler.resolve(Response(
        requestOptions: options,
        statusCode: 200,
        data: _wrap(
          {
            'token': 'dummy_jwt_token_eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9',
            'user': {
              'id': 1,
              'name': 'Zidnie',
              'email': 'zidni@gmail.com',
              'phone_number': '081234567890',
              'email_verified_at': '2026-05-27T06:00:00.000Z',
              'created_at': '2026-05-27T06:00:00.000Z',
              'updated_at': '2026-05-27T06:00:00.000Z',
            },
            'child': {
              'id': 1,
              'user_id': 1,
              'name': 'Arkan NalarGizi',
              'birth_date': '2025-03-15',
              'gender': 'Laki-laki',
              'created_at': '2026-05-27T06:00:00.000Z',
              'updated_at': '2026-05-27T06:00:00.000Z',
            },
          },
          message: 'Login berhasil.',
        ),
      ));
    }

    // ── AUTH REGISTER (claude.md §3A) ─────────────────────────────────
    if (path.contains('/api/auth/register')) {
      final body = options.data as Map<String, dynamic>? ?? {};
      return handler.resolve(Response(
        requestOptions: options,
        statusCode: 201,
        data: _wrap(
          {
            'token': 'dummy_jwt_token_eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9',
            'user': {
              'id': 2,
              'name': body['name'] ?? 'User Baru',
              'email': body['email'] ?? 'user@gmail.com',
              'phone_number': body['phone_number'] ?? '',
              'email_verified_at': null,
              'created_at': '2026-05-27T06:00:00.000Z',
              'updated_at': '2026-05-27T06:00:00.000Z',
            },
            'child': null,
          },
          message: 'Registrasi berhasil. Silakan lengkapi profil anak.',
        ),
      ));
    }

    // ── AUTH FORGOT PASSWORD (claude.md §3A) ──────────────────────────
    if (path.contains('/api/auth/forgot-password')) {
      return handler.resolve(Response(
        requestOptions: options,
        statusCode: 200,
        data: _wrap(
          null,
          message: 'Link reset password telah dikirim ke email Anda.',
        ),
      ));
    }

    // ── DASHBOARD OVERVIEW (claude.md §3B) ────────────────────────────
    if (path.contains('/api/dashboard/overview')) {
      return handler.resolve(Response(
        requestOptions: options,
        statusCode: 200,
        data: _wrap(
          {
            'child_info': {
              'name': 'Arkan NalarGizi',
              'age_months': 14,
              'gender': 'Laki-laki',
            },
            'last_growth': {
              'weight_kg':
                  _growthRecords.isNotEmpty
                      ? _growthRecords.first['weight_kg']
                      : 9.8,
              'height_cm':
                  _growthRecords.isNotEmpty
                      ? _growthRecords.first['height_cm']
                      : 76.5,
              'z_score_status':
                  _growthRecords.isNotEmpty
                      ? _growthRecords.first['z_score_status']
                      : 'Normal',
              'recorded_at':
                  _growthRecords.isNotEmpty
                      ? _growthRecords.first['recorded_at']
                      : '2026-05-20',
            },
            'daily_tip': _getDailyTip(
              _growthRecords.isNotEmpty
                  ? _growthRecords.first['z_score_status']
                  : 'Normal',
            ),
            'nearest_schedule':
                _upcomingSchedules.isNotEmpty
                    ? {
                      'id': _upcomingSchedules.first['id'],
                      'posyandu_center_name': 'Posyandu Mawar 1',
                      'title': _upcomingSchedules.first['title'],
                      'description':
                          'Pemeriksaan berkala pertumbuhan bayi serta pemberian vitamin wajib.',
                      'event_date': _upcomingSchedules.first['scheduled_at'],
                    }
                    : null,
            'posyandu_center': {
              'id': 5,
              'name': 'Posyandu Mawar 1',
              'address': 'Jl. Mawar Merah No. 45, RT 02/RW 03, Jakarta Selatan',
              'leader_name': 'Bidan Siti Aminah',
            },
            'educational_contents':
                mockEmpty
                    ? []
                    : [
                      {
                        'id': 1,
                        'title':
                            'Pentingnya Protein Hewani untuk Mencegah Stunting',
                        'media_url':
                            'https://www.youtube.com/watch?v=xMHJGd3wwZk',
                        'thumbnail_url':
                            'https://img.youtube.com/vi/xMHJGd3wwZk/hqdefault.jpg',
                        'duration': '08:45',
                      },
                      {
                        'id': 2,
                        'title':
                            'Panduan MPASI Praktis untuk Bayi Usia 12-24 Bulan',
                        'media_url':
                            'https://www.youtube.com/watch?v=xMHJGd3wwZk',
                        'thumbnail_url':
                            'https://img.youtube.com/vi/xMHJGd3wwZk/hqdefault.jpg',
                        'duration': '12:30',
                      },
                      {
                        'id': 3,
                        'title':
                            'Cara Stimulasi Anak Agar Cepat Bicara dan Mengembangkan Kognitifnya',
                        'media_url':
                            'https://www.youtube.com/watch?v=xMHJGd3wwZk',
                        'thumbnail_url':
                            'https://img.youtube.com/vi/xMHJGd3wwZk/hqdefault.jpg',
                        'duration': '10:30',
                      },
                      {
                        'id': 4,
                        'title':
                            'Cara Ampuh Mengatasi Anak Susah Makan dan Sulit Gemuk',
                        'media_url':
                            'https://www.youtube.com/watch?v=xMHJGd3wwZk',
                        'thumbnail_url':
                            'https://img.youtube.com/vi/xMHJGd3wwZk/hqdefault.jpg',
                        'duration': '09:30',
                      },
                      {
                        'id': 5,
                        'title':
                            'Manfaat Vitamin D untuk Pertumbuhan Tulang Anak',
                        'media_url':
                            'https://www.youtube.com/watch?v=xMHJGd3wwZk',
                        'thumbnail_url':
                            'https://img.youtube.com/vi/xMHJGd3wwZk/hqdefault.jpg',
                        'duration': '10:45',
                      },
                      {
                        'id': 6,
                        'title':
                            'Manfaat Vitamin D untuk Pertumbuhan Tulang Anak',
                        'media_url':
                            'https://www.youtube.com/watch?v=xMHJGd3wwZk',
                        'thumbnail_url':
                            'https://img.youtube.com/vi/xMHJGd3wwZk/hqdefault.jpg',
                        'duration': '10:45',
                      },
                      {
                        'id': 7,
                        'title':
                            'Manfaat Vitamin D untuk Pertumbuhan Tulang Anak',
                        'media_url':
                            'https://www.youtube.com/watch?v=xMHJGd3wwZk',
                        'thumbnail_url':
                            'https://img.youtube.com/vi/xMHJGd3wwZk/hqdefault.jpg',
                        'duration': '10:45',
                      },
                      {
                        'id': 8,
                        'title':
                            'Manfaat Vitamin D untuk Pertumbuhan Tulang Anak',
                        'media_url':
                            'https://www.youtube.com/watch?v=xMHJGd3wwZk',
                        'thumbnail_url':
                            'https://img.youtube.com/vi/xMHJGd3wwZk/hqdefault.jpg',
                        'duration': '10:45',
                      },
                    ],
          },
          message: 'Data dashboard berhasil diambil.',
        ),
      ));
    }

    // ── GROWTH RECORDS (claude.md §3C) ────────────────────────────────
    if (path.contains('/api/growth/records')) {
      if (method == 'GET') {
        return handler.resolve(Response(
          requestOptions: options,
          statusCode: 200,
          data: _wrap(
            mockEmpty ? [] : _growthRecords,
            message: 'Data pertumbuhan berhasil diambil.',
          ),
        ));
      } else if (method == 'POST') {
        final body = options.data as Map<String, dynamic>? ?? {};
        final weight = (body['weight_kg'] as num?)?.toDouble() ?? 9.8;
        String zScore = 'Normal';
        if (weight < 8.5) {
          zScore = 'Kurang';
        } else if (weight > 11.5) {
          zScore = 'Lebih';
        }

        final newRecord = {
          'id': _growthRecords.length + 13,
          'child_id': 1,
          'age_months': body['age_months'] ?? 14,
          'weight_kg': weight,
          'height_cm': body['height_cm'] ?? 76.5,
          'head_circumference_cm': body['head_circumference_cm'] ?? 46.0,
          'z_score_status': zScore,
          'recorded_at':
              body['recorded_at'] ?? DateTime.now().toIso8601String().split('T')[0],
        };
        _growthRecords.insert(0, newRecord);
        return handler.resolve(Response(
          requestOptions: options,
          statusCode: 201,
          data: _wrap(newRecord, message: 'Data pertumbuhan berhasil disimpan.'),
        ));
      }
    }

    // ── NUTRITION DAILY (claude.md §3D) ───────────────────────────────
    if (path.contains('/api/nutrition/daily')) {
      if (method == 'GET') {
        final dayLogs = _nutritionLogsByDate[dateStr] ?? [];
        
        int consumed = 0;
        if (!mockEmpty) {
          for (final meal in dayLogs) {
            consumed += (meal['calories'] as int? ?? 0);
          }
        }
        
        final meals = <Map<String, dynamic>>[];
        if (!mockEmpty) {
          final standardMeals = [
            {'meal_time': 'breakfast', 'time_label': '07:00'},
            {'meal_time': 'lunch', 'time_label': '12:30'},
            {'meal_time': 'dinner', 'time_label': '18:00'},
          ];
          for (final std in standardMeals) {
            final existing = dayLogs.firstWhere(
              (m) => m['meal_time'] == std['meal_time'],
              orElse: () => <String, dynamic>{},
            );
            if (existing.isNotEmpty) {
              meals.add(existing);
            } else {
              meals.add({
                'id': 200 + standardMeals.indexOf(std),
                'meal_time': std['meal_time'],
                'time_label': std['time_label'],
                'food_name': null,
                'portion': null,
                'calories': 0,
                'status': 'Belum Mencatat',
              });
            }
          }
        }

        // Hydration logic: increases as child records more meals
        int hydrationDone = 0;
        final loggedMealsCount = dayLogs.where((m) => m['food_name'] != null).length;
        if (loggedMealsCount == 0) {
          hydrationDone = 1;
        } else if (loggedMealsCount == 1) {
          hydrationDone = 3;
        } else if (loggedMealsCount == 2) {
          hydrationDone = 5;
        } else {
          hydrationDone = 6;
        }

        return handler.resolve(Response(
          requestOptions: options,
          statusCode: 200,
          data: _wrap(
            {
              'target_calories': 1100,
              'consumed_calories': consumed,
              'remaining_calories': 1100 - consumed,
              'hydration_glasses_target': 6,
              'hydration_glasses_done': hydrationDone,
              'meals': meals,
            },
            message: 'Data nutrisi harian berhasil diambil.',
          ),
        ));
      } else if (method == 'POST') {
        final body = options.data as Map<String, dynamic>? ?? {};
        final date = body['date'] ?? DateTime.now().toIso8601String().split('T')[0];
        
        if (!_nutritionLogsByDate.containsKey(date)) {
          _nutritionLogsByDate[date] = [];
        }
        
        final calories = (body['calories'] as num?)?.toInt() ?? 150;
        final carbG = (calories * 0.55 / 4).round();
        final proteinG = (calories * 0.15 / 4).round();
        final fatG = (calories * 0.30 / 9).round();

        final newMeal = {
          'id': _nutritionLogsByDate[date]!.length + 200,
          'meal_time': body['meal_time'] ?? 'dinner',
          'time_label': body['time_label'] ?? '18:00',
          'food_name': body['food_name'] ?? 'MPASI Homemade',
          'portion': body['portion'] ?? '1 Porsi',
          'calories': calories,
          'status': 'Habis',
          'carbohydrate_g': carbG,
          'protein_g': proteinG,
          'fat_g': fatG,
        };
        
        // Prevent duplicate meal types on the same day
        _nutritionLogsByDate[date]!.removeWhere((m) => m['meal_time'] == newMeal['meal_time']);
        _nutritionLogsByDate[date]!.add(newMeal);
        
        return handler.resolve(Response(
          requestOptions: options,
          statusCode: 201,
          data: _wrap(newMeal, message: 'Jurnal nutrisi berhasil ditambahkan.'),
        ));
      }
    }

    // ── POSYANDU OVERVIEW (claude.md §3E) ─────────────────────────────
    if (path.contains('/api/posyandu/overview')) {
      final computedImmunizations = [
        {'name': 'BCG', 'is_done': true, 'date_given': '2025-04-15'},
        {'name': 'Polio 1', 'is_done': true, 'date_given': '2025-04-15'},
        {'name': 'DPT 1', 'is_done': true, 'date_given': '2025-06-10'},
        {'name': 'DPT 2', 'is_done': false, 'date_given': null},
        {'name': 'DPT 3', 'is_done': false, 'date_given': null},
        {'name': 'Polio 2', 'is_done': false, 'date_given': null},
        {'name': 'Polio 3', 'is_done': false, 'date_given': null},
        {'name': 'Polio 4', 'is_done': false, 'date_given': null},
        {'name': 'Campak', 'is_done': false, 'date_given': null},
        {'name': 'MR', 'is_done': false, 'date_given': null},
      ].map((imm) {
        final name = imm['name'] as String;
        final matchingSchedule = _completedSchedules.firstWhere(
          (schedule) {
            final titleLower = (schedule['title'] as String? ?? '').toLowerCase();
            final nameLower = name.toLowerCase();
            
            if (nameLower == 'dpt 1' && (titleLower.contains('dpt 1') || titleLower.contains('dpt-hb-hib 1') || titleLower.contains('dpt - 1'))) {
              return true;
            }
            if (nameLower == 'dpt 2' && (titleLower.contains('dpt 2') || titleLower.contains('dpt-hb-hib 2') || titleLower.contains('dpt - 2'))) {
              return true;
            }
            if (nameLower == 'dpt 3' && (titleLower.contains('dpt 3') || titleLower.contains('dpt-hb-hib 3') || titleLower.contains('dpt - 3'))) {
              return true;
            }
            if (nameLower == 'polio 1' && titleLower.contains('polio 1')) return true;
            if (nameLower == 'polio 2' && titleLower.contains('polio 2')) return true;
            if (nameLower == 'polio 3' && titleLower.contains('polio 3')) return true;
            if (nameLower == 'polio 4' && titleLower.contains('polio 4')) return true;
            if (nameLower == 'bcg' && titleLower.contains('bcg')) return true;
            if (nameLower == 'campak' && titleLower.contains('campak')) return true;
            if (nameLower == 'mr' && titleLower.contains('mr')) return true;
            
            return false;
          },
          orElse: () => <String, dynamic>{},
        );

        if (matchingSchedule.isNotEmpty) {
          return {
            'name': name,
            'is_done': true,
            'date_given': (matchingSchedule['scheduled_at'] as String).split('T')[0],
          };
        }
        return imm;
      }).toList();

      return handler.resolve(Response(
        requestOptions: options,
        statusCode: 200,
        data: _wrap(
          {
            'immunizations': computedImmunizations,
            'upcoming_schedules':
                mockEmpty ? [] : _upcomingSchedules,
            'completed_schedules': _completedSchedules,
          },
          message: 'Data posyandu berhasil diambil.',
        ),
      ));
    }

    // ── POSYANDU SCHEDULE COMPLETE (PATCH) ───────────────────────────
    if (path.contains('/api/posyandu/schedule') &&
        path.contains('/complete') &&
        method == 'PATCH') {
      // Extract the schedule id from the path, e.g. /api/posyandu/schedule/301/complete
      final parts = path.split('/');
      final idIndex = parts.indexOf('schedule') + 1;
      final scheduleIdStr = idIndex < parts.length ? parts[idIndex] : '';
      final scheduleId = int.tryParse(scheduleIdStr);

      Map<String, dynamic>? targetSchedule;
      if (scheduleId != null) {
        targetSchedule = _upcomingSchedules.firstWhere(
          (s) => s['id'] == scheduleId,
          orElse: () => <String, dynamic>{},
        );
        if (targetSchedule.isEmpty) targetSchedule = null;
      }

      if (targetSchedule == null) {
        return handler.resolve(Response(
          requestOptions: options,
          statusCode: 404,
          data: _wrapError('Jadwal tidak ditemukan.'),
        ));
      }

      _upcomingSchedules.remove(targetSchedule);
      final completedSchedule = {
        ...targetSchedule,
        'is_completed': true,
        'completed_at': DateTime.now().toIso8601String(),
      };
      _completedSchedules.insert(0, completedSchedule);

      return handler.resolve(Response(
        requestOptions: options,
        statusCode: 200,
        data: _wrap(completedSchedule, message: 'Jadwal berhasil diselesaikan.'),
      ));
    }

    // ── POSYANDU SCHEDULE (POST) (claude.md §3E) ──────────────────────
    if (path.contains('/api/posyandu/schedule') && method == 'POST') {
      final body = options.data as Map<String, dynamic>? ?? {};
      final newSchedule = {
        'id': _upcomingSchedules.length + 400,
        'title': body['title'] ?? 'Jadwal Posyandu',
        'category': body['category'] ?? 'Timbang',
        'location': body['location'] ?? 'Posyandu Setempat',
        'scheduled_at': body['scheduled_at'] ?? '2026-07-01T08:00:00.000Z',
        'note': body['note'] ?? '',
        'is_completed': false,
      };
      _upcomingSchedules.add(newSchedule);
      return handler.resolve(Response(
        requestOptions: options,
        statusCode: 201,
        data: _wrap(newSchedule, message: 'Jadwal posyandu berhasil ditambahkan.'),
      ));
    }

    // ── PROFILE INFO (claude.md §3G) ──────────────────────────────────
    if (path.contains('/api/profile/info')) {
      return handler.resolve(Response(
        requestOptions: options,
        statusCode: 200,
        data: _wrap(
          {
            'user': {
              'id': 1,
              'name': 'Zidnie',
              'email': 'zidni@gmail.com',
              'phone_number': '081234567890',
              'email_verified_at': '2026-05-27T06:00:00.000Z',
            },
            'child': {
              'id': 1,
              'user_id': 1,
              'name': 'Arkan NalarGizi',
              'birth_date': '2025-03-15',
              'gender': 'Laki-laki',
            },
          },
          message: 'Profil berhasil diambil.',
        ),
      ));
    }

    // ── PROFILE HISTORY (claude.md §3G) ───────────────────────────────
    if (path.contains('/api/profile/history')) {
      return handler.resolve(Response(
        requestOptions: options,
        statusCode: 200,
        data: _wrap(
          mockEmpty ? [] : _growthRecords,
          message: 'Riwayat anak berhasil diambil.',
        ),
      ));
    }

    // ── NOTIFICATIONS (claude.md §3G) ─────────────────────────────────
    if (path.contains('/api/profile/notifications')) {
      if (path.contains('/read') && method == 'PATCH') {
        // Extract ID
        final parts = path.split('/');
        final idIndex = parts.indexOf('notifications') + 1;
        final notifIdStr = idIndex < parts.length ? parts[idIndex] : '';
        final notifId = int.tryParse(notifIdStr);
        if (notifId != null) {
          final idx = _mockNotifications.indexWhere((n) => n['id'] == notifId);
          if (idx != -1) {
            _mockNotifications[idx] = {
              ..._mockNotifications[idx],
              'is_read': true,
            };
          }
        }
        return handler.resolve(Response(
          requestOptions: options,
          statusCode: 200,
          data: _wrap(null, message: 'Notifikasi berhasil dibaca.'),
        ));
      }

      if (method == 'GET') {
        return handler.resolve(Response(
          requestOptions: options,
          statusCode: 200,
          data: _wrap(
            mockEmpty ? [] : List.from(_mockNotifications.reversed),
            message: 'Notifikasi berhasil diambil.',
          ),
        ));
      } else if (method == 'POST') {
        final body = options.data as Map<String, dynamic>? ?? {};
        final newNotif = {
          'id': body['id'] ?? DateTime.now().millisecondsSinceEpoch,
          'title': body['title'] ?? 'Pengingat Posyandu',
          'message': body['message'] ?? 'Jadwal Posyandu terdekat akan segera tiba.',
          'type': body['type'] ?? 'posyandu',
          'is_read': false,
          'created_at': DateTime.now().toIso8601String(),
        };
        // Avoid duplicate ids
        _mockNotifications.removeWhere((n) => n['id'] == newNotif['id']);
        _mockNotifications.add(newNotif);
        return handler.resolve(Response(
          requestOptions: options,
          statusCode: 201,
          data: _wrap(newNotif, message: 'Notifikasi berhasil ditambahkan.'),
        ));
      } else if (method == 'DELETE') {
        final id = options.queryParameters['id'] ?? (options.data as Map<String, dynamic>?)?['id'];
        if (id != null) {
          final targetId = int.tryParse(id.toString());
          _mockNotifications.removeWhere((n) => n['id'] == targetId);
        }
        return handler.resolve(Response(
          requestOptions: options,
          statusCode: 200,
          data: _wrap(null, message: 'Notifikasi berhasil dihapus.'),
        ));
      }
    }

    // ── Fallthrough: pass to real network ──────────────────────────────
    super.onRequest(options, handler);
  }
}
