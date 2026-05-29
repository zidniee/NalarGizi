import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import 'package:nalargizi/core/di/injection.dart';
import 'package:nalargizi/core/network/api_endpoints.dart';
import 'package:nalargizi/features/growth/domain/usecases/add_growth_record_usecase.dart';
import 'package:nalargizi/features/growth/presentation/cubit/growth_cubit.dart';
import 'package:nalargizi/features/nutrition/domain/usecases/add_meal_log_usecase.dart';
import 'package:nalargizi/features/nutrition/presentation/cubit/nutrition_cubit.dart';
import 'package:nalargizi/features/posyandu/presentation/bloc/posyandu_cubit.dart';
import 'package:nalargizi/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:nalargizi/features/posyandu/presentation/widgets/akan_datang_section.dart';
import 'package:nalargizi/features/posyandu/domain/entities/posyandu_schedule_item_entity.dart';

class QuickAddBottomSheet extends StatelessWidget {
  const QuickAddBottomSheet({super.key});

  static Future<bool?> showGrowthForm(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _GrowthFormSheet(),
    );
  }

  static Future<bool?> showNutritionForm(BuildContext context, {String? initialMealTime}) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _NutritionFormSheet(initialMealTime: initialMealTime),
    );
  }

  static Future<bool?> showPosyanduForm(BuildContext context) async {
    final newItem = await showModalBottomSheet<PosyanduScheduleItemEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddEventSheet(categories: AkanDatangSection.categories),
    );

    if (newItem != null) {
      try {
        final dio = getIt<Dio>();
        final dateStr = newItem.scheduledAt.toUtc().toIso8601String();
        final response = await dio.post(
          ApiEndpoints.posyanduSchedule,
          data: {
            'title': newItem.title,
            'category': newItem.category,
            'location': newItem.location,
            'scheduled_at': dateStr,
            'note': newItem.note ?? '',
          },
        );

        final dataMap = response.data as Map<String, dynamic>;
        final success = dataMap['success'] as bool? ?? false;

        if (success) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Jadwal posyandu berhasil ditambahkan!'),
                backgroundColor: Colors.green,
              ),
            );
          }
          return true;
        }
      } catch (e) {
        debugPrint('Error saving posyandu schedule: $e');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menyimpan ke server: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle indicator
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            // Judul dan Tombol Silang (X)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tambah Data Baru',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Pilih jenis data yang ingin dicatat',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    shape: const CircleBorder(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Tombol 1: Catat Berat & Tinggi
            _buildMenuCard(
              context,
              title: 'Catat Berat & Tinggi',
              subtitle: 'Update data pertumbuhan bulan ini',
              icon: Icons.scale_outlined,
              iconColor: const Color(0xFFF43F5E), // Rose / Red
              bgColor: const Color(0xFFFFF1F2), // Rose light
            ),
            const SizedBox(height: 12),

            // Tombol 2: Jurnal Nutrisi Harian
            _buildMenuCard(
              context,
              title: 'Jurnal Nutrisi Harian',
              subtitle: 'Catat menu makanan (MPASI) anak',
              icon: Icons.restaurant_menu,
              iconColor: const Color(0xFFF97316), // Orange
              bgColor: const Color(0xFFFFF7ED), // Orange light
            ),
            const SizedBox(height: 12),

            // Tombol 3: Jadwal Posyandu Baru
            _buildMenuCard(
              context,
              title: 'Jadwal Posyandu Baru',
              subtitle: 'Buat pengingat imunisasi/timbang',
              icon: Icons.calendar_today,
              iconColor: const Color(0xFF6366F1), // Indigo
              bgColor: const Color(0xFFEEF2FF), // Indigo light
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    return InkWell(
      onTap: () async {
        Navigator.pop(context); // Close selection sheet first
        if (title == 'Catat Berat & Tinggi') {
          final success = await showGrowthForm(context);
          if (success == true && context.mounted) {
            try {
              context.read<GrowthCubit>().loadRecords();
            } catch (_) {}
            try {
              context.read<DashboardCubit>().loadOverview();
            } catch (_) {}
          }
        } else if (title == 'Jurnal Nutrisi Harian') {
          final success = await showNutritionForm(context);
          if (success == true && context.mounted) {
            try {
              context.read<NutritionCubit>().loadDailyNutrition();
            } catch (_) {}
            try {
              context.read<DashboardCubit>().loadOverview();
            } catch (_) {}
          }
        } else if (title == 'Jadwal Posyandu Baru') {
          final success = await showPosyanduForm(context);
          if (success == true && context.mounted) {
            try {
              context.read<PosyanduCubit>().load();
            } catch (_) {}
            try {
              context.read<DashboardCubit>().loadOverview();
            } catch (_) {}
          }
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: iconColor.withOpacity(0.15)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: iconColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: iconColor.withOpacity(0.85),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: iconColor.withOpacity(0.6),
            ),
          ],
        ),
      ),
    );
  }
}

// ── HELPER WIDGETS ─────────────────────────────────────────────────────────

class _FormLabel extends StatelessWidget {
  final String label;
  final bool isRequired;

  const _FormLabel({
    required this.label,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF334155),
            ),
          ),
          if (isRequired)
            const Text(
              ' *',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  final String value;
  final String hint;
  final IconData icon;
  final Color themeColor;
  final VoidCallback onTap;

  const _PickerField({
    required this.value,
    required this.hint,
    required this.icon,
    required this.themeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isEmpty = value.isEmpty;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Icon(icon, color: isEmpty ? const Color(0xFF94A3B8) : themeColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                isEmpty ? hint : value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isEmpty ? FontWeight.normal : FontWeight.w500,
                  color: isEmpty ? const Color(0xFF94A3B8) : const Color(0xFF1E293B),
                ),
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Color(0xFF64748B), size: 20),
          ],
        ),
      ),
    );
  }
}

InputDecoration _getInputDecoration({
  required String hintText,
  required IconData prefixIcon,
  required Color themeColor,
  String? suffixText,
}) {
  return InputDecoration(
    hintText: hintText,
    suffixText: suffixText,
    prefixIcon: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Icon(prefixIcon, size: 20, color: const Color(0xFF64748B)),
    ),
    prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 0),
    suffixStyle: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF475569)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    filled: true,
    fillColor: const Color(0xFFF8FAFC),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: themeColor, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Colors.red, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Colors.red, width: 2),
    ),
  );
}

// ── FORM SHEETS ────────────────────────────────────────────────────────────

class _GrowthFormSheet extends StatefulWidget {
  const _GrowthFormSheet();

  @override
  State<_GrowthFormSheet> createState() => _GrowthFormSheetState();
}

class _GrowthFormSheetState extends State<_GrowthFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _headController = TextEditingController();
  final _ageController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  final Color _themeColor = const Color(0xFFF43F5E); // Growth Rose Color
  final Color _bgColor = const Color(0xFFFFF1F2);

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _headController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final weight = double.parse(_weightController.text);
      final height = double.parse(_heightController.text);
      final head = double.parse(_headController.text);
      final age = int.parse(_ageController.text);
      final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);

      final addUseCase = getIt<AddGrowthRecordUseCase>();
      final result = await addUseCase({
        'child_id': 1,
        'age_months': age,
        'weight_kg': weight,
        'height_cm': height,
        'head_circumference_cm': head,
        'recorded_at': dateStr,
      });

      if (result.failure != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menyimpan: ${result.failure!.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data pertumbuhan berhasil disimpan!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle indicator
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Title Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _bgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.scale_rounded, color: _themeColor, size: 24),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Catat Berat & Tinggi',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          'Update tumbuh kembang si kecil',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      shape: const CircleBorder(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Form fields wrapped in scroll view
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _FormLabel(label: 'Usia Anak (Bulan)', isRequired: true),
                      TextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        decoration: _getInputDecoration(
                          hintText: 'Masukkan usia anak',
                          prefixIcon: Icons.child_care_rounded,
                          themeColor: _themeColor,
                          suffixText: 'bulan',
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Usia anak tidak boleh kosong';
                          if (int.tryParse(v) == null) return 'Usia anak harus berupa angka bulat';
                          return null;
                        },
                      ),

                      const _FormLabel(label: 'Berat Badan (kg)', isRequired: true),
                      TextFormField(
                        controller: _weightController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: _getInputDecoration(
                          hintText: 'Contoh: 9.8',
                          prefixIcon: Icons.monitor_weight_outlined,
                          themeColor: _themeColor,
                          suffixText: 'kg',
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Berat badan tidak boleh kosong';
                          if (double.tryParse(v) == null) return 'Berat badan harus berupa angka desimal';
                          return null;
                        },
                      ),

                      const _FormLabel(label: 'Tinggi Badan (cm)', isRequired: true),
                      TextFormField(
                        controller: _heightController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: _getInputDecoration(
                          hintText: 'Contoh: 76.5',
                          prefixIcon: Icons.height_rounded,
                          themeColor: _themeColor,
                          suffixText: 'cm',
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Tinggi badan tidak boleh kosong';
                          if (double.tryParse(v) == null) return 'Tinggi badan harus berupa angka desimal';
                          return null;
                        },
                      ),

                      const _FormLabel(label: 'Lingkar Kepala (cm)', isRequired: true),
                      TextFormField(
                        controller: _headController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: _getInputDecoration(
                          hintText: 'Contoh: 46.0',
                          prefixIcon: Icons.face_rounded,
                          themeColor: _themeColor,
                          suffixText: 'cm',
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Lingkar kepala tidak boleh kosong';
                          if (double.tryParse(v) == null) return 'Lingkar kepala harus berupa angka desimal';
                          return null;
                        },
                      ),

                      const _FormLabel(label: 'Tanggal Pencatatan', isRequired: true),
                      _PickerField(
                        value: DateFormat('dd MMMM yyyy').format(_selectedDate),
                        hint: 'Pilih Tanggal',
                        icon: Icons.calendar_today_rounded,
                        themeColor: _themeColor,
                        onTap: () => _selectDate(context),
                      ),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _themeColor,
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shadowColor: _themeColor.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle_outline, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Simpan Data',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NutritionFormSheet extends StatefulWidget {
  final String? initialMealTime;
  const _NutritionFormSheet({this.initialMealTime});

  @override
  State<_NutritionFormSheet> createState() => _NutritionFormSheetState();
}

class _NutritionFormSheetState extends State<_NutritionFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _foodNameController = TextEditingController();
  final _portionController = TextEditingController(text: '1 Porsi');
  final _caloriesController = TextEditingController(text: '150');
  
  String _mealTime = 'breakfast';
  String _status = 'Habis';
  bool _isLoading = false;

  final Color _themeColor = const Color(0xFFF97316); // Nutrition Orange Color
  final Color _bgColor = const Color(0xFFFFF7ED);

  @override
  void initState() {
    super.initState();
    if (widget.initialMealTime != null) {
      _mealTime = widget.initialMealTime!;
    }
  }

  @override
  void dispose() {
    _foodNameController.dispose();
    _portionController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  String _getMealTimeLabel(String value) {
    switch (value) {
      case 'breakfast':
        return '07:00';
      case 'lunch':
        return '12:30';
      case 'dinner':
        return '18:00';
      case 'snack':
        return '15:30';
      default:
        return '07:00';
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final foodName = _foodNameController.text;
      final portion = _portionController.text;
      final calories = int.parse(_caloriesController.text);
      final timeLabel = _getMealTimeLabel(_mealTime);

      final addUseCase = getIt<AddMealLogUseCase>();
      final result = await addUseCase(
        childId: 1,
        mealTime: _mealTime,
        timeLabel: timeLabel,
        foodName: foodName,
        portion: portion,
        calories: calories,
        status: _status,
      );

      if (result.failure != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menyimpan: ${result.failure!.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Jurnal nutrisi berhasil ditambahkan!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle indicator
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Title Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _bgColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.restaurant_menu_rounded, color: _themeColor, size: 24),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jurnal Nutrisi Harian',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        Text(
                          'Catat asupan nutrisi makanan anak',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      shape: const CircleBorder(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Form fields wrapped in scroll view
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _FormLabel(label: 'Waktu Makan', isRequired: true),
                      DropdownMenu<String>(
                        initialSelection: _mealTime,
                        enableSearch: true,
                        enableFilter: true,
                        expandedInsets: EdgeInsets.zero,
                        inputDecorationTheme: InputDecorationTheme(
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: _themeColor, width: 2),
                          ),
                        ),
                        dropdownMenuEntries: const [
                          DropdownMenuEntry(value: 'breakfast', label: 'Makan Pagi (07:00)'),
                          DropdownMenuEntry(value: 'lunch', label: 'Makan Siang (12:30)'),
                          DropdownMenuEntry(value: 'dinner', label: 'Makan Malam (18:00)'),
                          DropdownMenuEntry(value: 'snack', label: 'Camilan (15:30)'),
                        ],
                        onSelected: (v) {
                          if (v != null) {
                            setState(() {
                              _mealTime = v;
                            });
                          }
                        },
                      ),

                      const _FormLabel(label: 'Nama Makanan', isRequired: true),
                      TextFormField(
                        controller: _foodNameController,
                        decoration: _getInputDecoration(
                          hintText: 'Contoh: Bubur Tim Ayam & Wortel',
                          prefixIcon: Icons.breakfast_dining_rounded,
                          themeColor: _themeColor,
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Nama makanan tidak boleh kosong';
                          return null;
                        },
                      ),

                      const _FormLabel(label: 'Ukuran Porsi', isRequired: true),
                      TextFormField(
                        controller: _portionController,
                        decoration: _getInputDecoration(
                          hintText: 'Contoh: 1 Porsi, 1/2 Porsi',
                          prefixIcon: Icons.room_service_rounded,
                          themeColor: _themeColor,
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Ukuran porsi tidak boleh kosong';
                          return null;
                        },
                      ),

                      const _FormLabel(label: 'Estimasi Kalori (kcal)', isRequired: true),
                      TextFormField(
                        controller: _caloriesController,
                        keyboardType: TextInputType.number,
                        decoration: _getInputDecoration(
                          hintText: 'Contoh: 150',
                          prefixIcon: Icons.local_fire_department_rounded,
                          themeColor: _themeColor,
                          suffixText: 'kcal',
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Estimasi kalori tidak boleh kosong';
                          if (int.tryParse(v) == null) return 'Estimasi kalori harus berupa angka bulat';
                          return null;
                        },
                      ),

                      const _FormLabel(label: 'Status Konsumsi', isRequired: true),
                      DropdownMenu<String>(
                        initialSelection: _status,
                        enableSearch: true,
                        enableFilter: true,
                        expandedInsets: EdgeInsets.zero,
                        inputDecorationTheme: InputDecorationTheme(
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: _themeColor, width: 2),
                          ),
                        ),
                        dropdownMenuEntries: const [
                          DropdownMenuEntry(value: 'Habis', label: 'Habis'),
                          DropdownMenuEntry(value: 'Sisa Sedikit', label: 'Sisa Sedikit'),
                          DropdownMenuEntry(value: 'Tidak Habis', label: 'Tidak Habis'),
                        ],
                        onSelected: (v) {
                          if (v != null) {
                            setState(() {
                              _status = v;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _themeColor,
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shadowColor: _themeColor.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.check_circle_outline, size: 20),
                                    SizedBox(width: 8),
                                    Text(
                                      'Simpan Jurnal',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
