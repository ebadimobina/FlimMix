import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/popular_movie.dart';
import '../../../controllers/top_rate_movie.dart';
import '../../../core/router/movie_routes.dart';
import '../about/about.dart';
import '../bookmark_movies/bookmark_movies.dart';
import '../popular_movie/popular_movies.dart';
import '../search/search_movies.dart';
import '../top_rate_movie/top_rated_movies.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    const List<Widget> pages = [
      HomeContent(),
      SearchMoviesPage(isEmbedded: true),
      BookMarkMoviesPage(isEmbedded: true),
    ];

    final titles = ['FilmMix', 'Search Movies', 'Library & Watchlist'];

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            titles[controller.currentIndex.value],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: 'Settings',
              onPressed: () => Get.toNamed(MovieRoutes.settings),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              onSelected: (value) {
                if (value == 'about') {
                  Get.to(() => const AboutMePage());
                } else if (value == 'settings') {
                  Get.toNamed(MovieRoutes.settings);
                } else if (value == 'exit') {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: const Text('Exit App'),
                      content: const Text('Are you sure you want to exit FilmMix?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => SystemNavigator.pop(),
                          child: const Text(
                            'Exit',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'settings',
                  child: Row(
                    children: [
                      Icon(Icons.settings_outlined, size: 20),
                      SizedBox(width: 10),
                      Text('Settings', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'about',
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 20),
                      SizedBox(width: 10),
                      Text('About Developer', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'exit',
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app, size: 20, color: Colors.redAccent),
                      SizedBox(width: 10),
                      Text('Exit', style: TextStyle(fontSize: 14, color: Colors.redAccent)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          type: BottomNavigationBarType.fixed,
          elevation: 4,
          onTap: (index) {
            controller.changePage(index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.movie_outlined),
              activeIcon: Icon(Icons.movie),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmarks_outlined),
              activeIcon: Icon(Icons.bookmarks),
              label: 'Watchlist',
            ),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();
    final topRateController = Get.find<TopRateMovieController>();
    final popularController = Get.find<PopularMovieController>();

    return RefreshIndicator(
      onRefresh: () async {
        await Future.wait([
          topRateController.fetchTopRated(),
          popularController.fetchPopularMovies(),
        ]);
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          // Genre Chips Filter Bar
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              itemCount: homeController.availableGenres.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final genre = homeController.availableGenres[index];
                final theme = Theme.of(context);
                final isDark = theme.brightness == Brightness.dark;

                return Obx(() {
                  final isSelected = homeController.selectedGenre.value == genre;
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
                        homeController.selectGenre(genre);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                          genre,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),

          const SizedBox(height: 8),

          TopRatedMovies(
            onSeeMore: () => Get.toNamed(MovieRoutes.topRateMovie),
          ),
          const SizedBox(height: 16),
          PopularMovies(
            onSeeMore: () => Get.toNamed(MovieRoutes.popularMovie),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
