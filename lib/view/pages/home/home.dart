import 'package:flimmix/view/pages/top_rate_movie/top_rate_movie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../top_rate_movie/top_rate_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FilmMix'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          TopRatedMovies(
            onSeeMore: () {
              Get.to(() => TopRatedListPage());
            },
          ),
        ],
      ),
    );
  }
}
