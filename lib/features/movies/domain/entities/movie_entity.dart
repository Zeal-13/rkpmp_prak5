/// Domain entity for Movie
/// Represents the core business model, independent of data sources
class MovieEntity {
  final String id;
  final String title;
  final String description;
  final String genre;
  final int year;
  final double rating;
  final bool isWatched;
  final DateTime createdAt;

  const MovieEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.genre,
    required this.year,
    required this.rating,
    required this.isWatched,
    required this.createdAt,
  });

  MovieEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? genre,
    int? year,
    double? rating,
    bool? isWatched,
    DateTime? createdAt,
  }) {
    return MovieEntity(
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MovieEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

