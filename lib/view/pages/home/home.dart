import 'package:flimmix/view/pages/bookmark_movies/bookmark_movies.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller.dart';
import '../about/about.dart';
import '../popular_movie/popular_movie_list/popular_movies_list.dart';
import '../popular_movie/popular_movies.dart';
import '../search/search_movies.dart';
import '../top_rate_movie/top_rate_list/top_rated_movies_list.dart';
import '../top_rate_movie/top_rated_movies.dart';

class HomePage extends StatelessWidget {
  final controller = Get.put(HomeController());
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      HomeContent(),
      SearchMoviesPage(),
      BookMarkMoviesPage(),
    ];

    return Obx(() => Scaffold(
          appBar: AppBar(
            title: Text(
              'FilmMix',
              style: TextStyle(
                color: Color(0xFF110E47),
              ),
            ),
            centerTitle: true,
            actions: [
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.black),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                elevation: 3,
                onSelected: (value) {
                  if (value == 'about') {
                    Get.to(() => AboutMePage());
                  } else if (value == 'Exit') {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Exit App'),
                        content: Text('Are you sure you want to exit?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              SystemNavigator.pop();
                            },
                            child: Text('Exit'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'about',
                    child: Row(
                      children: [
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
                      children: [
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
            index: controller.currentIndex.value,
            children: pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            selectedItemColor: Color(0xFF110E47),
            onTap: (index) {
              controller.changePage(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  controller.currentIndex.value == 0
                      ? Icons.home
                      : Icons.home_outlined,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  controller.currentIndex.value == 1
                      ? Icons.search
                      : Icons.search_outlined,
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  controller.currentIndex.value == 2
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                ),
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
        SizedBox(height: 25),
        PopularMovies(
          onSeeMore: () {
            Get.to(() => PopularMoviesList());
          },
        ),
      ],
    );
  }
}
