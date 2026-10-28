import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/top_rate_movie.dart';
import '../../../../core/widgets/movie_card.dart';

class TopRatedMoviesList extends StatelessWidget {
  const TopRatedMoviesList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TopRateMovieController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rated Movies'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.errorMessage.value.isNotEmpty && controller.topMovies.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                  const SizedBox(height: 12),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: controller.fetchTopRated,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          color: Theme.of(context).colorScheme.primary,
          onRefresh: controller.fetchTopRated,
          child: buildMoviesGrid(
            movies: controller.topMovies,
            isLoading: controller.isLoadingNow,
            emptyMessage: 'No top-rated movies found.',
          ),
        );
      }),
    );
  }
}
