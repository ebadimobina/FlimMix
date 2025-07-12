abstract class MovieBase {
  int get id;

  String get title;

  String? get backdropPath;

  String? get posterPath;

  String? get overview;

  double? get voteAverage;

  DateTime? get releaseDate;

  List<int> get genreIds;

  double? get popularity;

  String get originalTitle;
}

class MovieModel extends MovieBase {
  @override
  final int id;
  @override
  final String title;
  @override
  final String? backdropPath;
  @override
  final String? posterPath;
  @override
  final String? overview;
  @override
  final double? voteAverage;
  @override
  final DateTime? releaseDate;
  @override
  final List<int> genreIds;
  @override
  final double? popularity;
  @override
  final String originalTitle;

  MovieModel({
    required this.id,
    required this.title,
    this.backdropPath,
    this.posterPath,
    this.overview,
    this.voteAverage,
    this.releaseDate,
    required this.genreIds,
    this.popularity,
    required this.originalTitle,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'],
      title: json['title'] ?? '',
      backdropPath: json['backdrop_path'],
      posterPath: json['poster_path'],
      overview: json['overview'],
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] != null && json['release_date'] != ''
          ? DateTime.tryParse(json['release_date'])
          : null,
      genreIds: (json['genre_ids'] as List<dynamic>?)?.cast<int>() ?? [],
      popularity: (json['popularity'] ?? 0).toDouble(),
      originalTitle: json['original_title'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'backdrop_path': backdropPath,
      'poster_path': posterPath,
      'overview': overview,
      'vote_average': voteAverage,
      'release_date': releaseDate?.toIso8601String(),
      'genre_ids': genreIds,
      'popularity': popularity,
      'original_title': originalTitle,
    };
  }
}
