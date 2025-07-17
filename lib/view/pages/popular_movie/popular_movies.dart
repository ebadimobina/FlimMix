import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/popular_movie.dart';
import '../../../core/widgets/shimmer.dart';
import '../movie_details/movies_details_page.dart';

class PopularMovies extends StatelessWidget {
  final PopularMovieController controller = Get.find<PopularMovieController>();
  final VoidCallback? onSeeMore;

  PopularMovies({super.key, this.onSeeMore});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Popular',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF110E47),
                  ),
                ),
                GestureDetector(
                  onTap: onSeeMore,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE5E4EA)),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Text(
                      'See more',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFAAA9B1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          controller.isLoading.value
              ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            itemBuilder: (_, __) => Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  ShimmerLoadingBox(width: 100, height: 140),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerLoadingBox(
                            width: double.infinity, height: 20),
                        const SizedBox(height: 6),
                        ShimmerLoadingBox(width: 150, height: 14),
                        const SizedBox(height: 6),
                        ShimmerLoadingBox(width: 80, height: 14),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
              : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: min(6, controller.itemCount),
            itemBuilder: (context, index) {
              final movie = controller.movieAt(index);
              final poster = controller.posterUrl(index);
              final title = controller.movieTitle(index);
              final rating = controller.movieRating(index);
              final genres = controller.genresAt(index);

              return GestureDetector(
                onTap: () {
                  if (movie != null) {
                    Get.to(() => MoviesDetailsPage(), arguments: movie);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: poster.isEmpty
                            ? Container(
                          width: 100,
                          height: 140,
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image,
                              size: 40, color: Colors.grey),
                        )
                            : Image.network(
                          poster,
                          width: 100,
                          height: 140,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Mulish',
                                  fontWeight: FontWeight.w500,
                                )),
                            const SizedBox(height: 5),
                            if (movie?.overview != null && movie!.overview!.isNotEmpty)
                              Text(
                                movie.overview!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                  height: 1.4,
                                ),
                              ),
                            const SizedBox(height: 10),
                            if (genres.isNotEmpty)
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: genres.take(2).map((name) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFDBE3FF),
                                      borderRadius:
                                      BorderRadius.circular(100),
                                    ),
                                    child: Text(
                                      name,
                                      style:
                                      textTheme.labelSmall?.copyWith(
                                        color: const Color(0xFF88A4E8),
                                        fontSize: 12,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            const SizedBox(height: 22),
                            Row(
                              children: [
                                const Icon(Icons.star,
                                    color: Colors.amber, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  rating,
                                  style: TextStyle(
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
        ],
      );
    });
  }
}