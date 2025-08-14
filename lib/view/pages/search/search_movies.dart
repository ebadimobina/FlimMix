import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/search_movie_controller.dart';
import '../../../core/widgets/movie_card.dart';

class SearchMoviesPage extends StatelessWidget {
  final controller = Get.put(SearchMovieController());
  final TextEditingController searchTextController = TextEditingController();
  SearchMoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: TextField(
            controller: searchTextController,
            onChanged: controller.onSearchTextChanged,
            style: TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade200,
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              suffixIcon: IconButton(
                icon: Icon(Icons.filter_list_alt, color: Colors.grey),
                onPressed: () => showFilterDialog(context),
                tooltip: 'Filter by rating',
              ),
              hintText: 'Search Movie',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        Obx(() => Expanded(
              child: buildMoviesGrid(
                title: '',
                movies: controller.searchResults,
                isLoading: controller.isLoading.value,
              ),
            )),
      ],
    );
  }

  void showFilterDialog(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sort by Rating',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            ListTile(
              title: Text('High to Low'),
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
              title: Text('Low to High'),
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
              child: Text('Close'),
            )
          ],
        ),
      ),
    );
  }
}
