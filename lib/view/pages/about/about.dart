import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutMePage extends StatelessWidget {
  const AboutMePage({super.key});

  final String coffeeLink = 'https://buymeacoffee.com/mobinaebadi';
  final String githubLink = 'https://github.com/ebadimobina';

  void launchURL(String urlString) async {
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
        title: Text('About Me'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Color(0xFF110E47),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, I\'m Mobina Ebadi',
              style: textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'I\'m a Flutter developer passionate about creating beautiful and functional mobile apps.',
              style: textTheme.bodyMedium,
            ),
            SizedBox(height: 24),
            Text(
              'If you like my work and want to support me, you can buy me a coffee or check out my GitHub projects!',
              style: textTheme.bodyMedium,
            ),
            SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => launchURL(coffeeLink),
                    icon: Icon(Icons.coffee),
                    label: Text('Buy Me a Coffee'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[300],
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                  SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => launchURL(githubLink),
                    icon: Icon(Icons.code),
                    label: Text('View GitHub'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
