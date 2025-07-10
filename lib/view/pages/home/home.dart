import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/popular_movie.dart';
import '../popular_movie/popular_movie_list/popular_movies_list.dart';
import '../popular_movie/popular_movies.dart';
import '../search/search_movies.dart';
import '../top_rate_movie/top_rate_list/top_rated_movies_list.dart';
import '../top_rate_movie/top_rated_movies.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());
    Get.put(PopularMovieController());

    final List<Widget> pages = [
      const HomeContent(),
      SearchMoviesPage(),
    ];

    return Obx(() => Scaffold(
          appBar: AppBar(
            title: Text(
              homeController.currentIndex.value == 0
                  ? 'FilmMix'
                  : 'Search Movies',
              style: const TextStyle(
                color: Color(0xFF110E47),
              ),
            ),
            centerTitle: true,
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.black),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                elevation: 3,
                onSelected: (value) {},
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'settings',
                    child: Row(
                      children: const [
                        SizedBox(width: 10),
                        Text('Settings',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black45)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'about',
                    child: Row(
                      children: const [
                        SizedBox(width: 10),
                        Text('About',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black45)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'Exit',
                    child: Row(
                      children: const [
                        SizedBox(width: 10),
                        Text('Exit',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.redAccent)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: IndexedStack(
            index: homeController.currentIndex.value,
            children: pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: homeController.currentIndex.value,
            selectedItemColor: const Color(0xFF110E47),
            onTap: (index) {
              homeController.changePage(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: '',
              ),
            ],
          ),
        ));
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TopRatedMovies(
          onSeeMore: () {
            Get.to(() => TopRatedMoviesList());
          },
        ),
        const SizedBox(height: 25),
        PopularMovies(
          onSeeMore: () {
            Get.to(() => PopularMoviesList());
          },
        ),
      ],
    );
  }
}
