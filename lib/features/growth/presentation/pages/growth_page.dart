import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:nalargizi/app/layout/main_layout.dart';
import 'package:nalargizi/features/growth/presentation/cubit/growth_cubit.dart';
import 'package:nalargizi/features/growth/presentation/cubit/growth_state.dart';
import 'package:nalargizi/features/growth/presentation/widgets/pilihan_tipe_kurva.dart';
import 'package:nalargizi/features/growth/presentation/widgets/kartu_pengukuran_terakhir.dart';
import 'package:nalargizi/features/growth/presentation/widgets/kartu_grafik_kurva.dart';
import 'package:nalargizi/features/growth/presentation/widgets/bagian_riwayat_pertumbuhan.dart';
import 'package:nalargizi/features/quick_add/presentation/widgets/quick_add_bottom_sheet.dart';

class GrowthPage extends StatelessWidget {
  const GrowthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<GrowthCubit>()..loadRecords(),
      child: const _GrowthPageView(),
    );
  }
}

class _GrowthPageView extends StatelessWidget {
  const _GrowthPageView();

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      initialIndex: 1, // Mengaktifkan tab Kurva di Bottom Navigation
      child: ColoredBox(
        color: const Color(0xFFF8F9FA),
        child: SafeArea(
          child: BlocBuilder<GrowthCubit, GrowthState>(
            builder: (context, state) {
              final isWeightMode = state.isWeightMode;
              final records = state.records;

              return RefreshIndicator(
                onRefresh: () => context.read<GrowthCubit>().loadRecords(),
                color: const Color(0xFFF43F5E),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(24.0),
                  children: [
                    // --- HEADER ---
                    const Center(
                      child: Column(
                        children: [
                          Text(
                            'Kurva Tumbuh Kembang',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Berdasarkan standar WHO',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    if (state.status == GrowthStatus.loading && records.isEmpty)
                      const SizedBox(
                        height: 300,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFF43F5E),
                          ),
                        ),
                      )
                    else if (state.status == GrowthStatus.failure && records.isEmpty)
                      _ErrorBanner(
                        message: state.message,
                        onRetry: () => context.read<GrowthCubit>().loadRecords(),
                      )
                    else ...[
                      // Display error banner at the top if load fails but we have cached/stale records
                      if (state.status == GrowthStatus.failure) ...[
                        _ErrorBanner(
                          message: state.message,
                          onRetry: () => context.read<GrowthCubit>().loadRecords(),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // --- WIDGET 1: SWITCH BB / TB ---
                      PilihanTipeKurva(
                        isBeratBadan: isWeightMode,
                        onChanged: (value) {
                          context.read<GrowthCubit>().switchMode(isWeightMode: value);
                        },
                      ),
                      const SizedBox(height: 24),

                      // --- WIDGET 2: KARTU PENGUKURAN ---
                      KartuPengukuranTerakhir(
                        records: records,
                        isBeratBadan: isWeightMode,
                      ),
                      const SizedBox(height: 24),

                      // --- WIDGET 3: GRAFIK KURVA ---
                      KartuGrafikKurva(
                        records: records,
                        isBeratBadan: isWeightMode,
                      ),
                      const SizedBox(height: 32),

                      // --- WIDGET 4: RIWAYAT & TOMBOL ---
                      BagianRiwayatPertumbuhan(
                        records: records,
                        isBeratBadan: isWeightMode,
                        onAddPressed: () async {
                          final success = await QuickAddBottomSheet.showGrowthForm(context);
                          if (success == true && context.mounted) {
                            context.read<GrowthCubit>().loadRecords();
                          }
                        },
                      ),
                    ],
                    // --- RUANG NAPAS BAWAH ---
                    const SizedBox(height: 120),
                  ],
                ),
              );
            },
          ),
        ),
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
              message.isNotEmpty ? message : 'Gagal memuat data pertumbuhan.',
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