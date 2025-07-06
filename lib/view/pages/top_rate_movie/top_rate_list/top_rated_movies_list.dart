import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/shimmer.dart';
import 'package:flimmix/controllers/top_rate_movie.dart';

import '../../movie_details/movies_details_page.dart';

class TopRatedMoviesList extends StatelessWidget {
  final TopRateMovieController controller = Get.find<TopRateMovieController>();

  TopRatedMoviesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Movies'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoadingNow) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              itemCount: controller.itemCount,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.55,
              ),
              itemBuilder: (_, __) {
                return ShimmerLoadingBox(
                  borderRadius: BorderRadius.circular(12),
                  width: double.infinity,
                  height: double.infinity,
                );
              },
            ),
          );
        }

        if (!controller.hasMovies) {
          return Center(
            child: Text(
              'No movies found.',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            itemCount: controller.itemCount,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.55,
            ),
            itemBuilder: (context, index) {
              final poster = controller.posterUrl(index);
              final title = controller.movieTitle(index);
              final rating = controller.movieRating(index);
              return InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () {
                  final selectedMovie = controller.movieAt(index);
                  if (selectedMovie != null) {
                    Get.to(() => MoviesDetailsPage(), arguments: selectedMovie);
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: poster.isEmpty
                          ? Container(
                              color: Colors.grey[300],
                              height: 290,
                              alignment: Alignment.center,
                              child: const Icon(Icons.broken_image,
                                  size: 50, color: Colors.grey),
                            )
                          : Image.network(
                              poster,
                              width: double.infinity,
                              height: 290,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: Colors.grey[300],
                                height: 220,
                                alignment: Alignment.center,
                                child: const Icon(Icons.broken_image,
                                    size: 50, color: Colors.grey),
                              ),
                            ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          rating,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
