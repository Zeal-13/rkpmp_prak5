// Этот файл оставлен для обратной совместимости
// Используйте DioClient вместо ApiClient
export 'dio_client.dart' show DioClient;
export 'api_exception.dart' show ApiException;

/// Устаревший класс, используйте DioClient
@Deprecated('Используйте DioClient вместо ApiClient')
class ApiClient {
  final String baseUrl;
  final Map<String, String> defaultHeaders;

  ApiClient({
    required this.baseUrl,
    Map<String, String>? headers,
  }) : defaultHeaders = headers ?? {
          'Content-Type': 'application/json',
        };

  /// Выполнить GET запрос
  @Deprecated('Используйте DioClient.get()')
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParameters,
    Map<String, String>? headers,
  }) async {
    throw UnimplementedError('Используйте DioClient вместо ApiClient');
  }

  /// Выполнить POST запрос
  @Deprecated('Используйте DioClient.post()')
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    throw UnimplementedError('Используйте DioClient вместо ApiClient');
  }
}

