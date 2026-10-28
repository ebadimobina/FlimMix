import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
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
              () => Column(
                children: [
                  SwitchListTile(
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
                  if (themeController.isDark.value) ...[
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text(
                        'Pure AMOLED Black',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        'True #000000 black background for OLED energy saving',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                      ),
                      secondary: const Icon(
                        Icons.contrast,
                        color: Color(0xFF6B8AFF),
                      ),
                      value: themeController.isAmoled.value,
                      activeThumbColor: const Color(0xFF6B8AFF),
                      onChanged: (val) {
                        themeController.switchAmoled(val);
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Section: Library & Storage
          _buildSectionHeader('Library & Data (Open Source Backup)'),
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
                    leading: const Icon(Icons.file_upload_outlined, color: Color(0xFF5A7ED0)),
                    title: const Text('Export Watchlist (JSON)', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      'Backup your personal library to standard JSON',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                    onTap: () async {
                      if (total == 0) {
                        Get.snackbar('Notice', 'No saved movies to export.');
                        return;
                      }
                      final jsonString = LocalStorageManager.exportBookmarksJson();
                      await Clipboard.setData(ClipboardData(text: jsonString));
                      SharePlus.instance.share(
                        ShareParams(
                          text: jsonString,
                          subject: 'FilmMix Watchlist Backup',
                        ),
                      );
                      Get.snackbar(
                        'Exported',
                        'Backup copied to clipboard and ready to share.',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.file_download_outlined, color: Colors.green),
                    title: const Text('Import Watchlist (JSON)', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(
                      'Restore watchlist from a JSON backup',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                    ),
                    onTap: () {
                      _showImportDialog(context, savedMovies);
                    },
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
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.cloud_done_outlined, color: Colors.green),
                  title: const Text('Data Source', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    'TVMaze REST API (Free, uncensored, no API key required)',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.security, color: Color(0xFF5A7ED0)),
                  title: const Text('Privacy & Telemetry', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    '100% Tracker-Free • No ads • No analytical identifiers',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Section: About & Links
          _buildSectionHeader('About'),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: theme.dividerColor),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline, color: Color(0xFF5A7ED0)),
                  title: const Text('About Developer', style: TextStyle(fontWeight: FontWeight.w600)),
                  trailing: const Icon(Icons.chevron_right, size: 20),
                  onTap: () => Get.to(() => const AboutMePage()),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.code, color: Colors.purpleAccent),
                  title: const Text('GitHub Source Code', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    'Licensed under MIT • Contributions welcome',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                  trailing: const Icon(Icons.open_in_new, size: 18),
                  onTap: () => _openUrl('https://github.com/ebadimobina/filmmix'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showImportDialog(BuildContext context, RxList<dynamic> savedMovies) {
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Import Watchlist'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Paste your JSON backup data below to restore your saved movies:',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: textController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: '{"version": "1.0", "movies": [...]}',
                hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.all(10),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    final data = await Clipboard.getData(Clipboard.kTextPlain);
                    if (data?.text != null) {
                      textController.text = data!.text!;
                    }
                  },
                  icon: const Icon(Icons.paste, size: 16),
                  label: const Text('Paste from Clipboard', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final jsonText = textController.text.trim();
              if (jsonText.isEmpty) {
                Get.snackbar('Error', 'Please enter valid JSON backup text.');
                return;
              }
              final importedCount = LocalStorageManager.importBookmarksJson(jsonText);
              if (importedCount > 0) {
                savedMovies.assignAll(LocalStorageManager.getBookmarks());
                if (Get.isRegistered<BookMarkMoviesController>()) {
                  Get.find<BookMarkMoviesController>().refreshFavorites();
                }
                Navigator.of(ctx).pop();
                Get.snackbar(
                  'Success',
                  'Restored $importedCount movies to library.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              } else {
                Get.snackbar(
                  'Error',
                  'Could not parse backup JSON. Please check data format.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 0, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade500,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Future<void> _openUrl(String urlString) async {
    try {
      final Uri url = Uri.parse(urlString);
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      Get.snackbar('Error', 'Could not open link: $e');
    }
  }
}
