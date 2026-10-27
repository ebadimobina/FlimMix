import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/movie_details.dart';
import '../../../core/router/movie_routes.dart';
import '../../../core/widgets/shimmer.dart';

class MoviesDetailsPage extends StatelessWidget {
  const MoviesDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<MovieDetailsController>()
        ? Get.find<MovieDetailsController>()
        : Get.put(MovieDetailsController());

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;
    final placeholderColor = isDark ? const Color(0xFF1B2332) : Colors.grey.shade200;
    final placeholderIconColor = isDark ? Colors.grey.shade600 : Colors.grey;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => controller.shareMovie(context),
            tooltip: 'Share',
          ),
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: controller.searchOnline,
            tooltip: 'Search Online',
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Banner with Gradient
              Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (controller.backdropUrl != null)
                      CachedNetworkImage(
                        imageUrl: controller.backdropUrl!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const ShimmerLoadingBox(
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: placeholderColor,
                          child: Icon(Icons.movie_creation_outlined, size: 64, color: placeholderIconColor),
                        ),
                      )
                    else
                      Container(
                        color: placeholderColor,
                        child: Icon(Icons.movie_creation_outlined, size: 64, color: placeholderIconColor),
                      ),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black87, Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops: [0.0, 0.65],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            controller.title,
                            style: textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: const [
                                Shadow(color: Colors.black, blurRadius: 6, offset: Offset(0, 2)),
                              ],
                            ),
                          ),
                          if (controller.year != '----')
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                controller.year,
                                style: const TextStyle(color: Colors.white70, fontSize: 13),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Watchlist Status Action Buttons (3-tier)
              Obx(() {
                final status = controller.currentStatus.value;

                return Row(
                  children: [
                    Expanded(
                      child: _buildStatusButton(
                        context: context,
                        icon: Icons.favorite,
                        label: 'Favorite',
                        isSelected: status == 'favorite',
                        activeColor: Colors.redAccent,
                        onTap: () => controller.setWatchlistStatus('favorite'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatusButton(
                        context: context,
                        icon: Icons.bookmark,
                        label: 'Watchlist',
                        isSelected: status == 'watchlist',
                        activeColor: const Color(0xFF5A7ED0),
                        onTap: () => controller.setWatchlistStatus('watchlist'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildStatusButton(
                        context: context,
                        icon: Icons.check_circle,
                        label: 'Watched',
                        isSelected: status == 'watched',
                        activeColor: Colors.green,
                        onTap: () => controller.setWatchlistStatus('watched'),
                      ),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 16),

              // Rating and Release Date Info Bar
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '${controller.vote} / 10',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          controller.releaseDate,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Genres
              if (controller.genres.isNotEmpty) ...[
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: controller.genres.map((name) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: isDark ? 0.2 : 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        name,
                        style: TextStyle(
                          color: isDark ? const Color(0xFF6B8AFF) : theme.colorScheme.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],

              const SizedBox(height: 20),

              // Overview Section
              const Text(
                'Overview',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                controller.overview,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                ),
              ),

              const SizedBox(height: 24),

              // Cast Section
              const Text(
                'Cast & Crew',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 12),
              Obx(() {
                if (controller.isLoadingCast.value) {
                  return SizedBox(
                    height: 140,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      separatorBuilder: (_, __) => const SizedBox(width: 14),
                      itemBuilder: (_, __) => const Column(
                        children: [
                          ShimmerLoadingBox(width: 72, height: 72, borderRadius: BorderRadius.all(Radius.circular(36))),
                          SizedBox(height: 8),
                          ShimmerLoadingBox(width: 60, height: 12),
                          SizedBox(height: 4),
                          ShimmerLoadingBox(width: 45, height: 10),
                        ],
                      ),
                    ),
                  );
                }

                if (controller.castList.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'No cast information available.',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                    ),
                  );
                }

                return SizedBox(
                  height: 155,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.castList.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 14),
                    itemBuilder: (context, index) {
                      final cast = controller.castList[index];
                      return SizedBox(
                        width: 76,
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 36,
                              backgroundColor: placeholderColor,
                              child: cast.profileImageUrl != null
                                  ? ClipOval(
                                      child: CachedNetworkImage(
                                        imageUrl: cast.profileImageUrl!,
                                        width: 72,
                                        height: 72,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Icon(
                                          Icons.person,
                                          size: 36,
                                          color: placeholderIconColor,
                                        ),
                                        errorWidget: (context, url, error) => Icon(
                                          Icons.person,
                                          size: 36,
                                          color: placeholderIconColor,
                                        ),
                                      ),
                                    )
                                  : Icon(Icons.person, size: 36, color: placeholderIconColor),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              cast.name,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (cast.character != null && cast.character!.isNotEmpty)
                              Text(
                                cast.character!,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }),

              const SizedBox(height: 24),

              // More Like This Section
              Obx(() {
                if (controller.similarMovies.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'More Like This',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 180,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.similarMovies.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final similar = controller.similarMovies[index];

                          return GestureDetector(
                            onTap: () {
                              Get.toNamed(MovieRoutes.movieDetails, arguments: similar, preventDuplicates: false);
                            },
                            child: SizedBox(
                              width: 110,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: similar.posterUrl != null
                                        ? CachedNetworkImage(
                                            imageUrl: similar.posterUrl!,
                                            width: 110,
                                            height: 145,
                                            fit: BoxFit.cover,
                                            placeholder: (_, __) => const ShimmerLoadingBox(width: 110, height: 145),
                                            errorWidget: (_, __, ___) => Container(
                                              width: 110,
                                              height: 145,
                                              color: placeholderColor,
                                              child: Icon(Icons.movie_outlined, color: placeholderIconColor),
                                            ),
                                          )
                                        : Container(
                                            width: 110,
                                            height: 145,
                                            color: placeholderColor,
                                            child: Icon(Icons.broken_image, color: placeholderIconColor),
                                          ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    similar.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
              }),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isSelected,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withValues(alpha: 0.15) : theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? activeColor : theme.dividerColor,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? activeColor : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? activeColor : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
