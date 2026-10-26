import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../controllers/bookmark_movie.dart';
import '../../../controllers/theme_controller.dart';
import '../../../model/storage/local_storage_manager.dart';
import '../about/about.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeController = Get.isRegistered<ThemeController>()
        ? Get.find<ThemeController>()
        : Get.put(ThemeController(), permanent: true);

    // Self-contained reactive counts
    final savedMovies = LocalStorageManager.getBookmarks().obs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // Section: Appearance
          _buildSectionHeader('Appearance'),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: theme.dividerColor),
            ),
            child: Obx(
              () => SwitchListTile(
                title: const Text(
                  'Cinematic Dark Mode',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  themeController.isDark.value
                      ? 'Deep space obsidian theme'
                      : 'Bright clean theme',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
                secondary: Icon(
                  themeController.isDark.value
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  color: themeController.isDark.value
                      ? const Color(0xFF6B8AFF)
                      : Colors.amber.shade700,
                ),
                value: themeController.isDark.value,
                activeThumbColor: const Color(0xFF6B8AFF),
                onChanged: (val) {
                  themeController.switchTheme(val);
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Section: Library & Storage
          _buildSectionHeader('Library & Data'),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: theme.dividerColor),
            ),
            child: Obx(() {
              final total = savedMovies.length;
              final favs = savedMovies.where((m) => m.watchlistStatus == 'favorite').length;
              final watchlist = savedMovies.where((m) => m.watchlistStatus == 'watchlist').length;
              final watched = savedMovies.where((m) => m.watchlistStatus == 'watched').length;

              return Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.analytics_outlined, color: Color(0xFF5A7ED0)),
                    title: const Text('Saved Movies', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      '$total items ($favs Favorites • $watchlist Watchlist • $watched Watched)',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent),
                    title: const Text(
                      'Clear All Bookmarks',
                      style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Remove all saved movies from local storage',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                    onTap: () {
                      if (total == 0) {
                        Get.snackbar('Notice', 'No saved movies to clear.');
                        return;
                      }

                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: const Text('Clear All Bookmarks?'),
                          content: const Text(
                            'Are you sure you want to delete all saved movies? This action cannot be undone.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                LocalStorageManager.clearAll();
                                savedMovies.assignAll([]);

                                if (Get.isRegistered<BookMarkMoviesController>()) {
                                  Get.find<BookMarkMoviesController>().refreshFavorites();
                                }

                                Navigator.of(ctx).pop();
                                Get.snackbar(
                                  'Cleared',
                                  'All bookmarks removed successfully.',
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              },
                              child: const Text('Clear All', style: TextStyle(color: Colors.redAccent)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              );
            }),
          ),

          const SizedBox(height: 20),

          // Section: API & Data Source
          _buildSectionHeader('API & Engine'),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: theme.dividerColor),
            ),
            child: ListTile(
              leading: const Icon(Icons.cloud_done_outlined, color: Colors.green),
              title: const Text('TVMaze REST API', style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(
                'High speed, free, uncensored movies & shows database',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              trailing: const Icon(Icons.open_in_new, size: 18, color: Colors.grey),
              onTap: () {
                launchUrl(Uri.parse('https://www.tvmaze.com/api'), mode: LaunchMode.externalApplication);
              },
            ),
          ),

          const SizedBox(height: 20),

          // Section: About
          _buildSectionHeader('About & Developer'),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: theme.dividerColor),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline, color: Color(0xFF5A7ED0)),
                  title: const Text('About Developer', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    'Mobina Ebadi • Flutter Developer',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Get.to(() => const AboutMePage()),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info_outline, color: Colors.grey),
                  title: const Text('App Version', style: TextStyle(fontWeight: FontWeight.w600)),
                  trailing: const Text('1.0.0+1', style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
          color: Color(0xFF6B8AFF),
        ),
      ),
    );
  }
}
