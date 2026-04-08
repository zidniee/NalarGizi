import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nalargizi/app/layout/main_layout.dart';
import 'package:nalargizi/core/network/api_client.dart';
import 'package:nalargizi/features/posyandu/data/datasources/posyandu_remote_data_source.dart';
import 'package:nalargizi/features/posyandu/data/repositories/posyandu_repository_impl.dart';
import 'package:nalargizi/features/posyandu/domain/entities/immunization_item_entity.dart';
import 'package:nalargizi/features/posyandu/domain/entities/posyandu_schedule_item_entity.dart';
import 'package:nalargizi/features/posyandu/domain/usecases/get_posyandu_data_usecase.dart';
import 'package:nalargizi/features/posyandu/presentation/bloc/posyandu_cubit.dart';
import 'package:nalargizi/features/posyandu/presentation/bloc/posyandu_state.dart';
import 'package:nalargizi/features/posyandu/presentation/widgets/akan_datang_section.dart';
import 'package:nalargizi/features/posyandu/presentation/widgets/immunization_status_card.dart';
import 'package:nalargizi/features/posyandu/presentation/widgets/posyandu_header.dart';
import 'package:nalargizi/features/posyandu/presentation/widgets/riwayat_selesai_section.dart';

class PosyanduPage extends StatefulWidget {
  const PosyanduPage({super.key});

  @override
  State<PosyanduPage> createState() => _PosyanduPageState();
}

class _PosyanduPageState extends State<PosyanduPage> {
  late final PosyanduCubit _cubit;

  List<PosyanduScheduleItemEntity> _upcomingItems = [];
  List<PosyanduScheduleItemEntity> _historyItems = [];
  List<ImmunizationItemEntity> _immunizations = [];
  bool _seededFromApi = false;

  @override
  void initState() {
    super.initState();

    final dio = ApiClient().dio;
    final remoteDataSource = PosyanduRemoteDataSource(dio);
    final repository = PosyanduRepositoryImpl(remoteDataSource);
    final useCase = GetPosyanduDataUseCase(repository);
    _cubit = PosyanduCubit(useCase)..load();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _seedLocalData(PosyanduState state) {
    if (_seededFromApi ||
        state.status != PosyanduStatus.success ||
        state.data == null) {
      return;
    }

    setState(() {
      _upcomingItems = List<PosyanduScheduleItemEntity>.from(
        state.upcomingSchedules,
      );
      _historyItems = List<PosyanduScheduleItemEntity>.from(
        state.completedSchedules,
      );
      _immunizations = List<ImmunizationItemEntity>.from(state.immunizations);
      _seededFromApi = true;
    });
  }

  void _addUpcomingEvent(PosyanduScheduleItemEntity item) {
    setState(() {
      _upcomingItems.insert(0, item);
    });
  }

  void _markAsCompleted(PosyanduScheduleItemEntity item) {
    final updatedItem = item.copyWith(isCompleted: true);

    setState(() {
      _upcomingItems.remove(item);
      _historyItems.insert(0, updatedItem);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item.title} dipindahkan ke riwayat selesai.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocConsumer<PosyanduCubit, PosyanduState>(
        listener: (context, state) {
          _seedLocalData(state);
        },
        builder: (context, state) {
          final showInitialLoader =
              state.status == PosyanduStatus.loading && !_seededFromApi;
          final bottomMenuClearance =
              MediaQuery.paddingOf(context).bottom + 128;

          return MainLayout(
            initialIndex: 4,
            child: ColoredBox(
              color: const Color(0xFFF1F5F9),
              child: showInitialLoader
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      padding: EdgeInsets.only(bottom: bottomMenuClearance),
                      children: [
                        PosyanduHeader(
                          upcomingCount: _upcomingItems.length,
                          completedCount: _historyItems.length,
                          immunizationDoneCount: _immunizations
                              .where((item) => item.isDone)
                              .length,
                        ),
                        const SizedBox(height: 14),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ImmunizationStatusCard(items: _immunizations),
                              if (state.status == PosyanduStatus.failure) ...[
                                const SizedBox(height: 12),
                                _ErrorBanner(
                                  message: state.message,
                                  onRetry: _cubit.load,
                                ),
                              ],
                              const SizedBox(height: 24),
                              AkanDatangSection(
                                items: _upcomingItems,
                                onAddEvent: _addUpcomingEvent,
                                onMarkCompleted: _markAsCompleted,
                              ),
                              const SizedBox(height: 24),
                              RiwayatSelesaiSection(items: _historyItems),
                              const SizedBox(height: 24),
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
