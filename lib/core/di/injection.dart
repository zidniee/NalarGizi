import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:nalargizi/core/network/api_client.dart';
import 'package:nalargizi/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:nalargizi/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:nalargizi/features/auth/domain/repositories/auth_repository.dart';
import 'package:nalargizi/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:nalargizi/features/auth/domain/usecases/google_login_usecase.dart';
import 'package:nalargizi/features/auth/domain/usecases/login_usecase.dart';
import 'package:nalargizi/features/auth/domain/usecases/register_usecase.dart';
import 'package:nalargizi/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:nalargizi/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:nalargizi/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:nalargizi/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:nalargizi/features/dashboard/domain/usecases/get_dashboard_overview_usecase.dart';
import 'package:nalargizi/features/dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:nalargizi/features/growth/data/datasources/growth_local_data_source.dart';
import 'package:nalargizi/features/growth/data/datasources/growth_remote_data_source.dart';
import 'package:nalargizi/features/growth/data/repositories/growth_repository_impl.dart';
import 'package:nalargizi/features/growth/domain/repositories/growth_repository.dart';
import 'package:nalargizi/features/growth/domain/usecases/add_growth_record_usecase.dart';
import 'package:nalargizi/features/growth/domain/usecases/get_growth_records_usecase.dart';
import 'package:nalargizi/features/growth/presentation/cubit/growth_cubit.dart';
import 'package:nalargizi/features/posyandu/data/datasources/posyandu_local_data_source.dart';
import 'package:nalargizi/features/posyandu/data/datasources/posyandu_remote_data_source.dart';
import 'package:nalargizi/features/posyandu/data/repositories/posyandu_repository_impl.dart';
import 'package:nalargizi/features/posyandu/domain/repositories/posyandu_repository.dart';
import 'package:nalargizi/features/posyandu/domain/usecases/get_posyandu_data_usecase.dart';
import 'package:nalargizi/features/posyandu/presentation/bloc/posyandu_cubit.dart';
import 'package:nalargizi/features/nutrition/data/datasources/nutrition_local_data_source.dart';
import 'package:nalargizi/features/nutrition/data/datasources/nutrition_remote_data_source.dart';
import 'package:nalargizi/features/nutrition/data/repositories/nutrition_repository_impl.dart';
import 'package:nalargizi/features/nutrition/domain/repositories/nutrition_repository.dart';
import 'package:nalargizi/features/nutrition/domain/usecases/get_daily_nutrition_usecase.dart';
import 'package:nalargizi/features/nutrition/domain/usecases/add_meal_log_usecase.dart';
import 'package:nalargizi/features/nutrition/presentation/cubit/nutrition_cubit.dart';
import 'package:nalargizi/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:nalargizi/features/profile/data/datasources/notification_remote_data_source.dart';
import 'package:nalargizi/features/profile/domain/repositories/profile_repository.dart';
import 'package:nalargizi/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:nalargizi/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:nalargizi/features/profile/domain/usecases/get_history_usecase.dart';
import 'package:nalargizi/features/profile/domain/usecases/get_notifications_usecase.dart';
import 'package:nalargizi/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:nalargizi/features/profile/presentation/cubit/notification_cubit.dart';

/// Service Locator using GetIt.
///
/// Source: claude2.md §3 — DEPENDENCY INJECTION STRATEGY
/// All Datasource, Repository, UseCase, and Cubit MUST be registered here.
/// UI must call via GetIt.I<T>() or BlocProvider, NEVER instantiate manually.
final getIt = GetIt.instance;

/// Initialize all dependencies.
/// Called once in main.dart before runApp().
Future<void> configureDependencies() async {
  // ── Core ─────────────────────────────────────────────────────────────
  final apiClient = ApiClient();
  getIt.registerLazySingleton<ApiClient>(() => apiClient);
  getIt.registerLazySingleton<Dio>(() => getIt<ApiClient>().dio);

  // ── AUTH ─────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
  );
  getIt.registerLazySingleton(() => LoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => RegisterUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => GoogleLoginUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(
    () => ForgotPasswordUseCase(getIt<AuthRepository>()),
  );
  getIt.registerFactory(
    () => AuthCubit(
      loginUseCase: getIt<LoginUseCase>(),
      registerUseCase: getIt<RegisterUseCase>(),
      googleLoginUseCase: getIt<GoogleLoginUseCase>(),
      forgotPasswordUseCase: getIt<ForgotPasswordUseCase>(),
    ),
  );

  // ── DASHBOARD ─────────────────────────────────────────────────────────
  getIt.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(getIt<DashboardRemoteDataSource>()),
  );
  getIt.registerLazySingleton(
    () => GetDashboardOverviewUseCase(getIt<DashboardRepository>()),
  );
  getIt.registerFactory(
    () => DashboardCubit(getIt<GetDashboardOverviewUseCase>()),
  );

  // ── GROWTH ────────────────────────────────────────────────────────────
  getIt.registerLazySingleton<GrowthRemoteDataSource>(
    () => GrowthRemoteDataSource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<GrowthLocalDataSource>(
    () => GrowthLocalDataSource(),
  );
  getIt.registerLazySingleton<GrowthRepository>(
    () => GrowthRepositoryImpl(
      remoteDataSource: getIt<GrowthRemoteDataSource>(),
      localDataSource: getIt<GrowthLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton(
    () => GetGrowthRecordsUseCase(getIt<GrowthRepository>()),
  );
  getIt.registerLazySingleton(
    () => AddGrowthRecordUseCase(getIt<GrowthRepository>()),
  );
  getIt.registerFactory(
    () => GrowthCubit(
      getGrowthRecordsUseCase: getIt<GetGrowthRecordsUseCase>(),
      addGrowthRecordUseCase: getIt<AddGrowthRecordUseCase>(),
    ),
  );

  // ── POSYANDU ──────────────────────────────────────────────────────────
  getIt.registerLazySingleton<PosyanduLocalDataSource>(
    () => PosyanduLocalDataSource(),
  );
  getIt.registerLazySingleton<PosyanduRemoteDataSource>(
    () => PosyanduRemoteDataSource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<PosyanduRepository>(
    () => PosyanduRepositoryImpl(
      remoteDataSource: getIt<PosyanduRemoteDataSource>(),
      localDataSource: getIt<PosyanduLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton(
    () => GetPosyanduDataUseCase(getIt<PosyanduRepository>()),
  );
  getIt.registerFactory(
    () => PosyanduCubit(
      getIt<GetPosyanduDataUseCase>(),
      getIt<PosyanduRepository>(),
    ),
  );

  // ── NUTRITION ─────────────────────────────────────────────────────────
  getIt.registerLazySingleton<NutritionLocalDataSource>(
    () => NutritionLocalDataSource(),
  );
  getIt.registerLazySingleton<NutritionRemoteDataSource>(
    () => NutritionRemoteDataSource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<NutritionRepository>(
    () => NutritionRepositoryImpl(
      remoteDataSource: getIt<NutritionRemoteDataSource>(),
      localDataSource: getIt<NutritionLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton(
    () => GetDailyNutritionUseCase(getIt<NutritionRepository>()),
  );
  getIt.registerLazySingleton(
    () => AddMealLogUseCase(getIt<NutritionRepository>()),
  );
  getIt.registerFactory(
    () => NutritionCubit(
      getDailyNutritionUseCase: getIt<GetDailyNutritionUseCase>(),
      addMealLogUseCase: getIt<AddMealLogUseCase>(),
    ),
  );

  // ── PROFILE & NOTIFICATIONS ──────────────────────────────────────────
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSource(getIt<Dio>()),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      profileRemoteDataSource: getIt<ProfileRemoteDataSource>(),
      notificationRemoteDataSource: getIt<NotificationRemoteDataSource>(),
    ),
  );
  getIt.registerLazySingleton(() => GetProfileUseCase(getIt<ProfileRepository>()));
  getIt.registerLazySingleton(() => GetHistoryUseCase(getIt<ProfileRepository>()));
  getIt.registerLazySingleton(
    () => GetNotificationsUseCase(getIt<ProfileRepository>()),
  );
  getIt.registerFactory(
    () => ProfileCubit(
      getProfileUseCase: getIt<GetProfileUseCase>(),
      getHistoryUseCase: getIt<GetHistoryUseCase>(),
    ),
  );
  getIt.registerFactory(
    () => NotificationCubit(getIt<GetNotificationsUseCase>()),
  );
}
