class Movie {
  final String id;
  final String title;
  final String description;
  final String genre;
  final int year;
  final double rating;
  final bool isWatched;
  final DateTime createdAt;

  const Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.genre,
    required this.year,
    required this.rating,
    required this.isWatched,
    required this.createdAt,
  });

  Movie copyWith({
    String? id,
    String? title,
    String? description,
    String? genre,
    int? year,
    double? rating,
    bool? isWatched,
    DateTime? createdAt,
  }) {
    return Movie(
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
