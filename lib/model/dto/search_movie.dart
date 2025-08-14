class SearchMovieDto {
  SearchMovieDto({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  final int? page;
  final List<dynamic> results;
  final int? totalPages;
  final int? totalResults;

  factory SearchMovieDto.fromJson(Map<String, dynamic> json){
    return SearchMovieDto(
      page: json["page"],
      results: json["results"] == null ? [] : List<dynamic>.from(json["results"]!.map((x) => x)),
      totalPages: json["total_pages"],
      totalResults: json["total_results"],
    );
  }
}
