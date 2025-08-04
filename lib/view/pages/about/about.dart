import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutMePage extends StatelessWidget {
  const AboutMePage({super.key});

  final String coffeeLink = 'https://buymeacoffee.com/mobinaebadi';
  final String githubLink = 'https://github.com/ebadimobina';

  void _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $urlString';
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About Me'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, I\'m Mobina Ebadi',
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'I\'m a Flutter developer passionate about creating beautiful and functional mobile apps.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Text(
              'If you like my work and want to support me, you can buy me a coffee or check out my GitHub projects!',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _launchURL(coffeeLink),
                    icon: const Icon(Icons.coffee),
                    label: const Text('Buy Me a Coffee'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[300],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => _launchURL(githubLink),
                    icon: const Icon(Icons.code),
                    label: const Text('View GitHub'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
