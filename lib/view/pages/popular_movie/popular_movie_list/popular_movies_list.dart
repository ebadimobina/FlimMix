import 'package:flimmix/view/pages/movie_details/movies_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../controllers/popular_movie.dart';
import '../../../../core/widgets/shimmer.dart';

class PopularMoviesList extends StatelessWidget {
  final PopularMovieController controller = Get.find<PopularMovieController>();
  PopularMoviesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Popular Movies',
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Color(0xFF110E47),
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
                              height: 270,
                              alignment: Alignment.center,
                              child: const Icon(Icons.broken_image,
                                  size: 50, color: Colors.grey),
                            )
                          : CachedNetworkImage(
                              imageUrl: poster,
                              width: double.infinity,
                              height: 270,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Container(color: Colors.grey[300]),
                              errorWidget: (context, url, error) => Container(
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
