import 'package:nalargizi/core/error/exceptions.dart';
import 'package:nalargizi/core/error/failures.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

/// Concrete implementation of [AuthRepository].
///
/// Source: claude2.md §2 — Repository catches Exception and maps to Failure.
/// Datasource throws Exception → Repository catches → returns Failure record.
/// Never expose raw DioException to UI (claude1.md §279).
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<({AuthResultEntity? data, Failure? failure})> login({
    required String email,
    required String password,
  }) async {
    try {
      final model = await _remoteDataSource.login(
        email: email,
        password: password,
      );
      return (data: model.toEntity(), failure: null);
    } on UnauthorizedException catch (e) {
      return (data: null, failure: UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return (data: null, failure: ServerFailure(e.message));
    } catch (e) {
      return (data: null, failure: UnknownFailure(e.toString()));
    }
  }

  @override
  Future<({AuthResultEntity? data, Failure? failure})> register({
    required String name,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    try {
      final model = await _remoteDataSource.register(
        name: name,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
      );
      return (data: model.toEntity(), failure: null);
    } on ServerException catch (e) {
      return (data: null, failure: ServerFailure(e.message));
    } catch (e) {
      return (data: null, failure: UnknownFailure(e.toString()));
    }
  }

  @override
  Future<({AuthResultEntity? data, Failure? failure})> googleLogin(
    String idToken,
  ) async {
    try {
      final model = await _remoteDataSource.googleLogin(idToken);
      return (data: model.toEntity(), failure: null);
    } on ServerException catch (e) {
      return (data: null, failure: ServerFailure(e.message));
    } catch (e) {
      return (data: null, failure: UnknownFailure(e.toString()));
    }
  }

  @override
  Future<({bool success, Failure? failure})> forgotPassword(
    String email,
  ) async {
    try {
      await _remoteDataSource.forgotPassword(email);
      return (success: true, failure: null);
    } on ServerException catch (e) {
      return (success: false, failure: ServerFailure(e.message));
    } catch (e) {
      return (success: false, failure: UnknownFailure(e.toString()));
    }
  }
}
