import 'package:dio/dio.dart';
import 'api_exception.dart';

/// Базовый класс для работы с API через Dio
class DioClient {
  final Dio dio;

  DioClient({
    required String baseUrl,
    Map<String, String>? headers,
    Duration? connectTimeout,
    Duration? receiveTimeout,
  }) : dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            headers: headers ?? {'Content-Type': 'application/json'},
            connectTimeout: connectTimeout ?? const Duration(seconds: 30),
            receiveTimeout: receiveTimeout ?? const Duration(seconds: 30),
          ),
        ) {
    // Добавляем interceptor для обработки ошибок
    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) {
          if (error.response != null) {
            // Обрабатываем ошибки с ответом от сервера
            final statusCode = error.response!.statusCode ?? 0;
            final errorMessage = _extractErrorMessage(error.response!.data);
            
            handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                response: error.response,
                type: DioExceptionType.badResponse,
                error: ApiException(
                  message: errorMessage,
                  statusCode: statusCode,
                  body: error.response!.data?.toString(),
                ),
              ),
            );
          } else if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.receiveTimeout) {
            // Обрабатываем таймауты
            handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                type: error.type,
                error: ApiException(
                  message: 'Request timeout. Проверьте подключение к интернету.',
                  statusCode: 0,
                ),
              ),
            );
          } else {
            // Обрабатываем другие ошибки
            handler.reject(
              DioException(
                requestOptions: error.requestOptions,
                type: error.type,
                error: ApiException(
                  message: 'Ошибка сети: ${error.message}. Проверьте подключение к интернету.',
                  statusCode: 0,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  /// Извлечь сообщение об ошибке из ответа
  String _extractErrorMessage(dynamic data) {
    if (data == null) {
      return 'Unknown error';
    }
    
    if (data is Map<String, dynamic>) {
      // Проверяем различные форматы ошибок
      if (data.containsKey('error')) {
        return data['error'] as String? ?? 'Unknown error';
      }
      if (data.containsKey('message')) {
        return data['message'] as String? ?? 'Unknown error';
      }
      if (data.containsKey('errors')) {
        final errors = data['errors'];
        if (errors is List && errors.isNotEmpty) {
          return errors.first.toString();
        }
        if (errors is Map) {
          return errors.values.first.toString();
        }
      }
    }
    
    return data.toString();
  }

  /// Выполнить GET запрос
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Options? options,
  }) async {
    try {
      final response = await dio.get<Map<String, dynamic>>(
        endpoint,
        queryParameters: queryParameters,
        options: options ??
            Options(
              headers: headers,
            ),
      );

      return response.data ?? {};
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      throw ApiException(
        message: 'Неожиданная ошибка: ${e.message}',
        statusCode: e.response?.statusCode ?? 0,
      );
    } catch (e) {
      throw ApiException(
        message: 'Неожиданная ошибка: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  /// Выполнить POST запрос
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Options? options,
  }) async {
    try {
      final response = await dio.post<Map<String, dynamic>>(
        endpoint,
        data: body,
        options: options ??
            Options(
              headers: headers,
            ),
      );

      return response.data ?? {};
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      throw ApiException(
        message: 'Неожиданная ошибка: ${e.message}',
        statusCode: e.response?.statusCode ?? 0,
      );
    } catch (e) {
      throw ApiException(
        message: 'Неожиданная ошибка: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  /// Выполнить PUT запрос
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Options? options,
  }) async {
    try {
      final response = await dio.put<Map<String, dynamic>>(
        endpoint,
        data: body,
        options: options ??
            Options(
              headers: headers,
            ),
      );

      return response.data ?? {};
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      throw ApiException(
        message: 'Неожиданная ошибка: ${e.message}',
        statusCode: e.response?.statusCode ?? 0,
      );
    } catch (e) {
      throw ApiException(
        message: 'Неожиданная ошибка: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  /// Выполнить DELETE запрос
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    Options? options,
  }) async {
    try {
      final response = await dio.delete<Map<String, dynamic>>(
        endpoint,
        queryParameters: queryParameters,
        options: options ??
            Options(
              headers: headers,
            ),
      );

      return response.data ?? {};
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      throw ApiException(
        message: 'Неожиданная ошибка: ${e.message}',
        statusCode: e.response?.statusCode ?? 0,
      );
    } catch (e) {
      throw ApiException(
        message: 'Неожиданная ошибка: ${e.toString()}',
        statusCode: 0,
      );
    }
  }
}

