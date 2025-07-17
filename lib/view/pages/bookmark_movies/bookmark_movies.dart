import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../model/dto/movie.dart';
import '../movie_details/movies_details_page.dart';

class BookMarkMoviesPage extends StatelessWidget {
   const BookMarkMoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final storage = GetStorage();
    final List<dynamic> favorites = storage.read<List<dynamic>>('favorite_movies') ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bookmarked Movies',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF110E47),
          ),
        ),
      ),
      body: favorites.isEmpty
          ? const Center(child: Text('No bookmarked movies'))
          : ListView.builder(
        itemCount: favorites.length,
        padding: const EdgeInsets.symmetric(vertical: 8),
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
            onTap: () {
              Get.to(() => MoviesDetailsPage(), arguments: movie);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      child: const Icon(Icons.broken_image,
                          size: 40, color: Colors.grey),
                    )
                        : Image.network(
                      'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                      width: 100,
                      height: 140,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
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
                        // const SizedBox(height: 10),
                        // if (movie.genreIds.isNotEmpty)
                        //   Wrap(
                        //     spacing: 10,
                        //     runSpacing: 10,
                        //     children: movie.genreIds.take(2).map((id) {
                        //       final genres = controller.genresAt(index);
                        //       return Container(
                        //         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        //         decoration: BoxDecoration(
                        //           color: const Color(0xFFDBE3FF),
                        //           borderRadius: BorderRadius.circular(100),
                        //         ),
                        //         child: Text(
                        //           genres,
                        //           style: textTheme.labelSmall?.copyWith(
                        //             color: const Color(0xFF88A4E8),
                        //             fontSize: 12,
                        //           ),
                        //         ),
                        //       );
                        //     }).toList(),
                        //   ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              '$rating / 10',
                              style: const TextStyle(
                                fontSize: 12,
                                height: 1.25,
                                color: Color(0xFF9C9C9C),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}
