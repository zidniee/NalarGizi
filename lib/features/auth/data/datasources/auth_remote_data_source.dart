import 'package:dio/dio.dart';
import 'package:nalargizi/core/error/exceptions.dart';
import 'package:nalargizi/core/network/api_endpoints.dart';
import 'package:nalargizi/core/network/api_response.dart';
import '../models/auth_response_model.dart';

/// Remote data source for all authentication API calls.
///
/// Source: claude1.md §NETWORKING RULES — Only Datasources may access Dio.
/// Source: claude2.md §2 — Datasource throws Exception, never Failure.
/// Source: claude.md §3A — POST /api/auth/*
class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._dio);

  final Dio _dio;

  /// Login with email and password.
  /// POST /api/auth/login
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.authLogin,
        data: {'email': email, 'password': password},
      );
      final apiResponse = ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (data) => AuthResponseModel.fromJson(data as Map<String, dynamic>),
      );
      if (!apiResponse.success || apiResponse.data == null) {
        throw ServerException(apiResponse.message);
      }
      return apiResponse.data!;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedException('Email atau password salah.');
      }
      throw ServerException(e.message ?? 'Gagal login.');
    }
  }

  /// Register a new account.
  /// POST /api/auth/register
  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
    String? phoneNumber,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.authRegister,
        data: {
          'name': name,
          'email': email,
          'password': password,
          if (phoneNumber != null) 'phone_number': phoneNumber,
        },
      );
      final apiResponse = ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (data) => AuthResponseModel.fromJson(data as Map<String, dynamic>),
      );
      if (!apiResponse.success || apiResponse.data == null) {
        throw ServerException(apiResponse.message);
      }
      return apiResponse.data!;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Gagal registrasi.');
    }
  }

  /// Login with Google OAuth2 token.
  /// POST /api/auth/google
  Future<AuthResponseModel> googleLogin(String idToken) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.authGoogle,
        data: {'id_token': idToken},
      );
      final apiResponse = ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (data) => AuthResponseModel.fromJson(data as Map<String, dynamic>),
      );
      if (!apiResponse.success || apiResponse.data == null) {
        throw ServerException(apiResponse.message);
      }
      return apiResponse.data!;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Gagal Google Login.');
    }
  }

  /// Send forgot password email.
  /// POST /api/auth/forgot-password
  Future<void> forgotPassword(String email) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.authForgotPassword,
        data: {'email': email},
      );
      final apiResponse = ApiResponse<void>.fromJson(
        response.data as Map<String, dynamic>,
        (_) {},
      );
      if (!apiResponse.success) {
        throw ServerException(apiResponse.message);
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Gagal mengirim email reset.');
    }
  }
}
