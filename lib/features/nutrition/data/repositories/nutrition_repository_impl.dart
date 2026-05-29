import 'package:nalargizi/core/error/exceptions.dart';
import 'package:nalargizi/core/error/failures.dart';
import 'package:nalargizi/core/storage/sync_status.dart';
import '../../domain/entities/nutrition_entity.dart';
import '../../domain/repositories/nutrition_repository.dart';
import '../datasources/nutrition_local_data_source.dart';
import '../datasources/nutrition_remote_data_source.dart';
import '../models/nutrition_model.dart';

/// Concrete implementation of [NutritionRepository].
///
/// Source: claude2.md §4 — Cache-Then-Network (Offline First) fallback.
/// Source: claude2.md §2 — Repository catches Exception → Failure.
class NutritionRepositoryImpl implements NutritionRepository {
  const NutritionRepositoryImpl({
    required NutritionRemoteDataSource remoteDataSource,
    required NutritionLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  final NutritionRemoteDataSource _remoteDataSource;
  final NutritionLocalDataSource _localDataSource;

  @override
  Future<({NutritionDailyEntity? data, Failure? failure})> getDailyNutrition({
    required int childId,
    required String date,
  }) async {
    try {
      // 1. Fetch from remote
      final remoteModel = await _remoteDataSource.getDailySummary(
        childId: childId,
        date: date,
      );

      // 2. Save components to local cache on success
      if (remoteModel.journal is NutritionJournalModel) {
        await _localDataSource.saveJournal(
          remoteModel.journal as NutritionJournalModel,
          status: SyncStatus.synced,
        );
      }

      for (final meal in remoteModel.meals) {
        if (meal is NutritionMealModel) {
          await _localDataSource.saveMeal(
            meal,
            status: SyncStatus.synced,
          );
        }
      }

      if (remoteModel.hydration is HydrationLogModel) {
        await _localDataSource.saveHydration(
          remoteModel.hydration as HydrationLogModel,
          status: SyncStatus.synced,
        );
      }

      return (data: remoteModel, failure: null);
    } on ServerException catch (e) {
      // 3. Fallback: try loading from Hive
      try {
        final childStr = childId.toString();
        final journals = await _localDataSource.getJournals(childStr);

        // Find journal matching targeted date
        final journal = journals.cast<NutritionJournalModel?>().firstWhere(
              (j) => j != null && j.journalDate.toIso8601String().split('T')[0] == date,
              orElse: () => null,
            );

        if (journal != null) {
          final meals = await _localDataSource.getMeals(journal.id);
          final hydration = await _localDataSource.getTodayHydration(childStr);

          return (
            data: NutritionDailyEntity(
              journal: journal,
              meals: meals,
              hydration: hydration,
            ),
            failure: null,
          );
        }
      } catch (_) {
        // ignore cache fallback exceptions, return original error
      }
      return (data: null, failure: ServerFailure(e.message));
    } catch (e) {
      return (data: null, failure: UnknownFailure(e.toString()));
    }
  }

  @override
  Future<({NutritionMealEntity? data, Failure? failure})> addMealLog({
    required int childId,
    required String mealTime,
    required String timeLabel,
    required String foodName,
    required String portion,
    required int calories,
    required String status,
  }) async {
    try {
      final payload = {
        'child_id': childId,
        'meal_time': mealTime,
        'time_label': timeLabel,
        'food_name': foodName,
        'portion': portion,
        'calories': calories,
        'status': status,
      };

      final remoteModel = await _remoteDataSource.addMealLog(payload);

      // Save locally
      await _localDataSource.saveMeal(
        remoteModel,
        status: SyncStatus.synced,
      );

      return (data: remoteModel, failure: null);
    } on ServerException catch (e) {
      return (data: null, failure: ServerFailure(e.message));
    } catch (e) {
      return (data: null, failure: UnknownFailure(e.toString()));
    }
  }
}
