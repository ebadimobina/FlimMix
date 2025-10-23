import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF110E47)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: Color(0xFF110E47)),
            onPressed: () => controller.shareMovie(context),
          ),
          Obx(
            () => IconButton(
              icon: Icon(
                  controller.isFav.value == true
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: controller.isFav.value == true
                      ? Colors.red
                      :  Color(0xFF110E47)),
              onPressed: controller.toggleFavorite,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Hero(
                      tag: controller.movie.id,
                      child: CachedNetworkImage(
                        imageUrl: controller.posterUrl,
                        height: 350,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          height: 350,
                          color: Colors.grey.shade300,
                          child: Icon(Icons.movie, size: 100),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 350,
                          color: Colors.grey.shade800,
                          child: Icon(Icons.movie, size: 100),
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
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 20),
                        SizedBox(width: 6),
                        Text(
                          controller.vote,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(controller.releaseDate),
                    avatar: Icon(Icons.calendar_today, size: 16),
                    backgroundColor: colorScheme.surfaceContainerHighest,
                  ),
                ],
              ),
              SizedBox(height: 24),
              Text(
                controller.movie.originalTitle,
                style: textTheme.titleMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.trending_up, color: Colors.green, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Popularity: ${controller.movie.popularity?.toStringAsFixed(0)}',
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
              SizedBox(height: 24),
              Text(
                'Overview',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF110E47),
                ),
              ),
              SizedBox(height: 8),
              Text(
                controller.overview,
                style: textTheme.bodyLarge
                    ?.copyWith(height: 1.5, color: Colors.grey.shade800),
              ),
              SizedBox(height: 24),
              if (controller.genres.isNotEmpty) ...[
                Text(
                  'Genres',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF110E47),
                  ),
                ),
                SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: controller.genres.map((name) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Color(0xFFDBE3FF), // #DBE3FF
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        name,
                        style: textTheme.labelSmall?.copyWith(
                          color: Color(0xFF88A4E8),
                          fontSize: 12,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
              SizedBox(height: 32),
              Text(
                'Cast',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF110E47),
                ),
              ),
              SizedBox(height: 12),
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
                        margin: EdgeInsets.only(right: 12),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              child: cast.profilePath != null
                                  ? ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: 'https://image.tmdb.org/t/p/w200${cast.profilePath}',
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Icon(Icons.person, size: 40),
                                        errorWidget: (context, url, error) => Icon(Icons.person, size: 40),
                                      ),
                                    )
                                  : Icon(Icons.person, size: 40),
                            ),
                            SizedBox(height: 4),
                            Text(
                              cast.name,
                              style: TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              cast.character ?? '',
                              style: TextStyle(
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
