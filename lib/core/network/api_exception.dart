/// Исключение для API ошибок
class ApiException implements Exception {
  final String message;
  final int statusCode;
  final String? body;

  ApiException({
    required this.message,
    required this.statusCode,
    this.body,
  });

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

