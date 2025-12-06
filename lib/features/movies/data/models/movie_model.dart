import '../../domain/entities/movie_entity.dart';

/// Data model for Movie
/// Extends domain entity with serialization capabilities
class MovieModel extends MovieEntity {
  const MovieModel({
    required super.id,
    required super.title,
    required super.description,
    required super.genre,
    required super.year,
    required super.rating,
    required super.isWatched,
    required super.createdAt,
  });

  /// Create MovieModel from JSON
  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      genre: json['genre'] as String,
      year: json['year'] as int,
      rating: (json['rating'] as num).toDouble(),
      isWatched: json['isWatched'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Convert MovieModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'genre': genre,
      'year': year,
      'rating': rating,
      'isWatched': isWatched,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create MovieModel from domain entity
  factory MovieModel.fromEntity(MovieEntity entity) {
    return MovieModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      genre: entity.genre,
      year: entity.year,
      rating: entity.rating,
      isWatched: entity.isWatched,
      createdAt: entity.createdAt,
    );
  }

  @override
  MovieModel copyWith({
    String? id,
    String? title,
    String? description,
    String? genre,
    int? year,
    double? rating,
    bool? isWatched,
    DateTime? createdAt,
  }) {
    return MovieModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      genre: genre ?? this.genre,
      year: year ?? this.year,
      rating: rating ?? this.rating,
      isWatched: isWatched ?? this.isWatched,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

