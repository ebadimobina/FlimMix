import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutMePage extends StatelessWidget {
  const AboutMePage({super.key});

  final String coffeeLink = 'https://buymeacoffee.com/mobinaebadi';
  final String githubLink = 'https://github.com/ebadimobina';

  Future<void> _openUrl(String urlString) async {
    try {
      final Uri url = Uri.parse(urlString);
      final launched = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!launched) {
        Get.snackbar(
          'Error',
          'Could not open link in external browser.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to open $urlString: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('About Developer'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.dividerColor),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFF5A7ED0),
                    child: Icon(Icons.movie, color: Colors.white, size: 32),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FilmMix',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Version 1.0.0 (Pro Edition)',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Hi, I\'m Mobina Ebadi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'I\'m a Flutter developer passionate about creating beautiful, functional, and performant mobile applications.',
              style: TextStyle(
                fontSize: 14,
                color: theme.brightness == Brightness.dark
                    ? Colors.grey.shade400
                    : Colors.grey.shade700,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'FilmMix provides browse, search, watchlist management, and discovery powered by high-speed movie databases.',
              style: TextStyle(
                fontSize: 14,
                color: theme.brightness == Brightness.dark
                    ? Colors.grey.shade400
                    : Colors.grey.shade700,
                height: 1.5,
              ),
            ),
            const Spacer(),
            Center(
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _openUrl(coffeeLink),
                      icon: const Icon(Icons.coffee, size: 20),
                      label: const Text('Buy Me a Coffee'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _openUrl(githubLink),
                      icon: const Icon(Icons.code, size: 20),
                      label: const Text('View GitHub Profile'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
