import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../controllers/bookmark_movie.dart';
import '../../../model/dto/movie.dart';
import '../movie_details/movies_details_page.dart';

class BookMarkMoviesPage extends StatelessWidget {
  final BookMarkMoviesController controller = Get.put(BookMarkMoviesController());
  BookMarkMoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bookmarked Movies',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Color(0xFF110E47),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        final favorites = controller.favoritesMovies;
        if (favorites.isEmpty) {
          return Center(child: Text('No bookmarked movies'));
        }

        return ListView.builder(
          itemCount: favorites.length,
          padding: EdgeInsets.symmetric(vertical: 8),
          itemBuilder: (context, index) {
            final item = favorites[index];
            final movie = MovieModel(
              id: item['id'],
              title: item['title'],
              posterPath: item['posterPath'],
              voteAverage: item['voteAverage'],
              releaseDate: item['releaseDate'] != null
                  ? DateTime.tryParse(item['releaseDate'])
                  : null,
              overview: item['overview'],
              genreIds: List<int>.from(item['genreIds']),
              backdropPath: item['backdropPath'],
              popularity: item['popularity'],
              originalTitle: item['originalTitle'] ?? '',
            );

            final rating = movie.voteAverage?.toStringAsFixed(1) ?? 'N/A';

            return GestureDetector(
              onTap: () async {
                await Get.to(() => MoviesDetailsPage(), arguments: movie);
                controller.refreshFavorites();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: movie.posterPath == null
                          ? Container(
                        width: 100,
                        height: 140,
                        color: Colors.grey[300],
                        child: Icon(Icons.broken_image,
                            size: 40, color: Colors.grey),
                      )
                          : CachedNetworkImage(
                        imageUrl: 'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                        width: 100,
                        height: 140,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(color: Colors.grey[300]),
                        errorWidget: (context, url, error) =>
                            Container(color: Colors.grey),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 5),
                          if (movie.overview != null && movie.overview!.isNotEmpty)
                            Text(
                              movie.overview!,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                                height: 1.4,
                              ),
                            ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 14),
                              SizedBox(width: 4),
                              Text(
                                '$rating / 10',
                                style: TextStyle(
                                  fontSize: 12,
                                  height: 1.25,
                                  color: Color(0xFF9C9C9C),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
