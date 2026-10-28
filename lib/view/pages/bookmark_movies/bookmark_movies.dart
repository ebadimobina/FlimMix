import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/bookmark_movie.dart';
import '../../../core/router/movie_routes.dart';
import '../../../core/widgets/shimmer.dart';

class BookMarkMoviesPage extends StatelessWidget {
  final bool isEmbedded;
  const BookMarkMoviesPage({super.key, this.isEmbedded = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<BookMarkMoviesController>()
        ? Get.find<BookMarkMoviesController>()
        : Get.put(BookMarkMoviesController());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final placeholderColor = isDark ? const Color(0xFF1B2332) : Colors.grey.shade200;
    final placeholderIconColor = isDark ? Colors.grey.shade600 : Colors.grey;

    final content = Column(
      children: [
        // Category Filter Chips
        Obx(() {
          final total = controller.allBookmarks.length;
          final favs = controller.favoritesCount;
          final watchlist = controller.watchlistCount;
          final watched = controller.watchedCount;

          final filters = [
            {'key': 'all', 'label': 'All ($total)'},
            {'key': 'favorite', 'label': 'Favorites ($favs)'},
            {'key': 'watchlist', 'label': 'Watchlist ($watchlist)'},
            {'key': 'watched', 'label': 'Watched ($watched)'},
          ];

          return Container(
            height: 48,
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final f = filters[index];
                final isSelected = controller.selectedFilter.value == f['key'];
                final activeBg = theme.colorScheme.primary;
                final inactiveBg = theme.cardColor;
                final activeBorder = theme.colorScheme.primary;
                final inactiveBorder = theme.dividerColor;
                final textColor = isSelected
                    ? Colors.white
                    : (isDark ? Colors.grey.shade300 : const Color(0xFF374151));

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      controller.setFilter(f['key']!);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected ? activeBg : inactiveBg,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? activeBorder : inactiveBorder,
                          width: 1.2,
                        ),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: activeBg.withValues(alpha: isDark ? 0.35 : 0.25),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            )
                          else if (!isDark)
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        f['label']!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }),

        // Movies List
        Expanded(
          child: Obx(() {
            final movies = controller.filteredMovies;
            if (movies.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.bookmarks_outlined,
                      size: 64,
                      color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No titles in this list',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add titles to your Favorites, Watchlist or Watched list.',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              itemCount: movies.length,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final movie = movies[index];

                return Dismissible(
                  key: Key('bookmark_${movie.id}'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
                  ),
                  onDismissed: (_) {
                    controller.removeBookmark(movie);
                    Get.snackbar(
                      'Removed',
                      '${movie.title} removed from library.',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                    );
                  },
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () async {
                      await Get.toNamed(MovieRoutes.movieDetails, arguments: movie);
                      controller.refreshFavorites();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: theme.dividerColor),
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
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        movie.title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    _buildStatusBadge(movie.watchlistStatus),
                                  ],
                                ),
                                const SizedBox(height: 6),
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
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
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
                                        fontSize: 12,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.redAccent,
                                        size: 20,
                                      ),
                                      tooltip: 'Remove',
                                      onPressed: () {
                                        controller.removeBookmark(movie);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );

    if (isEmbedded) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Library & Watchlist'),
      ),
      body: content,
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case 'favorite':
        color = Colors.redAccent;
        text = 'Favorite';
        icon = Icons.favorite;
        break;
      case 'watched':
        color = Colors.green;
        text = 'Watched';
        icon = Icons.check_circle;
        break;
      default:
        color = const Color(0xFF5A7ED0);
        text = 'Watchlist';
        icon = Icons.bookmark;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
