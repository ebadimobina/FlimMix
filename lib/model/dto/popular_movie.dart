import 'movie.dart';

class Popular {
  Popular({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  final int? page;
  final List<ResultPopular> results;
  final int? totalPages;
  final int? totalResults;

  factory Popular.fromJson(Map<String, dynamic> json){
    return Popular(
      page: json["page"],
      results: json["results"] == null ? [] : List<ResultPopular>.from(json["results"]!.map((x) => ResultPopular.fromJson(x))),
      totalPages: json["total_pages"],
      totalResults: json["total_results"],
    );
  }

}

class ResultPopular extends MovieBase {
  ResultPopular({
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

  final bool? adult;
  final String? backdropPath;
  final List<int> genreIds;
  final int id;
  final String? originalLanguage;
  final String originalTitle;
  final String? overview;
  final double? popularity;
  final String? posterPath;
  final DateTime? releaseDate;
  final String title;
  final bool? video;
  final double? voteAverage;
  final int? voteCount;

  factory ResultPopular.fromJson(Map<String, dynamic> json){
    return ResultPopular(
      adult: json["adult"],
      backdropPath: json["backdrop_path"],
      genreIds: json["genre_ids"] == null ? [] : List<int>.from(json["genre_ids"]!.map((x) => x)),
      id: json["id"],
      originalLanguage: json["original_language"],
      originalTitle: json["original_title"],
      overview: json["overview"],
      popularity: json["popularity"],
      posterPath: json["poster_path"],
      releaseDate: DateTime.tryParse(json["release_date"] ?? ""),
      title: json["title"],
      video: json["video"],
      voteAverage: json["vote_average"],
      voteCount: json["vote_count"],
    );
  }

}
