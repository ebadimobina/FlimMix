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
