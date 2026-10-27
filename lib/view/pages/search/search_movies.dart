import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/search_movie_controller.dart';
import '../../../core/widgets/movie_card.dart';

class SearchMoviesPage extends StatelessWidget {
  final bool isEmbedded;
  const SearchMoviesPage({super.key, this.isEmbedded = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<SearchMovieController>()
        ? Get.find<SearchMovieController>()
        : Get.put(SearchMovieController());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final searchController = TextEditingController(text: controller.searchText.value);

    final content = Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
          child: Obx(
            () => TextField(
              controller: searchController,
              onChanged: controller.onSearchTextChanged,
              decoration: InputDecoration(
                filled: true,
                fillColor: theme.cardColor,
                prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (controller.searchText.value.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear, size: 20, color: Colors.grey),
                        onPressed: () {
                          searchController.clear();
                          controller.clearSearch();
                        },
                      ),
                    IconButton(
                      icon: Icon(Icons.tune, color: theme.colorScheme.primary),
                      onPressed: () => _showFilterDialog(context, controller),
                      tooltip: 'Filter by rating',
                    ),
                  ],
                ),
                hintText: 'Search for movies and shows...',
                hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
            ),
          ),
        ),
        Obx(() {
          if (controller.errorMessage.value.isNotEmpty) {
            return Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                      const SizedBox(height: 12),
                      Text(
                        controller.errorMessage.value,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          if (controller.searchText.value.isEmpty) {
            return Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.search_rounded,
                      size: 64,
                      color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Type a title to search the database',
                      style: TextStyle(
                        fontSize: 15,
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Expanded(
            child: buildMoviesGrid(
              movies: controller.searchResults,
              isLoading: controller.isLoading.value,
              emptyMessage: 'No titles found matching "${controller.searchText.value}".',
            ),
          );
        }),
      ],
    );

    if (isEmbedded) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Movies'),
      ),
      body: content,
    );
  }

  void _showFilterDialog(BuildContext context, SearchMovieController controller) {
    final theme = Theme.of(context);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort by Rating',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => RadioGroup<String>(
                groupValue: controller.sortByRating.value,
                onChanged: (val) {
                  if (val != null) {
                    controller.sortByRating.value = val;
                    if (val == 'none') {
                      controller.searchMovie(controller.searchText.value);
                    } else {
                      controller.sortResults();
                    }
                    Get.back();
                  }
                },
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('Highest to Lowest Rating'),
                      value: 'high',
                      activeColor: theme.colorScheme.primary,
                    ),
                    RadioListTile<String>(
                      title: const Text('Lowest to Highest Rating'),
                      value: 'low',
                      activeColor: theme.colorScheme.primary,
                    ),
                    RadioListTile<String>(
                      title: const Text('Default Order'),
                      value: 'none',
                      activeColor: theme.colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
