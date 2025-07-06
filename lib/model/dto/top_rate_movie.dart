import 'movie.dart';

class TopRateMovie {
  int page;
  List<ResultTopRate> results;
  int totalPages;
  int totalResults;

  TopRateMovie({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory TopRateMovie.fromJson(Map<String, dynamic> json) {
    return TopRateMovie(
      page: json['page'],
      results:
          List<ResultTopRate>.from(json['results'].map((x) => ResultTopRate.fromJson(x))),
      totalPages: json['total_pages'],
      totalResults: json['total_results'],
    );
  }
}

class ResultTopRate extends MovieBase{
  bool adult;
  @override
  String backdropPath;
  @override
  List<int> genreIds;
  @override
  int id;
  String originalLanguage;
  @override
  String originalTitle;
  @override
  String overview;
  @override
  double popularity;
  @override
  String posterPath;
  @override
  DateTime? releaseDate;
  @override
  String title;
  bool video;
  @override
  double voteAverage;
  int voteCount;

  ResultTopRate({
    required this.adult,
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.releaseDate,
    required this.title,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
  });

  factory ResultTopRate.fromJson(Map<String, dynamic> json) {
    return ResultTopRate(
      adult: json['adult'],
      backdropPath: json['backdrop_path'] ?? '',
      genreIds: List<int>.from(json['genre_ids']),
      id: json['id'],
      originalLanguage: json['original_language'],
      originalTitle: json['original_title'],
      overview: json['overview'],
      popularity: (json['popularity'] as num).toDouble(),
      posterPath: json['poster_path'] ?? '',
      releaseDate: json['release_date'] == null || json['release_date'] == ""
          ? null
          : DateTime.parse(json['release_date']),
      title: json['title'],
      video: json['video'],
      voteAverage: (json['vote_average'] as num).toDouble(),
      voteCount: json['vote_count'],
    );
  }
}
