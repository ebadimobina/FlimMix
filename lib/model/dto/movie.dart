import 'package:intl/intl.dart';
import 'genre_movie.dart';

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
  final List<String> genreList;
  @override
  final double? popularity;
  @override
  final String originalTitle;
  final String watchlistStatus; // 'favorite', 'watchlist', 'watched'

  MovieModel({
    required this.id,
    required this.title,
    this.backdropPath,
    this.posterPath,
    this.overview,
    this.voteAverage,
    this.releaseDate,
    this.genreIds = const [],
    this.genreList = const [],
    this.popularity,
    required this.originalTitle,
    this.watchlistStatus = 'favorite',
  });

  factory MovieModel.fromJson(Map<String, dynamic> rawJson) {
    final json = rawJson.containsKey('show') && rawJson['show'] is Map<String, dynamic>
        ? rawJson['show'] as Map<String, dynamic>
        : rawJson;

    DateTime? parsedDate;
    final dateStr = json['release_date'] ?? json['releaseDate'] ?? json['premiered'];
    if (dateStr is String && dateStr.trim().isNotEmpty) {
      parsedDate = DateTime.tryParse(dateStr.trim());
    }

    // Genre parsing
    List<int> parsedGenreIds = [];
    List<String> parsedGenreNames = [];

    final rawGenres = json['genres'] ?? json['genre_ids'] ?? json['genreIds'];
    if (rawGenres is List) {
      for (final g in rawGenres) {
        if (g is int) {
          parsedGenreIds.add(g);
        } else if (g is String) {
          parsedGenreNames.add(g);
        } else if (g is num) {
          parsedGenreIds.add(g.toInt());
        }
      }
    }

    if (parsedGenreNames.isEmpty && parsedGenreIds.isNotEmpty) {
      parsedGenreNames = getGenreNames(parsedGenreIds);
    }

    // Rating parsing
    double? parsedRating;
    if (json['rating'] is Map && json['rating']['average'] != null) {
      parsedRating = (json['rating']['average'] as num?)?.toDouble();
    } else {
      final rawVote = json['vote_average'] ?? json['voteAverage'];
      if (rawVote is num) parsedRating = rawVote.toDouble();
    }

    // Overview parsing
    String? cleanOverview;
    final rawOverview = json['overview'] ?? json['summary'];
    if (rawOverview is String) {
      cleanOverview = rawOverview.replaceAll(RegExp(r'<[^>]*>'), '').trim();
      if (cleanOverview.isEmpty) cleanOverview = null;
    }

    // Image parsing
    String? poster;
    String? backdrop;
    if (json['image'] is Map) {
      final imgMap = json['image'] as Map<String, dynamic>;
      poster = (imgMap['medium'] ?? imgMap['original']) as String?;
      backdrop = (imgMap['original'] ?? imgMap['medium']) as String?;
    } else {
      poster = (json['poster_path'] ?? json['posterPath']) as String?;
      backdrop = (json['backdrop_path'] ?? json['backdropPath']) as String?;
    }

    final parsedPopularity = (json['weight'] ?? json['popularity'] as num?)?.toDouble() ?? 0.0;
    final parsedTitle = (json['title'] ?? json['name'] as String?)?.trim() ?? '';
    final parsedOriginalTitle = (json['original_title'] ??
            json['originalTitle'] ??
            json['name'] as String?)
        ?.trim() ??
        parsedTitle;

    final parsedStatus = (json['watchlist_status'] ?? json['watchlistStatus'] as String?) ?? 'favorite';

    return MovieModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: parsedTitle,
      backdropPath: backdrop,
      posterPath: poster,
      overview: cleanOverview ?? 'No description available.',
      voteAverage: parsedRating ?? 0.0,
      releaseDate: parsedDate,
      genreIds: parsedGenreIds,
      genreList: parsedGenreNames,
      popularity: parsedPopularity,
      originalTitle: parsedOriginalTitle,
      watchlistStatus: parsedStatus,
    );
  }

  MovieModel copyWith({
    int? id,
    String? title,
    String? backdropPath,
    String? posterPath,
    String? overview,
    double? voteAverage,
    DateTime? releaseDate,
    List<int>? genreIds,
    List<String>? genreList,
    double? popularity,
    String? originalTitle,
    String? watchlistStatus,
  }) {
    return MovieModel(
      id: id ?? this.id,
      title: title ?? this.title,
      backdropPath: backdropPath ?? this.backdropPath,
      posterPath: posterPath ?? this.posterPath,
      overview: overview ?? this.overview,
      voteAverage: voteAverage ?? this.voteAverage,
      releaseDate: releaseDate ?? this.releaseDate,
      genreIds: genreIds ?? this.genreIds,
      genreList: genreList ?? this.genreList,
      popularity: popularity ?? this.popularity,
      originalTitle: originalTitle ?? this.originalTitle,
      watchlistStatus: watchlistStatus ?? this.watchlistStatus,
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
      'genres': genreList,
      'popularity': popularity,
      'original_title': originalTitle,
      'watchlist_status': watchlistStatus,
    };
  }

  // --- Helper getters for modern UI presentation ---

  String? get posterUrl {
    if (posterPath == null || posterPath!.isEmpty) return null;
    if (posterPath!.startsWith('http')) return posterPath;
    return 'https://image.tmdb.org/t/p/w500$posterPath';
  }

  String? get backdropUrl {
    if (backdropPath != null && backdropPath!.isNotEmpty) {
      if (backdropPath!.startsWith('http')) return backdropPath;
      return 'https://image.tmdb.org/t/p/w780$backdropPath';
    }
    return posterUrl;
  }

  String get ratingText => (voteAverage != null && voteAverage! > 0)
      ? voteAverage!.toStringAsFixed(1)
      : 'N/A';

  String get releaseYear =>
      releaseDate != null ? releaseDate!.year.toString() : '----';

  String get formattedReleaseDate => releaseDate != null
      ? DateFormat('MMMM d, y').format(releaseDate!)
      : 'Release date unknown';

  List<String> get genreNames =>
      genreList.isNotEmpty ? genreList : getGenreNames(genreIds);
}

class MovieResponse {
  final int page;
  final List<MovieModel> results;
  final int totalPages;
  final int totalResults;

  MovieResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory MovieResponse.fromJson(dynamic json) {
    if (json is List) {
      final list = json
          .whereType<Map<String, dynamic>>()
          .map((item) => MovieModel.fromJson(item))
          .toList();
      return MovieResponse(
        page: 1,
        results: list,
        totalPages: 1,
        totalResults: list.length,
      );
    }

    if (json is Map<String, dynamic>) {
      final resultsList = (json['results'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map((item) => MovieModel.fromJson(item))
              .toList() ??
          [];
      return MovieResponse(
        page: (json['page'] as num?)?.toInt() ?? 1,
        results: resultsList,
        totalPages: (json['total_pages'] as num?)?.toInt() ?? 1,
        totalResults: (json['total_results'] as num?)?.toInt() ?? resultsList.length,
      );
    }

    return MovieResponse(page: 1, results: [], totalPages: 1, totalResults: 0);
  }
}
