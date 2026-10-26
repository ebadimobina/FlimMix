import 'package:flimmix/controllers/theme_controller.dart';
import 'package:flimmix/core/service/theme_service.dart';
import 'package:flimmix/view/pages/settings/settings_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    const MethodChannel channel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return '.';
    });

    Get.testMode = true;
    await GetStorage.init();
    Get.put(ThemeController(), permanent: true);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('SettingsPage renders correctly', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: ThemeService.lightTheme,
        darkTheme: ThemeService.darkTheme,
        home: const SettingsPage(),
      ),
    );

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Cinematic Dark Mode'), findsOneWidget);
    expect(find.text('LIBRARY & DATA'), findsOneWidget);
    expect(find.text('TVMaze REST API'), findsOneWidget);
  });
}
