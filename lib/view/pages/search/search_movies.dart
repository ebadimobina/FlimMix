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
              suffixIcon: IconButton(
                icon: const Icon(Icons.filter_list_alt, color: Colors.grey),
                onPressed: () => showFilterDialog(context),
                tooltip: 'Filter by rating',
              ),
              hintText: 'Search movie...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        Obx(() => Expanded(
              child: buildMoviesGrid(
                title: '',
                movies: controller.searchResults,
              ),
            )),
      ],
    );
  }

  void showFilterDialog(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Sort by Rating',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListTile(
              title: const Text('High to Low'),
              leading: Obx(() => Radio<String>(
                    value: 'high',
                    groupValue: controller.sortByRating.value,
                    onChanged: (value) {
                      controller.sortByRating.value = value!;
                      controller.sortResults();
                      Get.back();
                    },
                  )),
            ),
            ListTile(
              title: const Text('Low to High'),
              leading: Obx(() => Radio<String>(
                    value: 'low',
                    groupValue: controller.sortByRating.value,
                    onChanged: (value) {
                      controller.sortByRating.value = value!;
                      controller.sortResults();
                      Get.back();
                    },
                  )),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Close'),
            )
          ],
        ),
      ),
    );
  }
}
