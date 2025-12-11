/// DTO для ответов TMDB API

/// DTO для результата поиска фильмов
class TmdbSearchResponseDto {
  final int page;
  final List<TmdbMovieDto> results;
  final int totalPages;
  final int totalResults;

  TmdbSearchResponseDto({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory TmdbSearchResponseDto.fromJson(Map<String, dynamic> json) {
    return TmdbSearchResponseDto(
      page: json['page'] as int? ?? 1,
      results: (json['results'] as List<dynamic>?)
              ?.map((item) => TmdbMovieDto.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalPages: json['total_pages'] as int? ?? 0,
      totalResults: json['total_results'] as int? ?? 0,
    );
  }
}

/// DTO для популярных фильмов
class TmdbPopularResponseDto {
  final int page;
  final List<TmdbMovieDto> results;
  final int totalPages;
  final int totalResults;

  TmdbPopularResponseDto({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory TmdbPopularResponseDto.fromJson(Map<String, dynamic> json) {
    return TmdbPopularResponseDto(
      page: json['page'] as int? ?? 1,
      results: (json['results'] as List<dynamic>?)
              ?.map((item) => TmdbMovieDto.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      totalPages: json['total_pages'] as int? ?? 0,
      totalResults: json['total_results'] as int? ?? 0,
    );
  }
}

/// DTO для фильма из TMDB API
class TmdbMovieDto {
  final int id;
  final String title;
  final String? overview;
  final String? releaseDate;
  final double? voteAverage;
  final List<TmdbGenreDto>? genres;
  final String? posterPath;
  final String? backdropPath;

  TmdbMovieDto({
    required this.id,
    required this.title,
    this.overview,
    this.releaseDate,
    this.voteAverage,
    this.genres,
    this.posterPath,
    this.backdropPath,
  });

  factory TmdbMovieDto.fromJson(Map<String, dynamic> json) {
    return TmdbMovieDto(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'Без названия',
      overview: json['overview'] as String?,
      releaseDate: json['release_date'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      genres: (json['genres'] as List<dynamic>?)
          ?.map((item) => TmdbGenreDto.fromJson(item as Map<String, dynamic>))
          .toList(),
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
    );
  }
}

/// DTO для жанра из TMDB API
class TmdbGenreDto {
  final int id;
  final String name;

  TmdbGenreDto({
    required this.id,
    required this.name,
  });

  factory TmdbGenreDto.fromJson(Map<String, dynamic> json) {
    return TmdbGenreDto(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

