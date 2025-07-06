import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/movie_details.dart';

class MoviesDetailsPage extends StatelessWidget {
  final controller = Get.put(MovieDetailsController());

  MoviesDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Hero(
                      tag: controller.movie.id,
                      child: Image.network(
                        controller.posterUrl,
                        height: 350,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 350,
                          color: Colors.grey.shade800,
                          child: const Icon(Icons.movie, size: 100),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 350,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black, Colors.transparent],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 8,
                    top: 8,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: 'Back',
                    ),
                  ),
                  Positioned(
                    right: 56,
                    top: 8,
                    child: IconButton(
                      icon: const Icon(Icons.share, color: Colors.white),
                      onPressed: () => controller.shareMovie(context),
                      tooltip: 'Share',
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Obx(() => IconButton(
                          icon: Icon(
                            controller.isFavorite.value
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red,
                          ),
                          onPressed: controller.toggleFavorite,
                          tooltip: 'Favorite',
                        )),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Text(
                      controller.title,
                      style: textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          controller.vote,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(controller.releaseDate),
                    avatar: const Icon(Icons.calendar_today, size: 16),
                    backgroundColor: colorScheme.surfaceContainerHighest,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                controller.movie.originalTitle,
                style: textTheme.titleMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.trending_up, color: Colors.green, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'Popularity: ${controller.movie.popularity?.toStringAsFixed(0)}',
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Overview',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF110E47),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                controller.overview,
                style: textTheme.bodyLarge
                    ?.copyWith(height: 1.5, color: Colors.grey.shade800),
              ),
              const SizedBox(height: 24),
              if (controller.genres.isNotEmpty) ...[
                Text(
                  'Genres',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF110E47),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: controller.genres.map((name) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDBE3FF), // #DBE3FF
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        name,
                        style: textTheme.labelSmall?.copyWith(
                          color: const Color(0xFF88A4E8),
                          fontSize: 12,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 32),
              Text(
                'Cast',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF110E47),
                ),
              ),
              const SizedBox(height: 12),
              Obx(() {
                if (controller.castList.isEmpty) {
                  return Text('No cast found');
                }
                return SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.castList.length,
                    itemBuilder: (context, index) {
                      final cast = controller.castList[index];
                      return Container(
                        width: 80,
                        margin: const EdgeInsets.only(right: 12),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: cast.profilePath != null
                                  ? NetworkImage(
                                      'https://image.tmdb.org/t/p/w200${cast.profilePath}')
                                  : const AssetImage(
                                          'assets/images/default_avatar.png')
                                      as ImageProvider,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              cast.name,
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              cast.character ?? '',
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
