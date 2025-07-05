class Details {
  Details({
    required this.page,
    required this.results,
  });

  final int? page;
  final List<ResultDetails> results;

  factory Details.fromJson(Map<String, dynamic> json){
    return Details(
      page: json["page"],
      results: json["results"] == null ? [] : List<ResultDetails>.from(json["results"]!.map((x) => ResultDetails.fromJson(x))),
    );
  }

}

class ResultDetails {
  ResultDetails({
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
  final String? originalTitle;
  final String? overview;
  final double? popularity;
  final String? posterPath;
  final DateTime? releaseDate;
  final String? title;
  final bool? video;
  final double? voteAverage;
  final int? voteCount;

  factory ResultDetails.fromJson(Map<String, dynamic> json){
    return ResultDetails(
      adult: json["adult"] ?? false,
      backdropPath: json["backdrop_path"] ?? '',
      genreIds: json["genre_ids"] == null
          ? []
          : List<int>.from(json["genre_ids"]!.map((x) => x ?? 0)),
      id: json["id"] ?? 0,
      originalLanguage: json["original_language"] ?? 'en',
      originalTitle: json["original_title"] ?? '',
      overview: json["overview"] ?? 'No overview available',
      popularity: (json["popularity"] as num?)?.toDouble() ?? 0.0,
      posterPath: json["poster_path"] ?? '',
      releaseDate: DateTime.tryParse(json["release_date"] ?? ''),
      title: json["title"] ?? 'No title',
      video: json["video"] ?? false,
      voteAverage: (json["vote_average"] as num?)?.toDouble() ?? 0.0,
      voteCount: json["vote_count"] ?? 0,
    );
  }
}
