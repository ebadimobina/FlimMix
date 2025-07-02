import 'package:flimmix/view/pages/home/binding.dart';
import 'package:flimmix/view/pages/home/home.dart';
import 'package:flimmix/view/pages/top_rate_movie/binding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import 'core/router/movie_pages.dart';
import 'core/router/movie_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: MovieRoutes.home,
      getPages: MoviePages.pages,
    );
  }
}
