/// Standard API response wrapper required by all remote datasources.
///
/// Source: claude1.md §API Response Standard
/// Source: claude2.md §1 (Koreksi Fatal — semua response harus dibungkus)
class ApiResponse<T> {
  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });

  final bool success;
  final String message;
  final T? data;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromData,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null ? fromData(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson(Object? Function(T? value) toData) {
    return {
      'success': success,
      'message': message,
      'data': toData(data),
    };
  }
}
