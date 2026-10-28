import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/top_rate_movie.dart';
import '../../../core/router/movie_routes.dart';
import '../../../core/widgets/shimmer.dart';

class TopRatedMovies extends StatelessWidget {
  final TopRateMovieController controller = Get.find<TopRateMovieController>();
  final VoidCallback? onSeeMore;

  TopRatedMovies({super.key, this.onSeeMore});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.isRegistered<HomeController>() ? Get.find<HomeController>() : null;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final placeholderColor = isDark ? const Color(0xFF1B2332) : Colors.grey.shade200;
    final placeholderIconColor = isDark ? Colors.grey.shade600 : Colors.grey;

    return Obx(() {
      final selectedGenre = homeController?.selectedGenre.value ?? 'All';
      final filteredMovies = selectedGenre == 'All'
          ? controller.topMovies
          : controller.topMovies
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
                      'Top Rated',
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
                      'See All',
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
            SizedBox(
              height: 250,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, __) => const SizedBox(
                  width: 135,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerLoadingBox(width: 135, height: 190),
                      SizedBox(height: 8),
                      ShimmerLoadingBox(width: 100, height: 16),
                      SizedBox(height: 4),
                      ShimmerLoadingBox(width: 50, height: 14),
                    ],
                  ),
                ),
              ),
            )
          else if (filteredMovies.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Text(
                'No $selectedGenre titles found in Top Rated.',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
              ),
            )
          else
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: min(12, filteredMovies.length),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final movie = filteredMovies[index];

                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(MovieRoutes.movieDetails, arguments: movie);
                    },
                    child: Container(
                      width: 135,
                      margin: const EdgeInsets.only(right: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: movie.posterUrl == null
                                ? Container(
                                    width: 135,
                                    height: 190,
                                    color: placeholderColor,
                                    child: Icon(Icons.broken_image, size: 36, color: placeholderIconColor),
                                  )
                                : CachedNetworkImage(
                                    imageUrl: movie.posterUrl!,
                                    width: 135,
                                    height: 190,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const ShimmerLoadingBox(
                                      width: 135,
                                      height: 190,
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                      width: 135,
                                      height: 190,
                                      color: placeholderColor,
                                      child: Icon(Icons.movie_outlined, color: placeholderIconColor),
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            movie.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${movie.ratingText}/10',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      );
    });
  }
}
