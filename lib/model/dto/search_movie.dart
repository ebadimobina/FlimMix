import 'movie.dart';

class SearchMovieDto {
  SearchMovieDto({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  final int? page;
  final List<MovieModel> results;
  final int? totalPages;
  final int? totalResults;

  factory SearchMovieDto.fromJson(Map<String, dynamic> json){
    return SearchMovieDto(
      page: json["page"],
      results: json["results"] == null ? [] : List<MovieModel>.from(json["results"]!.map((x) => MovieModel.fromJson(x))),
      totalPages: json["total_pages"],
      totalResults: json["total_results"],
    );
  }
}
