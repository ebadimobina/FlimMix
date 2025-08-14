import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/shimmer.dart';
import 'package:flimmix/controllers/top_rate_movie.dart';

import '../movie_details/movies_details_page.dart';

class TopRatedMovies extends StatelessWidget {
  final TopRateMovieController controller = Get.find<TopRateMovieController>();
  final VoidCallback? onSeeMore;
  TopRatedMovies({super.key, this.onSeeMore});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top Rate',
                  style: textTheme.headlineSmall?.copyWith(
                    fontFamily: 'Mulish',
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF110E47),
                  ),
                ),
                GestureDetector(
                  onTap: onSeeMore,
                  child: Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFE5E4EA)),
                      borderRadius:
                          BorderRadius.circular(100), // border-radius: 100px
                    ),
                    child: Text(
                      'See All',
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
          SizedBox(height: 12),
          SizedBox(
            height: 290,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: min(12, controller.itemCount),
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                if (controller.isLoading.value) {
                  return Container(
                    width: 160,
                    margin: EdgeInsets.only(right: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerLoadingBox(width: 160, height: 240),
                         SizedBox(height: 8),
                        ShimmerLoadingBox(width: 120, height: 20),
                         SizedBox(height: 6),
                        ShimmerLoadingBox(width: 60, height: 14),
                      ],
                    ),
                  );
                } else {
                  final poster = controller.posterUrl(index);
                  final title = controller.movieTitle(index);
                  final rating = controller.movieRating(index);
                  controller.movieAt(index);
                  return GestureDetector(
                    onTap: () {
                      final selectedMovie = controller.movieAt(index);
                      if (selectedMovie != null) {
                        Get.to(() => MoviesDetailsPage(),
                            arguments: selectedMovie);
                      }
                    },
                    child: Container(
                      width: 160,
                      margin: EdgeInsets.only(right: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 2 / 3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: poster.isEmpty
                                  ? Container(
                                      color: Colors.grey[300],
                                      height: 290,
                                      alignment: Alignment.center,
                                      child: Icon(Icons.broken_image,
                                          size: 50, color: Colors.grey),
                                    )
                                  : Image.network(poster,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          Container(color: Colors.grey)),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Mulish',
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.02,
                            ),
                          ),
                          SizedBox(height: 3),
                          Row(
                            children: [
                               Icon(Icons.star,
                                  color: Colors.amber, size: 14),
                               SizedBox(width: 4),
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
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      );
    });
  }
}
