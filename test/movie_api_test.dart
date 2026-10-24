import 'package:flimmix/core/service/movie_api.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Live test: MovieApi fetches top-rated shows from TVMaze', () async {
    final api = MovieApi();
    final response = await api.fetchTopRatedMovies();

    expect(response.results, isNotEmpty);
    final first = response.results.first;
    expect(first.title, isNotEmpty);
    expect(first.voteAverage, isNotNull);
    expect(first.posterUrl, isNotNull);
  });

  test('Live test: MovieApi searches shows on TVMaze', () async {
    final api = MovieApi();
    final response = await api.searchMovies('Breaking Bad');

    expect(response.results, isNotEmpty);
    final show = response.results.firstWhere(
      (m) => m.title.toLowerCase().contains('breaking bad'),
    );
    expect(show.title, contains('Breaking Bad'));
  });
}
