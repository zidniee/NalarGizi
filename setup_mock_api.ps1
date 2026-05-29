# PowerShell script to set up Mock API Interceptor for NalarGizi Flutter Client
# Path: setup_mock_api.ps1

Write-Host "=============================================" -ForegroundColor Green
Write-Host "Setting up NalarGizi Mock API Interceptor..." -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

$clientPath = "lib/core/network/api_client.dart"
$interceptorPath = "lib/core/network/mock_interceptor.dart"

# 1. Create mock_interceptor.dart with comprehensive dummy JSON matching the ERD
$interceptorContent = @"
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class MockInterceptor extends Interceptor {
  // In-memory logs for simulation of CRUD operations during session
  final List<Map<String, dynamic>> _growthRecords = [
    {
      'id': 12,
      'child_id': 1,
      'age_months': 14,
      'weight_kg': 9.8,
      'height_cm': 76.5,
      'head_circumference_cm': 46.0,
      'z_score_status': 'Normal',
      'recorded_at': '2026-05-20'
    },
    {
      'id': 11,
      'child_id': 1,
      'age_months': 13,
      'weight_kg': 9.4,
      'height_cm': 75.0,
      'head_circumference_cm': 45.5,
      'z_score_status': 'Normal',
      'recorded_at': '2026-04-18'
    },
    {
      'id': 10,
      'child_id': 1,
      'age_months': 12,
      'weight_kg': 9.1,
      'height_cm': 73.8,
      'head_circumference_cm': 45.0,
      'z_score_status': 'Normal',
      'recorded_at': '2026-03-15'
    }
  ];

  final List<Map<String, dynamic>> _nutritionLogs = [
    {
      'id': 201,
      'meal_time': 'breakfast',
      'time_label': '07:00',
      'food_name': 'Bubur Hati Ayam + Bayam',
      'portion': '1 Porsi',
      'calories': 150,
      'status': 'Habis'
    },
    {
      'id': 202,
      'meal_time': 'lunch',
      'time_label': '12:30',
      'food_name': 'Nasi Tim Telur Puyuh',
      'portion': '1 Porsi',
      'calories': 180,
      'status': 'Sisa Sedikit'
    }
  ];

  final List<Map<String, dynamic>> _upcomingSchedules = [
    {
      'id': 'upcoming-1',
      'title': 'Posyandu Bulanan & Vitamin A',
      'category': 'Vitamin',
      'location': 'Puskesmas Garuda',
      'scheduled_at': '2026-06-05T08:00:00.000Z',
      'note': 'Bawa Buku KIA dan kartu imunisasi',
      'is_completed': false,
    }
  ];

  final List<Map<String, dynamic>> _completedSchedules = [
    {
      'id': 'history-1',
      'title': 'Imunisasi DPT 3',
      'category': 'Imunisasi',
      'location': 'Puskesmas Garuda',
      'scheduled_at': '2026-04-20T08:00:00.000Z',
      'note': 'Kondisi anak sehat',
      'is_completed': true,
    }
  ];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final path = options.path;

    debugPrint('[MockAPI] Intercepted Request: \${options.method} \$path');

    // AUTH LOGIN & REGISTER
    if (path.contains('/api/auth/login') || path.contains('/api/auth/google')) {
      return handler.resolve(Response(
        requestOptions: options,
        statusCode: 200,
        data: {
          'token': 'dummy_jwt_token_for_nalargizi',
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
          }
        },
      ));
    }

    if (path.contains('/api/auth/forgot-password')) {
      return handler.resolve(Response(
        requestOptions: options,
        statusCode: 200,
        data: {'message': 'Link reset password telah dikirim ke email Anda.'},
      ));
    }

    // DASHBOARD OVERVIEW
    if (path.contains('/api/dashboard/overview')) {
      return handler.resolve(Response(
        requestOptions: options,
        statusCode: 200,
        data: {
          'child_info': {
            'name': 'Arkan NalarGizi',
            'age_months': 14,
            'gender': 'Laki-laki',
          },
          'last_growth': {
            'weight_kg': _growthRecords.isNotEmpty ? _growthRecords.first['weight_kg'] : 9.8,
            'height_cm': _growthRecords.isNotEmpty ? _growthRecords.first['height_cm'] : 76.5,
            'z_score_status': 'Normal',
            'recorded_at': '2026-05-20',
          },
          'daily_tip': {
            'title': 'Tips Gizi Normal (Z-Score)',
            'content': 'Status gizi Arkan terpantau normal. Lanjutkan pemberian ASI/MPASI dengan porsi seimbang dan perbanyak protein hewani.',
          },
          'nearest_schedule': _upcomingSchedules.isNotEmpty ? _upcomingSchedules.first : null,
          'posyandu_center': {
            'id': 5,
            'name': 'Posyandu Mawar 1',
            'address': 'Jl. Mawar Merah No. 45, Jakarta Selatan',
            'leader_name': 'Bidan Siti Aminah',
          },
          'educational_contents': [
            {
              'id': 1,
              'title': 'Protein Hewani untuk Stunting',
              'media_url': 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
              'thumbnail_url': 'https://img.youtube.com/vi/dQw4w9WgXcQ/hqdefault.jpg',
              'duration': '08:45',
            }
          ]
        },
      ));
    }

    // GROWTH RECORDS
    if (path.contains('/api/growth/records')) {
      if (options.method == 'GET') {
        return handler.resolve(Response(
          requestOptions: options,
          statusCode: 200,
          data: _growthRecords,
        ));
      } else if (options.method == 'POST') {
        final Map<String, dynamic> body = options.data ?? {};
        final newRecord = {
          'id': _growthRecords.length + 1,
          'child_id': 1,
          'age_months': body['age_months'] ?? 14,
          'weight_kg': body['weight_kg'] ?? 9.8,
          'height_cm': body['height_cm'] ?? 76.5,
          'head_circumference_cm': body['head_circumference_cm'] ?? 46.0,
          'z_score_status': 'Normal',
          'recorded_at': body['recorded_at'] ?? '2026-05-27',
        };
        _growthRecords.insert(0, newRecord);
        return handler.resolve(Response(
          requestOptions: options,
          statusCode: 201,
          data: newRecord,
        ));
      }
    }

    // NUTRITION DAILY
    if (path.contains('/api/nutrition/daily')) {
      if (options.method == 'GET') {
        int consumed = 0;
        for (var meal in _nutritionLogs) {
          consumed += (meal['calories'] as int? ?? 0);
        }
        return handler.resolve(Response(
          requestOptions: options,
          statusCode: 200,
          data: {
            'target_calories': 1100,
            'consumed_calories': consumed,
            'remaining_calories': 1100 - consumed,
            'hydration_glasses_target': 6,
            'hydration_glasses_done': 4,
            'meals': _nutritionLogs,
          },
        ));
      } else if (options.method == 'POST') {
        final Map<String, dynamic> body = options.data ?? {};
        final newMeal = {
          'id': _nutritionLogs.length + 1,
          'meal_time': body['meal_time'] ?? 'dinner',
          'time_label': body['time_label'] ?? '18:00',
          'food_name': body['food_name'] ?? 'MPASI Homemade',
          'portion': body['portion'] ?? '1 Porsi',
          'calories': body['calories'] ?? 150,
          'status': body['status'] ?? 'Habis',
        };
        _nutritionLogs.add(newMeal);
        return handler.resolve(Response(
          requestOptions: options,
          statusCode: 201,
          data: newMeal,
        ));
      }
    }

    // POSYANDU & IMMUNIZATION OVERVIEW
    if (path.contains('/api/posyandu/overview')) {
      return handler.resolve(Response(
        requestOptions: options,
        statusCode: 200,
        data: {
          'immunizations': [
            { 'name': 'BCG', 'is_done': true, 'date_given': '2025-04-15' },
            { 'name': 'Polio 1', 'is_done': true, 'date_given': '2025-04-15' },
            { 'name': 'DPT 1', 'is_done': true, 'date_given': '2025-06-10' },
            { 'name': 'DPT 2', 'is_done': true, 'date_given': '2025-07-15' },
            { 'name': 'DPT 3', 'is_done': false, 'date_given': null },
            { 'name': 'Campak', 'is_done': false, 'date_given': null },
            { 'name': 'MR', 'is_done': false, 'date_given': null }
          ],
          'upcoming_schedules': _upcomingSchedules,
          'completed_schedules': _completedSchedules,
        },
      ));
    }

    // NOTIFICATIONS
    if (path.contains('/api/profile/notifications')) {
      return handler.resolve(Response(
        requestOptions: options,
        statusCode: 200,
        data: [
          {
            'id': 1,
            'title': 'Jadwal Posyandu Terdekat',
            'message': 'Jangan lupa datang ke Posyandu Mawar 1 besok pukul 08:00 untuk Imunisasi Campak Arkan.',
            'type': 'posyandu',
            'is_read': false,
            'created_at': '2026-05-26T18:00:00.000Z'
          },
          {
            'id': 2,
            'title': 'Tips Z-Score Arkan',
            'message': 'Berdasarkan timbangan terakhir, grafik tumbuh kembang Arkan membaik. Lihat tips gizi di sini.',
            'type': 'growth',
            'is_read': true,
            'created_at': '2026-05-20T10:00:00.000Z'
          }
        ],
      ));
    }

    super.onRequest(options, handler);
  }
}
"@

# Write the interceptor file
$interceptorContent | Out-File -FilePath $interceptorPath -Encoding utf8
Write-Host "Created Mock Interceptor at: $interceptorPath" -ForegroundColor Cyan

# 2. Modify api_client.dart to add MockInterceptor
if (Test-Path $clientPath) {
    $clientContent = Get-Content -Path $clientPath -Raw
    
    # Add mock interceptor import if missing
    if ($clientContent -notcontains "mock_interceptor.dart") {
        $importLine = "import 'package:nalargizi/core/network/mock_interceptor.dart';"
        $clientContent = $clientContent.Replace("import 'package:pretty_dio_logger/pretty_dio_logger.dart';", "import 'package:pretty_dio_logger/pretty_dio_logger.dart';`r`n$importLine")
    }

    # Inject MockInterceptor inside kDebugMode interceptors check
    if ($clientContent -notcontains "MockInterceptor()") {
        $injectionCode = "`r`n      _dio.interceptors.add(MockInterceptor());"
        $clientContent = $clientContent.Replace("if (kDebugMode) {", "if (kDebugMode) {$injectionCode")
    }

    $clientContent | Out-File -FilePath $clientPath -Encoding utf8
    Write-Host "Registered MockInterceptor inside $clientPath" -ForegroundColor Cyan
} else {
    Write-Warning "Could not find $clientPath to inject interceptor."
}

Write-Host "Setup Completed! You can now run 'flutter run' and Dio will intercept requests." -ForegroundColor Green
