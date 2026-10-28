import 'package:flimmix/model/dto/cast_movie.dart';
import 'package:flimmix/model/dto/movie.dart';
import 'package:flimmix/model/storage/local_storage_manager.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    const MethodChannel channel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return '.';
    });
    await GetStorage.init();
  });

  group('MovieModel TMDb & TVMaze Tests', () {
    test('fromJson parses standard TMDb payload correctly', () {
      final json = {
        'id': 101,
        'title': 'Inception',
        'backdrop_path': '/backdrop.jpg',
        'poster_path': '/poster.jpg',
        'overview': 'A mind-bending thriller',
        'vote_average': 8.8,
        'release_date': '2010-07-16',
        'genre_ids': [28, 878],
        'popularity': 120.5,
        'original_title': 'Inception',
      };

      final movie = MovieModel.fromJson(json);

      expect(movie.id, 101);
      expect(movie.title, 'Inception');
      expect(movie.ratingText, '8.8');
      expect(movie.releaseYear, '2010');
      expect(movie.posterUrl, 'https://image.tmdb.org/t/p/w500/poster.jpg');
      expect(movie.backdropUrl, 'https://image.tmdb.org/t/p/w780/backdrop.jpg');
    });

    test('fromJson parses TVMaze payload correctly', () {
      final json = {
        'id': 169,
        'name': 'Breaking Bad',
        'premiered': '2008-01-20',
        'genres': ['Drama', 'Crime', 'Thriller'],
        'rating': {'average': 9.2},
        'weight': 99,
        'image': {
          'medium': 'https://static.tvmaze.com/uploads/images/medium_portrait/0/2400.jpg',
          'original': 'https://static.tvmaze.com/uploads/images/original_untouched/0/2400.jpg',
        },
        'summary': '<p>A chemistry teacher diagnosed with terminal lung cancer.</p>',
      };

      final movie = MovieModel.fromJson(json);

      expect(movie.id, 169);
      expect(movie.title, 'Breaking Bad');
      expect(movie.ratingText, '9.2');
      expect(movie.releaseYear, '2008');
      expect(movie.overview, 'A chemistry teacher diagnosed with terminal lung cancer.');
      expect(movie.posterUrl, 'https://static.tvmaze.com/uploads/images/medium_portrait/0/2400.jpg');
      expect(movie.backdropUrl, 'https://static.tvmaze.com/uploads/images/original_untouched/0/2400.jpg');
      expect(movie.genreNames, contains('Drama'));
      expect(movie.genreNames, contains('Crime'));
    });

    test('fromJson parses TVMaze search result correctly', () {
      final json = {
        'score': 0.95,
        'show': {
          'id': 50745,
          'name': 'The Godfather',
          'premiered': '2017-01-15',
          'genres': ['Action', 'Crime'],
          'rating': {'average': 8.5},
          'image': {
            'medium': 'https://static.tvmaze.com/uploads/images/medium_portrait/275/688576.jpg',
            'original': 'https://static.tvmaze.com/uploads/images/original_untouched/275/688576.jpg',
          },
          'summary': '<p>The story of a family.</p>',
        }
      };

      final movie = MovieModel.fromJson(json);

      expect(movie.id, 50745);
      expect(movie.title, 'The Godfather');
      expect(movie.overview, 'The story of a family.');
      expect(movie.ratingText, '8.5');
    });
  });

  group('MovieCredits & CastMember TVMaze Tests', () {
    test('MovieCredits parses TVMaze cast list properly', () {
      final json = [
        {
          'person': {
            'id': 1,
            'name': 'Bryan Cranston',
            'image': {
              'medium': 'https://static.tvmaze.com/uploads/images/medium_portrait/0/1815.jpg',
            }
          },
          'character': {
            'name': 'Walter White',
          }
        }
      ];

      final credits = MovieCredits.fromJson(json);

      expect(credits.cast.length, 1);
      expect(credits.cast.first.name, 'Bryan Cranston');
      expect(credits.cast.first.character, 'Walter White');
      expect(credits.cast.first.profileImageUrl, 'https://static.tvmaze.com/uploads/images/medium_portrait/0/1815.jpg');
    });
  });

  group('LocalStorageManager Export & Import Tests', () {
    test('Export and import bookmarks preserves integrity', () {
      LocalStorageManager.clearAll();

      final movie = MovieModel(
        id: 999,
        title: 'Interstellar',
        originalTitle: 'Interstellar',
        voteAverage: 8.6,
        watchlistStatus: 'favorite',
      );

      LocalStorageManager.setMovieStatus(movie, 'favorite');
      expect(LocalStorageManager.isBookmarked(999), isTrue);

      final exportedJson = LocalStorageManager.exportBookmarksJson();
      expect(exportedJson, contains('Interstellar'));
      expect(exportedJson, contains('999'));

      LocalStorageManager.clearAll();
      expect(LocalStorageManager.isBookmarked(999), isFalse);

      final importedCount = LocalStorageManager.importBookmarksJson(exportedJson);
      expect(importedCount, 1);
      expect(LocalStorageManager.isBookmarked(999), isTrue);
    });
  });
}
