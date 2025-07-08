import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/search_movie_controller.dart';
import '../../../core/widgets/movie_card.dart';

class SearchMoviesPage extends StatelessWidget {
  SearchMoviesPage({super.key});

  final controller = Get.put(SearchMovieController());
  final TextEditingController searchTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            controller: searchTextController,
            onChanged: controller.onSearchTextChanged,
            style: const TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade200,
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              hintText: 'Search movie...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (controller.searchResults.isEmpty) {
              return const Center(child: Text('No Movie Founded'));
            }
            return buildMoviesGrid(
              title: 'Searching Result',
              movies: controller.searchResults,
            );
          }),
        ),
      ],
    );
  }
}
