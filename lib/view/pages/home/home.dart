import 'package:flimmix/view/pages/top_rate_movie/top_rate_list/top_rated_movies_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/popular_movie.dart';
import '../popular_movie/popular_movie_list/popular_movies_list.dart';
import '../popular_movie/popular_movies.dart';
import '../top_rate_movie/top_rated_movies.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PopularMovieController());

    return Scaffold(
      appBar: AppBar(
      title: const Text(
        'FilmMix',
        style: TextStyle(
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
            onSelected: (value) {
              // handle selection
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: const [
                    // Icon(Icons.settings, size: 18, color: Colors.grey),
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
                    // Icon(Icons.info_outline, size: 18, color: Colors.grey),
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
                value: 'logout',
                child: Row(
                  children: const [
                    // Icon(Icons.logout, size: 18, color: Colors.redAccent),
                    SizedBox(width: 10),
                    Text('Logout',
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
      body: ListView(
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
      ),
    );
  }
}
