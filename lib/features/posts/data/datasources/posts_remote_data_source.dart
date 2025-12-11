import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/dto/jsonplaceholder_dto.dart';
import '../../../../core/network/api_exception.dart';

/// Remote data source для работы с JSONPlaceholder API
/// API: https://jsonplaceholder.typicode.com/
abstract class PostsRemoteDataSource {
  /// Получить список постов
  Future<List<JsonPlaceholderPostDto>> getPosts({int? limit});

  /// Получить комментарии к посту
  Future<List<JsonPlaceholderCommentDto>> getPostComments(int postId);
}

/// Реализация PostsRemoteDataSource с использованием JSONPlaceholder API и Dio
class PostsRemoteDataSourceImpl implements PostsRemoteDataSource {
  final DioClient dioClient;

  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  PostsRemoteDataSourceImpl({DioClient? client})
      : dioClient = client ??
            DioClient(
              baseUrl: _baseUrl,
              headers: {'Content-Type': 'application/json'},
            );

  @override
  Future<List<JsonPlaceholderPostDto>> getPosts({int? limit}) async {
    try {
      // Используем прямой доступ к Dio для получения списка
      final response = await dioClient.dio.get<List<dynamic>>('/posts');

      if (response.data == null) {
        return [];
      }

      // Парсим список постов через DTO
      final posts = response.data!
          .map((json) => JsonPlaceholderPostDto.fromJson(json as Map<String, dynamic>))
          .toList();

      // Ограничиваем количество, если указан limit
      if (limit != null && limit > 0) {
        return posts.take(limit).toList();
      }

      return posts;
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw Exception((e.error as ApiException).message);
      }
      throw Exception('Ошибка при получении постов: ${e.message}');
    } catch (e) {
      throw Exception('Ошибка при получении постов: $e');
    }
  }

  @override
  Future<List<JsonPlaceholderCommentDto>> getPostComments(int postId) async {
    try {
      // Используем прямой доступ к Dio для получения списка
      final response = await dioClient.dio.get<List<dynamic>>('/posts/$postId/comments');

      if (response.data == null) {
        return [];
      }

      // Парсим список комментариев через DTO
      return response.data!
          .map((json) => JsonPlaceholderCommentDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw Exception((e.error as ApiException).message);
      }
      throw Exception('Ошибка при получении комментариев: ${e.message}');
    } catch (e) {
      throw Exception('Ошибка при получении комментариев: $e');
    }
  }
}

