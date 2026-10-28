import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/popular_movie.dart';
import '../../../core/router/movie_routes.dart';
import '../../../core/widgets/shimmer.dart';

class PopularMovies extends StatelessWidget {
  final PopularMovieController controller = Get.find<PopularMovieController>();
  final VoidCallback? onSeeMore;

  PopularMovies({super.key, this.onSeeMore});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.isRegistered<HomeController>() ? Get.find<HomeController>() : null;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final placeholderColor = isDark ? const Color(0xFF1B2332) : Colors.grey.shade200;
    final placeholderIconColor = isDark ? Colors.grey.shade600 : Colors.grey;

    return Obx(() {
      final selectedGenre = homeController?.selectedGenre.value ?? 'All';
      final filteredMovies = selectedGenre == 'All'
          ? controller.popularMovie
          : controller.popularMovie
              .where((m) => m.genreNames
                  .any((g) => g.toLowerCase() == selectedGenre.toLowerCase()))
              .toList();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Popular',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (selectedGenre != 'All') ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: isDark ? 0.2 : 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          selectedGenre,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? const Color(0xFF6B8AFF) : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: onSeeMore,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).dividerColor),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'See more',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (controller.isLoading.value)
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, __) => const Row(
                children: [
                  ShimmerLoadingBox(width: 85, height: 120),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerLoadingBox(width: double.infinity, height: 18),
                        SizedBox(height: 8),
                        ShimmerLoadingBox(width: 140, height: 14),
                        SizedBox(height: 8),
                        ShimmerLoadingBox(width: 60, height: 14),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else if (filteredMovies.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Text(
                'No $selectedGenre titles found in Popular.',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: min(6, filteredMovies.length),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final movie = filteredMovies[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    Get.toNamed(MovieRoutes.movieDetails, arguments: movie);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Theme.of(context).dividerColor),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: movie.posterUrl == null
                              ? Container(
                                  width: 80,
                                  height: 115,
                                  color: placeholderColor,
                                  child: Icon(Icons.broken_image, size: 36, color: placeholderIconColor),
                                )
                              : CachedNetworkImage(
                                  imageUrl: movie.posterUrl!,
                                  width: 80,
                                  height: 115,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const ShimmerLoadingBox(
                                    width: 80,
                                    height: 115,
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    width: 80,
                                    height: 115,
                                    color: placeholderColor,
                                    child: Icon(Icons.movie_outlined, color: placeholderIconColor),
                                  ),
                                ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                movie.overview ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (movie.genreNames.isNotEmpty)
                                Wrap(
                                  spacing: 6,
                                  children: movie.genreNames.take(2).map((name) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.primary.withValues(alpha: isDark ? 0.2 : 0.1),
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      child: Text(
                                        name,
                                        style: TextStyle(
                                          color: isDark ? const Color(0xFF6B8AFF) : Theme.of(context).colorScheme.primary,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${movie.ratingText} / 10',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    movie.releaseYear,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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
