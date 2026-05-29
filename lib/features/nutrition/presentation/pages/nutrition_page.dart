import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nalargizi/app/layout/main_layout.dart';
import '../cubit/nutrition_cubit.dart';
import '../cubit/nutrition_state.dart';
import '../../domain/entities/nutrition_entity.dart';
import '../widgets/ringkasan_nutrisi_header.dart';
import '../widgets/kartu_progres_nutrisi.dart';
import '../widgets/kartu_menu_makanan.dart';
import 'package:nalargizi/features/quick_add/presentation/widgets/quick_add_bottom_sheet.dart';

/// Halaman Jurnal Nutrisi Harian.
///
/// Source: claude2.md §3 — BlocProvider + GetIt.I<NutritionCubit>()
/// Source: claude1.md §UI RULES — Loading, Success, Failure states
class NutritionPage extends StatelessWidget {
  const NutritionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<NutritionCubit>()..loadDailyNutrition(),
      child: const _NutritionView(),
    );
  }
}

class _NutritionView extends StatelessWidget {
  const _NutritionView();

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      initialIndex: 3, // Mengaktifkan tab Nutrisi di Bottom Navigation
      child: BlocBuilder<NutritionCubit, NutritionState>(
        builder: (context, state) {
          final showInitialLoader = state.status == NutritionStatus.loading && state.dailyData == null;

          return ColoredBox(
            color: const Color(0xFFF8F9FA),
            child: showInitialLoader
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => context.read<NutritionCubit>().loadDailyNutrition(),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        // 1. Header Oren Dinamis
                        RingkasanNutrisiHeader(
                          totalCalories: state.dailyData?.consumedCalories ?? 0,
                          targetCalories: state.dailyData?.targetCalories ?? 1100,
                          remainingCalories: state.dailyData?.remainingCalories ?? 1100,
                          dateLabel: _formatDate(state.selectedDate),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // 2. Tampilkan Error Banner jika terjadi kegagalan
                              if (state.status == NutritionStatus.failure) ...[
                                _ErrorBanner(
                                  message: state.message,
                                  onRetry: () => context
                                      .read<NutritionCubit>()
                                      .loadDailyNutrition(),
                                ),
                                const SizedBox(height: 24),
                              ],

                              // 3. Kartu Progress Nutrisi
                              KartuProgresNutrisi(dailyData: state.dailyData),
                              const SizedBox(height: 32),

                              // 4. SEKSI SARAPAN
                              _buildSectionHeader(Icons.wb_sunny_outlined, 'Sarapan', '07:00', Colors.orange),
                              const SizedBox(height: 12),
                              _buildMealCard(
                                context,
                                state.dailyData?.meals.cast<NutritionMealEntity>().firstWhere(
                                  (m) => m.mealTime == 'breakfast',
                                  orElse: () => const NutritionMealEntity(
                                    id: '',
                                    nutritionJournalId: '',
                                    mealTime: 'breakfast',
                                    timeLabel: '07:00',
                                    calories: 0,
                                    status: 'Belum Mencatat',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              // 5. SEKSI MAKAN SIANG
                              _buildSectionHeader(Icons.star_border, 'Makan Siang', '12:30', Colors.amber),
                              const SizedBox(height: 12),
                              _buildMealCard(
                                context,
                                state.dailyData?.meals.cast<NutritionMealEntity>().firstWhere(
                                  (m) => m.mealTime == 'lunch',
                                  orElse: () => const NutritionMealEntity(
                                    id: '',
                                    nutritionJournalId: '',
                                    mealTime: 'lunch',
                                    timeLabel: '12:30',
                                    calories: 0,
                                    status: 'Belum Mencatat',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              // 6. SEKSI MAKAN MALAM
                              _buildSectionHeader(
                                Icons.nightlight_round_outlined,
                                'Makan Malam',
                                '18:00',
                                Colors.indigo.shade300,
                              ),
                              const SizedBox(height: 12),
                              _buildMealCard(
                                context,
                                state.dailyData?.meals.cast<NutritionMealEntity>().firstWhere(
                                  (m) => m.mealTime == 'dinner',
                                  orElse: () => const NutritionMealEntity(
                                    id: '',
                                    nutritionJournalId: '',
                                    mealTime: 'dinner',
                                    timeLabel: '18:00',
                                    calories: 0,
                                    status: 'Belum Mencatat',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),

                              // 7. KARTU HIDRASI DINAMIS
                              _buildHidrasiCard(
                                glassesDone: state.dailyData?.hydrationGlassesDone ?? 0,
                                glassesTarget: state.dailyData?.hydrationGlassesTarget ?? 6,
                              ),
                              const SizedBox(height: 200),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  // Format YYYY-MM-DD ke label bahasa Indonesia sederhana
  String _formatDate(String dateStr) {
    try {
      final parts = dateStr.split('-');
      if (parts.length != 3) return dateStr;
      
      final months = [
        'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
      ];
      
      final day = int.parse(parts[2]);
      final monthIndex = int.parse(parts[1]) - 1;
      final year = parts[0];
      
      if (monthIndex >= 0 && monthIndex < 12) {
        return '$day ${months[monthIndex]} $year';
      }
    } catch (_) {}
    return dateStr;
  }

  // Widget pembantu untuk judul seksi (Sarapan, dll)
  Widget _buildSectionHeader(IconData icon, String title, String time, Color iconColor) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(width: 8),
        Text(time, style: TextStyle(color: Colors.grey.shade400, fontSize: 14)),
      ],
    );
  }

  // Widget pembantu untuk memetakan NutritionMealEntity ke KartuMenuMakanan
  Widget _buildMealCard(BuildContext context, NutritionMealEntity? meal) {
    if (meal == null || meal.foodName == null || meal.foodName!.isEmpty) {
      String addPlaceholder = 'Belum ada catatan makan';
      String addLabel = 'Tambah Menu';
      
      if (meal != null) {
        if (meal.mealTime == 'breakfast') {
          addPlaceholder = 'Belum ada catatan sarapan';
          addLabel = 'Tambah Menu Sarapan';
        } else if (meal.mealTime == 'lunch') {
          addPlaceholder = 'Belum ada catatan makan siang';
          addLabel = 'Tambah Menu Siang';
        } else if (meal.mealTime == 'dinner') {
          addPlaceholder = 'Belum ada catatan makan malam';
          addLabel = 'Tambah Menu Malam';
        }
      }

      return KartuMenuMakanan(
        isAddMode: true,
        addPlaceholder: addPlaceholder,
        addLabel: addLabel,
        onTap: () async {
          final success = await QuickAddBottomSheet.showNutritionForm(
            context,
            initialMealTime: meal?.mealTime,
          );
          if (success == true && context.mounted) {
            context.read<NutritionCubit>().loadDailyNutrition();
          }
        },
      );
    }

    Color statusColor = Colors.green;
    if (meal.status == 'Sisa Sedikit') {
      statusColor = Colors.amber;
    } else if (meal.status == 'Tidak Habis' || meal.status == 'Belum Mencatat') {
      statusColor = Colors.red;
    }

    return KartuMenuMakanan(
      title: meal.foodName!,
      subtitle: meal.mealTime == 'breakfast' ? 'Protein Hewani, Zat Besi' : 'Karbohidrat, Protein',
      calories: '${meal.calories} kkal',
      statusLabel: meal.status,
      statusColor: statusColor,
    );
  }

  // Widget pembantu untuk kartu Hidrasi biru
  Widget _buildHidrasiCard({required int glassesDone, required int glassesTarget}) {
    final target = glassesTarget > 0 ? glassesTarget : 6;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.water_drop_outlined, color: Colors.blue.shade600),
              const SizedBox(width: 8),
              const Text(
                'Hidrasi Hari Ini',
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A), fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(target, (index) {
              final isFilled = index < glassesDone;
              return Expanded(
                child: Container(
                  height: 32,
                  margin: EdgeInsets.only(right: index < (target - 1) ? 8 : 0),
                  decoration: BoxDecoration(
                    color: isFilled ? Colors.blue.shade400 : Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            '$glassesDone dari $target gelas terpenuhi ✓',
            style: TextStyle(color: Colors.blue.shade700, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFDA4AF)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFE11D48)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFF9F1239),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(onPressed: onRetry, child: const Text('Coba Lagi')),
        ],
      ),
    );
  }
}