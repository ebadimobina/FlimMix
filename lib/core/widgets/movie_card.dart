import 'package:flimmix/core/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/dto/movie.dart';
import '../../view/pages/movie_details/movies_details_page.dart';

class MovieCard extends StatelessWidget {
  final dynamic movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final posterPath = movie['poster_path'];
    final imageUrl = posterPath != null
        ? 'https://image.tmdb.org/t/p/w500$posterPath'
        : null;

    return GestureDetector(
        onTap: () {
          final movieModel = MovieModel.fromJson(movie);
          Get.to(() => MoviesDetailsPage(), arguments: movieModel);
        },
        child: Card(
          elevation: 4,
          clipBehavior: Clip.antiAlias,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (imageUrl != null)
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    return progress == null
                        ? child
                        : const Center(
                            child: CircularProgressIndicator(strokeWidth: 2));
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.movie_creation_outlined,
                        color: Colors.grey, size: 50);
                  },
                )
              else
                const Center(
                    child: Icon(Icons.movie_creation_outlined,
                        color: Colors.grey, size: 50)),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black, Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    stops: const [0.0, 0.4],
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                right: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie['title'] ?? 'No title',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        shadows: [Shadow(blurRadius: 2, color: Colors.black)],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          movie['vote_average']?.toStringAsFixed(1) ?? 'N/A',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            shadows: [
                              Shadow(blurRadius: 2, color: Colors.black)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

Widget buildMoviesGrid({
  required String title,
  required List<dynamic> movies,
  bool isLoading = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (title.isNotEmpty)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      Expanded(
        child: GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.88,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: isLoading ? 6 : movies.length,
          itemBuilder: (context, index) {
            if (isLoading) {
              return const ShimmerLoadingBox(
                  width: double.infinity, height: double.infinity);
            }
            final movie = movies[index];
            return LayoutBuilder(
              builder: (context, constraints) {
                final screenHeight = MediaQuery.of(context).size.height;
                final cardHeight = (screenHeight - kToolbarHeight - 100) / 4;
                final cardWidth = constraints.maxWidth;
                final aspectRatio = cardWidth / cardHeight;

                return AspectRatio(
                  aspectRatio: aspectRatio,
                  child: MovieCard(movie: movie),
                );
              },
            );
          },
        ),
      ),
    ],
  );
}
